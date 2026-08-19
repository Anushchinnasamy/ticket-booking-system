# ADR 002: Known Gap — Payment Success Racing Against Hold Expiry

## Status

Documented, not yet fixed (2026-08-19)

## Context

While manually verifying Phase 4 end-to-end against the real Razorpay API, a booking's 5-minute seat hold expired (correctly — the Phase 3 stale-booking sweep cancelled it and released the seat) *while* the payment was still being completed. When the payment was then verified as successful, the result was:

- `Payment.status = SUCCESS`
- `Booking.status = CANCELLED` (already flipped by the sweep before the payment resolved)
- The seat had already been released back to `AVAILABLE` — and could, in principle, be re-booked by someone else in the gap between the sweep running and the late payment being verified.

This is a real race, not a test artifact: `BookingService.confirmBooking` and `cancelBooking` (both introduced in Phase 4, `booking-service/src/main/java/com/ticketbooking/booking/service/BookingService.java`) each guard on `booking.getStatus() == PENDING` before acting — which correctly stops a late confirm from re-animating a cancelled booking, but doesn't stop the underlying inconsistency: the gateway now believes the charge succeeded, while our own system has already let the seat go.

## Why It Happens

The 5-minute hold (`booking.hold-ttl-minutes`) and the time a real user takes on Razorpay's checkout page are two independent clocks. Nothing currently extends the hold once a charge is *initiated* — `POST /payments/charge` only checks that the booking is `PENDING` at that instant, not that it will stay `PENDING` for as long as checkout takes.

## Impact

In a real system, this means a customer could be genuinely charged (Razorpay reports `SUCCESS`) for a seat that's no longer reserved for them. This is a correctness gap for the platform's *business* logic, even though every individual component (Redis locking, the sweep, idempotent charging) is behaving exactly as designed in isolation.

## Options Considered (Not Yet Implemented)

1. **Extend the hold on charge initiation.** When `POST /payments/charge` succeeds in creating a Razorpay order, push the booking's effective expiry out (e.g. re-touch `updated_at` and have the sweep key off that instead of `created_at`). Cheapest fix, but only shrinks the race window rather than closing it — a sufficiently slow checkout can still lose the race.
2. **Reconciliation on late success.** If `verify()` finds the booking is no longer `PENDING`, treat it as a failed reservation rather than a successful one: keep `Payment.status = SUCCESS` (the charge genuinely happened) but flag it for a refund, rather than silently leaving a paid-but-cancelled booking. This is the more production-realistic answer — real payment platforms refund/reconcile rather than pretend the timing never happened — but needs a refund flow this project doesn't have yet.
3. **Hold the Redis lock (not just the booking row) as the source of truth for "is this seat still mine,"** and have `verify()` check the lock is still held by re-deriving it, failing the confirmation path (triggering a refund per option 2) if it isn't.

None of these are implemented in Phase 4 — this ADR exists so the gap is documented rather than silently discovered later. The natural place to close it is alongside Phase 9 (Resilience Patterns), which already deals with compensating actions for partial failure, or Phase 13 (Cancellation/Refund), which is where a real refund flow would land.
