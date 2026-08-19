# Event Ticket Booking System — Backend Build Plan

A distributed, BMS-style booking backend covering movies, concerts, sports, and comedy shows on one unified catalog. The point of this project is not the CRUD — it's proving correctness under concurrent load, idempotent payments, and graceful failure recovery.

---

## 1. Tech Stack

| Layer | Choice |
|---|---|
| Language / Framework | Java 17, Spring Boot 3.x |
| API Gateway | Spring Cloud Gateway |
| Concurrency / Locking | Redis + Redisson (`RLock`) |
| Messaging | Apache Kafka |
| Persistence | PostgreSQL (one schema/DB per service) |
| Cache | Redis |
| Resilience | Resilience4j (circuit breaker, retry) |
| Auth | Spring Security + JWT |
| Email / SMTP | Spring Mail — real SMTP via Gmail App Password (free, simplest to demo) or Brevo/SendGrid free tier (300 emails/day, more production-realistic) |
| QR / Ticketing | ZXing (QR generation), PDFBox (ticket PDF), MinIO/S3-compatible storage |
| Testing | JUnit 5, Testcontainers, k6 or JMeter for load tests |
| Observability | Micrometer + Prometheus + Grafana |
| Containerization | Docker Compose (local), structured for future K8s |
| Build | Maven (multi-module) or Gradle — pick one, stay consistent |

---

## 2. Repository Structure

```
ticket-booking-system/
├── event-service/
├── booking-service/          # includes ticketing/QR module — see Phase 7
├── payment-service/
├── user-service/
├── notification-service/
├── api-gateway/
├── common-lib/              # shared DTOs, exceptions, Kafka event schemas
├── docker-compose.yml       # Postgres x N, Redis, Kafka, Zookeeper, MinIO, all services
├── load-tests/              # k6/JMeter scripts
└── docs/
    ├── architecture.md
    └── adr/                 # Architecture Decision Records — one file per major decision
```

Multi-module Maven/Gradle repo, each service independently runnable via its own `docker-compose` profile during early phases, full compose file once all services exist.

---

## 3. Domain Model Recap

```
Event (category: MOVIE | CONCERT | SPORTS | COMEDY)
  └── Show (specific date/time/venue instance)
        └── SeatMap
              └── Seat (status: AVAILABLE | LOCKED | BOOKED)

Booking (status: PENDING | CONFIRMED | CHECKED_IN | CANCELLED)
Payment (idempotencyKey, status: INITIATED | SUCCESS | FAILED)
User (roles: CUSTOMER | ADMIN | COUNTER_STAFF)
PasswordResetToken (userId, tokenHash, expiresAt, used)
Waitlist (showId, userId, position)
Ticket (bookingId, qrPayload, shareToken, pdfPath)
```

The `Event → Show` split is what lets one backend serve every category without special-casing — a movie's "show" is a screening slot, a concert's "show" is the one live date.

---

## 4. Phase-by-Phase Plan

### Phase 0 — Foundations & Environment
**Goal:** a repo that runs, before any business logic exists.

- Set up multi-module repo structure above
- `docker-compose.yml` with Postgres, Redis, Kafka + Zookeeper, each on isolated ports
- `common-lib` module: shared exception types, base DTOs, Kafka event contracts (as Java records)
- CI skeleton: GitHub Actions running `mvn test` on push
- Each service boots with a `/actuator/health` endpoint returning 200

**Definition of done:** `docker compose up` brings up all infra; each service module compiles and starts against it.

---

### Phase 1 — Event Service (Catalog)
**Goal:** browse events, shows, venues, seat maps. Read-heavy, no concurrency concerns yet.

- Entities: `Event`, `Venue`, `Show`, `SeatMap`, `Seat`
- Endpoints: `GET /events`, `GET /events/{id}`, `GET /shows/{id}/seats`, admin `POST /events` (seed data)
- Flyway/Liquibase migrations from day one — don't hand-edit schemas later
- Seed script: a handful of movies, one concert, one cricket match, each with a seat map (mix of small and large venues to stress-test later phases)

**Definition of done:** can fetch a seat map with seat statuses via REST, verified with Postman/integration test.

---

### Phase 2 — Booking Service Core (No Concurrency Yet)
**Goal:** the booking state machine, single-instance correctness first.

- Entity: `Booking` (PENDING/CONFIRMED/CHECKED_IN/CANCELLED), linked to `Show` + `Seat` IDs
- Endpoints: `POST /bookings` (creates PENDING booking, marks seat LOCKED via plain DB update)
- Use `SELECT FOR UPDATE` in the repository layer as the first-pass locking mechanism — this gives you a correctness baseline to compare Redis locking against later
- Write the concurrency test now, even though it'll fail interestingly: a script firing 100 concurrent requests at 10 seats

**Definition of done:** single-instance load test shows zero overselling using DB-level locking. Note the throughput number — you'll compare it against Redis locking in Phase 3.

---

### Phase 3 — Distributed Locking (Redis)
**Goal:** the centerpiece of the whole project.

- Integrate Redisson
- Lock key pattern: `seat:{showId}:{seatId}`, TTL 5 minutes
- Flow: `tryLock()` → on success, create PENDING booking → on failure, return 409 "seat unavailable"
- Background job (Redisson's built-in TTL, or a Spring `@Scheduled` sweep) auto-releases seats whose lock expired without confirmation
- Re-run the same concurrency load test from Phase 2, compare throughput and correctness against the `SELECT FOR UPDATE` baseline
- Write this comparison up as your first ADR (`docs/adr/001-locking-strategy.md`) — this is the artifact that turns into your best interview story

**Definition of done:** 500 concurrent requests against 50 seats → exactly 50 bookings created, zero oversold, results logged with before/after throughput numbers.

---

### Phase 4 — Payment Service & Idempotency
**Goal:** charge without double-charging, ever.

- Entity: `Payment` (idempotencyKey — unique constraint, status, amount, bookingId)
- Endpoint: `POST /payments/charge` — client supplies `Idempotency-Key` header
- Logic: check for existing key first; if found, return the stored result instead of re-charging; if not found, process and store atomically
- Mock payment gateway (random success/failure injectable via a config flag — you'll need controllable failure for the chaos testing phase)
- On success: Booking service moves `PENDING → CONFIRMED`. On failure: compensating step releases the Redis lock and marks `CANCELLED`

**Definition of done:** firing the same charge request twice (simulating a client retry after timeout) results in exactly one charge, verified by a test asserting `Payment` row count stays at 1.

---

### Phase 5 — User Service & Auth
**Goal:** core auth is standard and low-risk — don't over-invest there. The forgot-password and OTP flows below are where the real engineering is, because they're the two places auth logic touches an external system (SMTP) and have to handle it securely.

**Core auth:**
- JWT-based auth, roles: `CUSTOMER`, `ADMIN`, `COUNTER_STAFF`
- Endpoints: register, login, refresh token, profile
- Secure booking/payment endpoints behind the JWT filter
- `COUNTER_STAFF` role gets a simplified booking flow later (Phase 13) that skips payment

**Forgot password — real SMTP, not a stub:**
- `POST /auth/forgot-password` — accepts an email; always returns a generic 200 regardless of whether the email exists, so the endpoint can't be used to enumerate registered users
- Generate a cryptographically random 32-byte token. Store only its hash (`PasswordResetToken.tokenHash`) with a 15-minute expiry — same principle as never storing plaintext passwords, applied to reset tokens, since anyone with DB read access shouldn't be able to reset accounts
- Publish a `password-reset-requested` event (email + raw token + expiry) onto Kafka rather than calling SMTP directly from User Service — the Notification service (already built in Phase 6) consumes it and sends the real email. This keeps SMTP credentials and mail-sending logic in one place instead of duplicated across every service that needs to email someone
- Real SMTP config via `spring-boot-starter-mail`: Gmail App Password is the fastest free path for a demo video; Brevo or SendGrid's free tier (300/day) is a better answer if an interviewer asks "would this work in production" — Gmail SMTP has sending limits and reputation issues at scale, a transactional provider doesn't. Credentials go in environment variables / `application-secrets.yml`, never committed to git
- `POST /auth/reset-password` — token + new password; validate the token's hash matches, isn't expired, and isn't already used; hash the new password, mark the token used, invalidate any other outstanding tokens for that user
- Rate limit `forgot-password` per email (e.g. 3 requests/hour via a Redis counter) — otherwise it's a free tool for spamming someone's inbox

**OTP passwordless login (optional stretch):**
- `POST /auth/otp/request` — email in, generate a 6-digit numeric OTP, store its hash in Redis with a 5-minute TTL (Redis is the right store here, not Postgres — it's inherently ephemeral data)
- Publish an `otp-requested` event the same way as password reset, Notification service sends it by real email (SMS via Twilio is the natural next step but costs money per message, worth mentioning as a "would extend to SMS in production" line rather than actually paying for it in a portfolio project)
- `POST /auth/otp/verify` — email + OTP; check against the stored hash, single-use (delete from Redis on success or failure — don't allow retries against the same OTP), issue a JWT on match
- Rate limit OTP requests per email (e.g. 3 per 10 minutes) — same reasoning as forgot-password, doubly important if you ever add paid SMS
- This runs alongside password login, not instead of it — some users still want a password, OTP is an alternate path, which is how most real apps (banking apps, Swiggy, etc.) actually do it

**Definition of done:** unauthenticated booking requests get 401; role-gated admin endpoints reject non-admins; a forgot-password request delivers a real email with a working reset link, and the same reset token rejected on second use; an OTP delivered by email logs a user in without a password, and a second verify attempt with the same OTP fails.

---

### Phase 6 — Kafka & Notification Service
**Goal:** decouple the slow stuff from the booking response path.

- Topics: `booking-confirmed`, `booking-cancelled`, `seat-status-changed`, `password-reset-requested`, `otp-requested`
- Booking service publishes on every state transition
- Notification service consumes all of the above and sends real email via the same Spring Mail/SMTP setup built in Phase 5 — one mail-sending code path shared across booking confirmations, cancellations, password resets, and OTPs, rather than duplicating SMTP logic per service
- Booking service's `POST /bookings` response should return the moment the DB write succeeds — notification happens fully async, verify this with a latency assertion in a test

**Definition of done:** booking confirmation response time doesn't include notification latency; Kafka consumer lag stays near-zero under load.

---

### Phase 7 — Ticketing: QR Generation & Sharing
**Goal:** turn a CONFIRMED booking into a scannable, shareable, fraud-resistant ticket.

Keep this inside the Booking service as a `TicketService`/`TicketController` rather than spinning up a sixth microservice — it operates directly on booking data and doesn't need its own database.

- **Trigger:** same `booking-confirmed` Kafka event Notification consumes in Phase 6 — ticket generation is another async consumer of that event, so it never blocks the booking response
- **QR payload — sign it, don't just encode the ID:** HMAC-SHA256 over `bookingId + showId + seatId + timestamp` using a server-side secret, base64-encoded into the QR. A raw booking ID in the QR means anyone can forge one by guessing IDs — signing it is the difference between "I added a QR code" and "I added a QR code that can't be spoofed," which is exactly the kind of detail an interviewer will ask about if you don't mention it first
- **QR image generation:** ZXing library, PNG output — standard, don't hand-roll this
- **Ticket PDF:** PDFBox bundling event/show/seat details + the QR image, stored in MinIO (S3-compatible, runs locally in Docker Compose) keyed by `bookingId`
- **Endpoints:**
  - `GET /bookings/{id}/ticket` — authenticated, owner-only, returns the PDF
  - `POST /bookings/{id}/share` — generates a short-lived signed share token (24h expiry), returns a public URL `/t/{shareToken}`
  - `GET /t/{shareToken}` — public, no auth required, resolves the token and renders a lightweight ticket view. **This is the URL that actually gets opened when someone taps a WhatsApp-shared link** — the recipient never needs the app or an account
- **Redemption (venue check-in) — reuses your core concurrency theme:**
  - `POST /tickets/redeem` — staff/gate app scans the QR and posts the payload
  - Backend verifies the HMAC signature first (reject forged QRs outright), then performs an atomic conditional update: `UPDATE booking SET status='CHECKED_IN' WHERE id=? AND status='CONFIRMED'`
  - If zero rows affected, the ticket was already redeemed — reject with "already used." Same screenshot of a ticket shown at two gates at once, tested the same way you tested seat overselling: fire two concurrent redeem requests, assert exactly one succeeds

**Definition of done:** booking confirmation triggers QR + PDF generation without adding latency to the booking response; a share link opens and displays the ticket without login; two concurrent redemption attempts on the same QR produce exactly one success and one "already redeemed" rejection.

---

### Phase 8 — API Gateway & Rate Limiting
**Goal:** protect the system, not just route to it.

- Spring Cloud Gateway routes to all services
- Token-bucket rate limiter (Redis-backed) specifically on `POST /bookings/lock`, scoped per user ID — this is the control that stops one person scripting 200 lock attempts a second during a flash sale
- Centralized request logging with a correlation ID header, propagated through all downstream calls (you'll want this in Phase 11)

**Definition of done:** a script hammering the lock endpoint past the configured limit gets 429s while normal traffic is unaffected.

---

### Phase 9 — Resilience Patterns
**Goal:** prove the system degrades gracefully instead of cascading.

- Resilience4j circuit breaker on Booking → Payment service calls
- Retry with exponential backoff on transient Kafka publish failures
- Chaos test: kill the Payment service mid-transaction (docker stop the container) during an active load test — confirm the Booking service's circuit breaker opens, requests fail fast instead of hanging, and once Payment comes back the compensating cancellation flow correctly cleans up any bookings stuck in PENDING
- Document this chaos run — screenshot or log excerpt — this is the single most convincing artifact in your whole portfolio for "have you actually dealt with partial failure"

**Definition of done:** killing Payment service mid-load-test produces bounded failures (fast 5xx, no indefinite hangs), and PENDING bookings from that window get cleaned up automatically once lock TTLs expire.

---

### Phase 10 — Caching Strategy
**Goal:** seat map reads shouldn't hit Postgres every time.

- Cache-aside pattern: `GET /shows/{id}/seats` checks Redis first, falls back to DB, writes through on miss
- Invalidate the specific seat's cache entry on every lock/booking/release — not the whole show's cache, that would create needless cache-storms during a flash sale
- TTL as a safety net even without explicit invalidation (30-60s)

**Definition of done:** load test shows seat-map read latency staying flat even as booking write volume increases; cache hit-rate logged.

---

### Phase 11 — Observability
**Goal:** you should be able to *see* the system working, not just trust it.

- Micrometer metrics exposed to Prometheus: request latency (p50/p95/p99), lock contention count, Kafka consumer lag, circuit breaker state, ticket redemption rejection count
- Grafana dashboard: one panel per metric above
- Structured JSON logging with the correlation ID from Phase 8 threaded through every service

**Definition of done:** a Grafana screenshot showing latency and lock-contention panels during your Phase 3/9 load tests, saved into `docs/`.

---

### Phase 12 — Load Testing & Chaos Testing (Formal Pass)
**Goal:** consolidate everything you tested ad hoc in earlier phases into repeatable, documented test suites.

- k6/JMeter script: ramp from 50 to 5,000 requests/sec over 2 minutes against a 50-seat show, matching the flash-sale estimate from the system design
- Assert: zero overselling, p99 latency under a target threshold, no unbounded error rates
- Chaos script: automate the Phase 9 kill-Payment-mid-test scenario so it's re-runnable, not a one-off manual step
- Also load-test the redemption endpoint from Phase 7: fire concurrent redeem requests for the same ticket, assert exactly one succeeds
- Save results (raw output + a short written summary) into `docs/load-test-results.md` — this becomes the numbers you quote in interviews

**Definition of done:** all scripts are committed, runnable with one command, and their output is captured in `docs/`.

---

### Phase 13 — Waitlist & Cancellation/Refund
**Goal:** round out the product surface without adding new architectural risk.

- Waitlist entity: FIFO per show, notified via Kafka when a `booking-cancelled` event frees a seat
- Cancellation endpoint: refund via mock payment gateway, seat returns to AVAILABLE, waitlist is checked, ticket/QR is invalidated (redemption endpoint must reject a cancelled booking's QR even if it wasn't yet redeemed)
- Counter-staff booking flow (from Phase 5's role): `POST /bookings/counter-sale` — skips payment, marks CONFIRMED directly, still generates a ticket via Phase 7's pipeline

**Definition of done:** cancelling a booking on a sold-out show notifies the next waitlisted user within one Kafka round-trip, and the cancelled booking's QR is rejected at redemption.

---

### Phase 14 — Containerization & Deployment Readiness
**Goal:** package it so anyone (including an interviewer) can run it in one command.

- Dockerfile per service, multi-stage build to keep images small
- Full `docker-compose.yml` bringing up all services + infra (including MinIO) with one command
- `README.md` at repo root: architecture diagram, one-command startup, a curl/Postman collection walking through a full booking flow (including fetching the ticket and hitting the redeem endpoint), and the load-test numbers from Phase 12 front and center
- Optional stretch: Helm chart or raw K8s manifests if you want to show cloud-native packaging, not required for the core story

**Definition of done:** a stranger can clone the repo, run `docker compose up`, and complete a full booking-to-redemption flow using only the README.

---

## 5. Milestone Checklist

- [ ] Phase 0 — repo boots, infra up
- [ ] Phase 1 — catalog browsable
- [ ] Phase 2 — booking works single-instance, baseline load test done
- [ ] Phase 3 — Redis locking proven correct under load (the headline result)
- [ ] Phase 4 — payment idempotency proven
- [ ] Phase 5 — auth in place, forgot-password delivers real email, OTP login works end-to-end
- [ ] Phase 6 — async notifications decoupled
- [ ] Phase 7 — QR ticket generation, share link, and fraud-resistant redemption working
- [ ] Phase 8 — gateway + rate limiting live
- [ ] Phase 9 — chaos test passes, documented
- [ ] Phase 10 — caching in place, latency flat under load
- [ ] Phase 11 — Grafana dashboard live
- [ ] Phase 12 — formal load + chaos test suite committed
- [ ] Phase 13 — waitlist and cancellation working
- [ ] Phase 14 — one-command startup, README complete

---

## 6. What "done" looks like for the portfolio

By the end, your README's ownership paragraph should read something like:

> Designed and built a distributed event ticket booking system across five Spring Boot microservices. Used Redisson distributed locks with TTL-based auto-release to guarantee zero overselling — load tested at 5,000 requests/sec against 50 seats with zero oversold bookings and p99 latency of X ms. Implemented idempotent payment processing, HMAC-signed QR tickets with atomic, fraud-resistant redemption, a Kafka-based async notification pipeline handling real SMTP delivery for booking confirmations, password resets, and OTP-based passwordless login, and a chaos test that verifies the system recovers correctly when the Payment service is killed mid-transaction.

That's the sentence that gets a system-design conversation started in an interview, instead of a silent nod at "I used Spring Boot."

---

## Next steps

Once Phase 0-3 are done, this is a good point to generate the `CLAUDE.md` for consistent Claude Code sessions on this repo — same format as RecruitFlow AI and ChatFlow. Ask when you're ready.
