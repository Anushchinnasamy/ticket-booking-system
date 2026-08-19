# ADR 001: Seat Locking Strategy — Postgres `SELECT ... FOR UPDATE` vs Redis Distributed Lock

## Status

Accepted (2026-08-19)

## Context

The core correctness requirement of this system is that a seat can never be sold to two people at once, even when many concurrent requests target the same seat. `Seat.status` (AVAILABLE / LOCKED / BOOKED) is owned by event-service, in its own Postgres database; `Booking` is owned by booking-service, in a separate database. Any locking strategy has to work across that service boundary — booking-service can't just wrap a local transaction around both the seat check and the booking insert, because the seat row isn't in its database.

Two strategies were built and load-tested against each other:

1. **Phase 2 baseline** — a Postgres-level pessimistic lock (`SELECT ... FOR UPDATE`) on the seat row, held for the duration of a single HTTP request into event-service.
2. **Phase 3** — a Redis distributed lock (Redisson `RLock`), acquired by booking-service *before* it ever calls event-service, and held for the full reservation window (5 minutes), not just the duration of one request.

Both were tested against the same scenario: **500 concurrent `POST /bookings` requests fired at a 50-seat show**, expecting exactly 50 successes and zero overselling. The database and Redis were reset to clean seed state between runs so the two results are directly comparable.

## Decision

Use the **Redis distributed lock (Redisson)** as the production locking mechanism, replacing the `SELECT ... FOR UPDATE` call in booking-service's `POST /bookings` flow. The Postgres pessimistic-lock endpoint (`ShowController#lockSeat` / `ShowService#lockSeat` / `SeatRepository#findByIdAndShowIdForUpdate` in event-service) is kept in the codebase, unused by the current flow, as a working reference implementation — it's what produced the "before" numbers below and it's still fully correct on its own.

### How it works

- **Lock key pattern:** `seat:{showId}:{seatId}`
- **TTL:** 5 minutes (`booking.hold-ttl-minutes`), passed as Redisson's `leaseTime`
- **Acquisition:** `tryLock(waitTime=0, leaseTime=5min)` — non-blocking. If the key is already held, it fails immediately rather than queuing, which maps directly to returning `409 Conflict` to the client instead of making them wait.
- **Flow:** `tryLock()` → on success, call event-service's new plain `POST /shows/{showId}/seats/{seatId}/claim` endpoint (no DB-level lock — safe only because the Redis lock already serialized access to this key) → create a `PENDING` booking. On lock failure, return `409 "seat unavailable"` without ever calling event-service.
- **The lock is deliberately not released on success.** It represents the seat reservation itself — the 5-minute window a user has to complete payment — not a brief mutex around one write. It's released by:
  - Redisson's own TTL, which prevents the *lock* from being held forever if a booking-service instance crashes mid-flow; or
  - The stale-booking sweep (`StaleBookingSweeper`, `@Scheduled` every 60s in booking-service), which is what actually satisfies "auto-releases seats whose lock expired without confirmation" — Redis's TTL only expires the *lock object*, it has no way to know that Postgres's `seats.status` column should also flip back to AVAILABLE. The sweep finds `PENDING` bookings older than the hold TTL, calls event-service's new `POST /shows/{showId}/seats/{seatId}/release` endpoint, force-unlocks the Redis key (covering the small window where the sweep runs slightly before Redis's own TTL expiry), and cancels the booking.

This auto-release path was verified live against a running instance (`BOOKING_HOLD_TTL_MINUTES=1` override, so the wait didn't have to be the full 5 minutes): a booking created at `07:05:50 UTC` had its seat flip from `LOCKED` back to `AVAILABLE` and its booking status flip from `PENDING` to `CANCELLED` by `07:07:51 UTC` — 121 seconds later, consistent with the 1-minute hold TTL plus one 60-second sweep tick — with no manual intervention.

## Results

| Scenario | Mechanism | Requests | Seats | Successes | Conflicts | Overselling | Wall-clock | Throughput |
|---|---|---|---|---|---|---|---|---|
| Before | Postgres `SELECT ... FOR UPDATE` | 500 | 50 | 50 | 450 | **None** | 2.686s | **186.1 req/s** |
| After | Redis distributed lock (Redisson) | 500 | 50 | 50 | 450 | **None** | 1.504s | **332.5 req/s** |

Both mechanisms achieved the correctness requirement: exactly 50 bookings created, zero seats double-booked, under 500 truly concurrent requests. Redis locking was **~1.8x the throughput** of the Postgres row-lock baseline for this workload, and completed the same 500-request burst in roughly 56% of the time.

Reproduce with `load-tests/locking_load_test.py` (stdlib-only Python — no extra dependencies) against either implementation.

## Alternatives Considered

- **Optimistic locking (version column + retry on conflict).** Rejected as the primary mechanism: under heavy contention on a single hot seat, this produces many wasted round trips (read, fail, retry) rather than one request winning cleanly. It could still be layered in later as a lighter-weight alternative for low-contention resources, but seat booking during a flash sale is exactly the high-contention case this project cares about.
- **Application-level in-memory lock (e.g., a `ConcurrentHashMap` of seat IDs).** Rejected outright — it only works for a single instance. The moment booking-service runs as more than one replica (which it will, eventually), an in-memory lock stops providing any real guarantee. This is the whole reason a *distributed* lock is needed.
- **Keep Postgres `SELECT ... FOR UPDATE` as the only mechanism.** Rejected as the production path, but deliberately kept in the codebase — it's simple, doesn't add an infrastructure dependency, and the numbers above show it's still correct. For a system without Redis already in the stack, this would be a perfectly reasonable permanent choice. Here, Redis is already part of the architecture (caching in Phase 10, rate limiting in Phase 8), so the additional operational cost of relying on it for locking too is small, and the throughput win is real.

## Consequences

- Booking-service now has a hard runtime dependency on Redis for `POST /bookings` to work at all — if Redis is down, seat locking fails closed (no lock acquired → no booking created), which is the correct failure mode for a system whose top priority is never overselling.
- The 5-minute hold is real reserved capacity: a `PENDING` booking that never completes payment (Phase 4) makes a seat unbookable by anyone else for up to 5 minutes, bounded by the sweep. This is intentional — it mirrors how real box-office/ticketing systems hold a seat while a buyer is on the payment page.
- Two separate "mark this seat unavailable" endpoints now exist in event-service (`/lock` with DB locking, `/claim` without). This is a deliberate, documented split — `/claim` is only safe to call when the caller already holds external exclusivity — not an accidental duplication.
