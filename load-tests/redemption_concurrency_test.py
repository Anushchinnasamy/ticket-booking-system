"""
Phase 12 formal pass on the Phase 7 redemption race: creates a real
CONFIRMED booking (through an actual Razorpay-signed payment, same HMAC
technique used throughout this project), waits for its ticket to be
generated, then fires N concurrent POST /tickets/redeem requests carrying
the *same* QR payload. Asserts exactly one succeeds and the rest get a 409
"already redeemed" -- the atomic conditional UPDATE in
BookingRepository.checkInIfConfirmed is what guarantees this, the same
principle as the Phase 2/3 seat-locking work.

Requires all 6 services + native infra already running.

Usage:
    python load-tests/redemption_concurrency_test.py
"""

import concurrent.futures
import hashlib
import hmac
import json
import os
import subprocess
import time
import urllib.error
import urllib.request
import uuid

EVENT_SERVICE_URL = "http://localhost:8081"
BOOKING_SERVICE_URL = "http://localhost:8082"
PAYMENT_SERVICE_URL = "http://localhost:8083"
USER_SERVICE_URL = "http://localhost:8084"
SHOW_ID = "33333333-3333-3333-3333-333333333301"

RAZORPAY_KEY_SECRET = "1VHxs9wBbkAUonANuQFCpGxk"

CUSTOMER_EMAIL = "redeem-load-test@ticketbooking.local"
CUSTOMER_PASSWORD = "RedeemTest123!"
ADMIN_EMAIL = "admin@ticketbooking.local"
ADMIN_PASSWORD = "AdminPass123!"

CONCURRENT_REDEEM_REQUESTS = 20


def get_json(url, headers=None):
    req = urllib.request.Request(url, headers=headers or {})
    with urllib.request.urlopen(req, timeout=10) as resp:
        return resp.status, json.load(resp)


def post_json(url, payload, headers=None):
    data = json.dumps(payload).encode("utf-8")
    h = {"Content-Type": "application/json"}
    h.update(headers or {})
    req = urllib.request.Request(url, data=data, method="POST", headers=h)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            body = resp.read()
            return resp.status, (json.loads(body) if body else {})
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8")
        try:
            return e.code, json.loads(body)
        except json.JSONDecodeError:
            return e.code, {"raw": body}


def get_or_create_token(email, password):
    status, body = post_json(f"{USER_SERVICE_URL}/auth/register", {"email": email, "password": password})
    if status not in (200, 201):
        status, body = post_json(f"{USER_SERVICE_URL}/auth/login", {"email": email, "password": password})
    if status not in (200, 201):
        raise RuntimeError(f"Could not obtain a token for {email}: HTTP {status} {body}")
    return body["accessToken"]


def query_db(database, sql):
    env = dict(os.environ)
    env["PGPASSWORD"] = "password"
    result = subprocess.run(
        ["psql", "-h", "localhost", "-U", "postgres", "-d", database, "-t", "-c", sql],
        capture_output=True, text=True, env=env,
    )
    # psql on Windows can leave a trailing \r on each line even in -t mode.
    return result.stdout.strip().replace("\r", "")


def main():
    print("Phase 12 redemption concurrency test")
    print("=" * 60)

    customer_token = get_or_create_token(CUSTOMER_EMAIL, CUSTOMER_PASSWORD)
    admin_token = get_or_create_token(ADMIN_EMAIL, ADMIN_PASSWORD)

    _, seat_map = get_json(f"{EVENT_SERVICE_URL}/shows/{SHOW_ID}/seats")
    seat_id = next(s["id"] for s in seat_map["seats"] if s["status"] == "AVAILABLE")
    print(f"Using seat {seat_id}")

    status, booking = post_json(
        f"{BOOKING_SERVICE_URL}/bookings",
        {"showId": SHOW_ID, "seatId": seat_id},
        headers={"Authorization": f"Bearer {customer_token}"},
    )
    assert status == 201, f"Failed to create booking: HTTP {status} {booking}"
    booking_id = booking["id"]
    print(f"Created booking {booking_id}")

    status, charge = post_json(
        f"{PAYMENT_SERVICE_URL}/payments/charge",
        {"bookingId": booking_id, "amount": 250.00},
        headers={"Authorization": f"Bearer {customer_token}", "Idempotency-Key": f"redeem-test-{uuid.uuid4()}"},
    )
    assert status == 201, f"Failed to initiate charge: HTTP {status} {charge}"
    payment_id = charge["paymentId"]
    order_id = charge["razorpayOrderId"]

    razorpay_payment_id = f"pay_redeem_test_{int(time.time())}"
    signature_payload = f"{order_id}|{razorpay_payment_id}"
    signature = hmac.new(RAZORPAY_KEY_SECRET.encode(), signature_payload.encode(), hashlib.sha256).hexdigest()

    status, verify_result = post_json(
        f"{PAYMENT_SERVICE_URL}/payments/{payment_id}/verify",
        {"razorpayOrderId": order_id, "razorpayPaymentId": razorpay_payment_id, "razorpaySignature": signature},
    )
    assert status == 200 and verify_result["status"] == "SUCCESS", f"Payment verify failed: {verify_result}"
    print(f"Payment verified SUCCESS -- booking should now be CONFIRMED and a ticket generating asynchronously")

    print("Waiting for the ticket to be generated...")
    qr_payload = None
    deadline = time.time() + 30
    while time.time() < deadline:
        qr_payload = query_db("booking_db", f"SELECT qr_payload FROM tickets WHERE booking_id = '{booking_id}';")
        if qr_payload:
            break
        time.sleep(1)
    assert qr_payload, "Ticket was never generated within 30s"
    print(f"Ticket ready. QR payload length: {len(qr_payload)} chars")

    print(f"\nFiring {CONCURRENT_REDEEM_REQUESTS} concurrent redemption requests for the same ticket...")
    headers = {"Authorization": f"Bearer {admin_token}"}

    def redeem():
        return post_json(f"{BOOKING_SERVICE_URL}/tickets/redeem", {"qrPayload": qr_payload}, headers=headers)

    with concurrent.futures.ThreadPoolExecutor(max_workers=CONCURRENT_REDEEM_REQUESTS) as executor:
        futures = [executor.submit(redeem) for _ in range(CONCURRENT_REDEEM_REQUESTS)]
        results = [f.result() for f in concurrent.futures.as_completed(futures)]

    successes = [r for r in results if r[0] == 200]
    conflicts = [r for r in results if r[0] == 409]
    other = [r for r in results if r[0] not in (200, 409)]

    print("\n=== Results ===")
    print(f"Total requests: {CONCURRENT_REDEEM_REQUESTS}")
    print(f"200 OK (redeemed): {len(successes)}")
    print(f"409 Conflict (already redeemed): {len(conflicts)}")
    print(f"Other (unexpected): {len(other)}")
    if other:
        for status, body in other[:5]:
            print(f"  unexpected: HTTP {status} {body}")

    final_status = query_db("booking_db", f"SELECT status FROM bookings WHERE id = '{booking_id}';")
    print(f"\nFinal booking status: {final_status}")

    assert len(successes) == 1, f"Expected exactly 1 successful redemption, got {len(successes)}"
    assert len(conflicts) == CONCURRENT_REDEEM_REQUESTS - 1, (
        f"Expected {CONCURRENT_REDEEM_REQUESTS - 1} conflicts, got {len(conflicts)}"
    )
    assert len(other) == 0, f"Got {len(other)} unexpected responses"
    assert final_status == "CHECKED_IN", f"Expected booking to end CHECKED_IN, got {final_status}"

    print("\nPASS: exactly one redemption succeeded under concurrent contention, zero double-redemption.")


if __name__ == "__main__":
    main()
