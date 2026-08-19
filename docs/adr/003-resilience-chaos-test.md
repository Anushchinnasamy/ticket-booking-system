# ADR 003: Resilience Patterns — Circuit Breaker, Retry, and a Live Chaos Test

## Status

Implemented and verified live (2026-08-19)

## Context

The build plan's Phase 9 goal is "prove the system degrades gracefully instead of cascading," described as a circuit breaker on "Booking → Payment service calls." That direction doesn't exist in this system: booking-service never calls payment-service. The real synchronous dependency runs the other way — **payment-service calls booking-service** (`BookingServiceClient.getBooking`/`confirmBooking`/`cancelBooking`), on the critical path of `charge`/`verify`/`fail`. This ADR documents the corrected scope, the two patterns added, and the two live chaos runs that prove them.

## What Was Added

**Circuit breaker** (`payment-service`, Resilience4j `@CircuitBreaker(name = "booking-service")` on all three `BookingServiceClient` methods):
- Count-based sliding window, size 10, minimum 5 calls before evaluating, 50% failure-rate threshold, 10s wait in OPEN, 3 trial calls in HALF_OPEN, automatic OPEN→HALF_OPEN transition.
- `ResourceNotFoundException` (booking-service correctly answering "no such booking") is explicitly excluded from failure counting — a 404 is a healthy response, not a sign the dependency is down.
- Paired with an explicit RestClient connect timeout (2s) and read timeout (3s) — a circuit breaker alone doesn't bound a *hung* (not merely unreachable) dependency; the timeout is what actually guarantees "fail fast" in that case.
- `CallNotPermittedException` (thrown when the breaker is OPEN) maps to `503 SERVICE_UNAVAILABLE` in `GlobalExceptionHandler`.

**Retry with exponential backoff** (`common-lib`'s `RetryingPublisher`, used by both `booking-service` and `event-service`'s Kafka publish call sites):
- Wraps `KafkaTemplate.send(...)` with Resilience4j `Retry.decorateCompletionStage` — 3 attempts, exponential backoff (200ms → 400ms → 800ms).
- Fully async: retries are scheduled on a dedicated daemon `ScheduledExecutorService`, never block the calling thread. Proven with a unit test asserting the wrapper returns immediately even when the wrapped operation never completes (`RetryingPublisherTest.withRetry_doesNotBlockTheCallingThread`).

## Chaos Test 1: Kill booking-service, hammer payment-service

Sequence: created a real booking, confirmed the breaker started `CLOSED`, killed booking-service's process, then fired sequential `POST /payments/charge` requests.

| Requests | What happened | Evidence |
|---|---|---|
| 1–5 | Real connection failures (booking-service is gone) — each request genuinely attempts the call and fails, 131–677ms | `500 INTERNAL_ERROR` |
| 6–15 | Breaker OPEN — rejected in-process, no network attempt, 63–172ms | `503 SERVICE_UNAVAILABLE` |

Log evidence (`payment-service`, `CircuitBreakerLoggingConfig`):

```
17:38:20.308  WARN  Circuit breaker [booking-service] CLOSED -> OPEN
17:38:30.320  WARN  Circuit breaker [booking-service] OPEN -> HALF_OPEN        (automatic, after 10s wait)
17:38:52.342  WARN  Circuit breaker [booking-service] HALF_OPEN -> OPEN        (3 trial calls, booking-service still down, all failed)
17:39:02.343  WARN  Circuit breaker [booking-service] OPEN -> HALF_OPEN        (automatic, after another 10s wait)
17:39:41.099  WARN  Circuit breaker [booking-service] HALF_OPEN -> CLOSED      (booking-service restarted; trial calls against a real booking succeeded)
```

`GET /actuator/circuitbreakers` before/after matched the log exactly (`CLOSED` → `OPEN` → `HALF_OPEN` → `OPEN` → `HALF_OPEN` → `CLOSED`), including `failedCalls: 3`, `notPermittedCalls: 1` recorded during the failed HALF_OPEN trial.

**Result:** every single request during the outage returned in well under a second — no hangs, no indefinite waits — and the breaker's own state machine self-managed the transition from "stop trying" back to "cautiously trying again" to "fully recovered," without any manual intervention.

## Chaos Test 2: Kill payment-service mid-transaction

Sequence (booking-service restarted with `BOOKING_HOLD_TTL_MINUTES=1` for a fast test — same technique used in Phase 3's sweep verification):

1. `12:10:39` — created booking `e4177dd2-...` (`PENDING`), initiated a charge (`Payment.status = INITIATED`, a real Razorpay order created).
2. `12:10:48` — killed payment-service's process. The booking is now orphaned: `PENDING` in booking-service, `INITIATED` in a payment-service that no longer exists to ever call back with `/verify`.
3. Waited. No intervention.
4. `12:12:24` — `StaleBookingSweeper`'s next tick found the booking past its 1-minute hold TTL and called `BookingService.cancelBooking` — the *same* compensating method payment-service itself would call on a failed charge — releasing the seat and cancelling the booking. This required zero interaction with payment-service; the sweep only talks to booking-service's own DB and to event-service.

```sql
-- booking_db
id=e4177dd2-...  status=CANCELLED  created_at=12:10:39.373453  updated_at=12:12:24.401526

-- event_db
seat b982a395-...  status=AVAILABLE
```

```
17:41:24  INFO  StaleBookingSweeper -- Released 1 expired seat hold(s)
17:42:24  INFO  StaleBookingSweeper -- Released 1 expired seat hold(s)   (this tick caught e4177dd2-...)
```

Payment-service was then restarted, confirmed healthy, and booking-service was restarted with its normal 5-minute TTL — full recovery, no manual cleanup needed anywhere.

**Result:** the compensating cleanup the DoD asks for ("PENDING bookings from that window get cleaned up automatically once lock TTLs expire") was already built in Phase 3 (`StaleBookingSweeper`) and needed no changes for Phase 9 — it's inherently payment-service-agnostic, since it only acts on booking-service's own state and a TTL clock, never waiting on payment-service to "come back."

## Known Related Gap (Not This ADR's Scope)

[ADR 002](002-payment-confirmation-race.md) documents a narrower, different race: a payment that resolves as `SUCCESS` *after* the sweep has already cancelled its booking. That gap is about payment-service being *slow*, not *down*, and remains unfixed — deferred to Phase 13 (refund flow) as ADR 002 already states. Nothing in this ADR changes that.

## Definition of Done

- [x] Killing a dependency mid-load produces bounded failures (fast 4xx/5xx, no indefinite hangs) — worst case observed was 677ms, bounded by the configured RestClient timeout.
- [x] PENDING bookings from the outage window get cleaned up automatically once lock TTLs expire — verified with zero manual intervention, sweep ran on its normal schedule.
