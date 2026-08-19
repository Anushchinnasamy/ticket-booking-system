"""
Locking-strategy load test: fires 500 concurrent POST /bookings requests at
all 50 seats of the seeded "Great Adventure 10:00" show.

This script is run TWICE, unmodified, against two different implementations
of the seat-locking layer in booking-service:
  1. Phase 2 baseline  — event-service SELECT ... FOR UPDATE (Postgres)
  2. Phase 3           — Redisson distributed lock (Redis)

The results from both runs are the before/after numbers in
docs/adr/001-locking-strategy.md.

Expected result in both cases: exactly 50 successes (one per seat), zero
overselling. What's expected to differ is throughput/latency.

Usage:
    python load-tests/locking_load_test.py

Uses only the Python standard library (no pip installs required).
"""

import concurrent.futures
import json
import time
import urllib.error
import urllib.request
import uuid

EVENT_SERVICE_URL = "http://localhost:8081"
BOOKING_SERVICE_URL = "http://localhost:8082"
SHOW_ID = "33333333-3333-3333-3333-333333333301"  # "The Great Adventure" 10:00 - 50 seats
SEAT_POOL_SIZE = 50
TOTAL_REQUESTS = 500


def get_json(url):
    with urllib.request.urlopen(url, timeout=10) as resp:
        return json.load(resp)


def post_json(url, payload):
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST",
                                  headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            return resp.status, json.load(resp)
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8")
        try:
            return e.code, json.loads(body)
        except json.JSONDecodeError:
            return e.code, {"raw": body}


def pick_available_seats(show_id, count):
    seat_map = get_json(f"{EVENT_SERVICE_URL}/shows/{show_id}/seats")
    available = [s["id"] for s in seat_map["seats"] if s["status"] == "AVAILABLE"]
    if len(available) < count:
        raise RuntimeError(
            f"Only {len(available)} AVAILABLE seats left on show {show_id}; "
            f"need {count}. Reset event_db/re-seed before running this test."
        )
    return available[:count]


def fire_booking_request(show_id, seat_id):
    user_id = str(uuid.uuid4())
    payload = {"showId": show_id, "seatId": seat_id, "userId": user_id}
    status, body = post_json(f"{BOOKING_SERVICE_URL}/bookings", payload)
    return status, body


def main():
    print(f"Selecting {SEAT_POOL_SIZE} AVAILABLE seats from show {SHOW_ID}...")
    seat_pool = pick_available_seats(SHOW_ID, SEAT_POOL_SIZE)

    # Round-robin TOTAL_REQUESTS across the seat pool (10 requests/seat on
    # average) so every seat sees real contention.
    targets = [seat_pool[i % SEAT_POOL_SIZE] for i in range(TOTAL_REQUESTS)]

    print(f"Firing {TOTAL_REQUESTS} concurrent booking requests at {SEAT_POOL_SIZE} seats...")
    start = time.perf_counter()
    results = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=TOTAL_REQUESTS) as executor:
        futures = [executor.submit(fire_booking_request, SHOW_ID, seat_id) for seat_id in targets]
        for future in concurrent.futures.as_completed(futures):
            results.append(future.result())
    elapsed = time.perf_counter() - start

    created = [r for r in results if r[0] == 201]
    conflicts = [r for r in results if r[0] == 409]
    other = [r for r in results if r[0] not in (201, 409)]

    print()
    print("=== Results ===")
    print(f"Total requests:     {TOTAL_REQUESTS}")
    print(f"201 Created:        {len(created)}")
    print(f"409 Conflict:       {len(conflicts)}")
    print(f"Other (unexpected): {len(other)}")
    print(f"Wall-clock time:    {elapsed:.3f}s")
    print(f"Throughput:         {TOTAL_REQUESTS / elapsed:.1f} req/s")

    if other:
        print()
        print("Unexpected responses:")
        for status, body in other[:5]:
            print(f"  HTTP {status}: {body}")

    booked_seat_ids = {r[1]["seatId"] for r in created}
    overselling = len(booked_seat_ids) != len(created)

    print()
    print("=== Correctness ===")
    print(f"Distinct seats booked: {len(booked_seat_ids)} (expected {SEAT_POOL_SIZE})")
    print(f"Overselling detected:  {overselling}")

    assert len(created) == SEAT_POOL_SIZE, (
        f"Expected exactly {SEAT_POOL_SIZE} successful bookings, got {len(created)}"
    )
    assert not overselling, "Two bookings landed on the same seat — overselling occurred"
    assert len(other) == 0, f"Got {len(other)} unexpected (non-201/409) responses"

    print()
    print(f"PASS: zero overselling under {TOTAL_REQUESTS} concurrent requests against {SEAT_POOL_SIZE} seats.")


if __name__ == "__main__":
    main()
