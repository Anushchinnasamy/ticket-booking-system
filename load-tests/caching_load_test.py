"""
Phase 10 caching load test: proves GET /shows/{id}/seats read latency stays
flat as concurrent seat-mutation ("booking write") volume increases, because
the cache is invalidated per-seat (a Redis hash field) rather than as one
whole-show blob — most of the show's 50 seat entries stay cached and warm
even while a handful of seats are being claimed/released rapidly.

Three phases, same read workload throughout, only the write churn rate
changes:
  A. No writes  — baseline read latency.
  B. Light writes — 2 seats claimed/released in a tight loop.
  C. Heavy writes — 5 seats claimed/released in a tight loop, faster.

Expected result: p50/p95 read latency in phase C stays close to phase A
(within noise) — NOT growing proportionally with write volume, because only
the churned seats' cache entries ever get invalidated.

Usage:
    python load-tests/caching_load_test.py

Uses only the Python standard library (no pip installs required).
"""

import concurrent.futures
import json
import threading
import time
import urllib.error
import urllib.request

EVENT_SERVICE_URL = "http://localhost:8081"
SHOW_ID = "33333333-3333-3333-3333-333333333301"  # "The Great Adventure" 10:00 - 50 seats

READ_WORKERS = 20
READS_PER_PHASE = 400
PHASE_DURATION_S = 6


def get_json(url):
    with urllib.request.urlopen(url, timeout=10) as resp:
        return resp.status, json.load(resp)


def post_empty(url):
    req = urllib.request.Request(url, data=b"", method="POST")
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.status
    except urllib.error.HTTPError as e:
        return e.code


def pick_available_seats(show_id, count):
    _, seat_map = get_json(f"{EVENT_SERVICE_URL}/shows/{show_id}/seats")
    available = [s["id"] for s in seat_map["seats"] if s["status"] == "AVAILABLE"]
    if len(available) < count:
        raise RuntimeError(f"Only {len(available)} AVAILABLE seats on show {show_id}, need {count}")
    return available[:count]


def churn_seat(show_id, seat_id, stop_event, delay_s):
    """Repeatedly claim then release one seat until stop_event is set."""
    while not stop_event.is_set():
        post_empty(f"{EVENT_SERVICE_URL}/shows/{show_id}/seats/{seat_id}/claim")
        time.sleep(delay_s)
        post_empty(f"{EVENT_SERVICE_URL}/shows/{show_id}/seats/{seat_id}/release")
        time.sleep(delay_s)


def read_seat_map(show_id):
    start = time.perf_counter()
    status, _ = get_json(f"{EVENT_SERVICE_URL}/shows/{show_id}/seats")
    elapsed_ms = (time.perf_counter() - start) * 1000
    return status, elapsed_ms


def run_read_load(show_id, num_reads, num_workers):
    latencies = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(read_seat_map, show_id) for _ in range(num_reads)]
        for future in concurrent.futures.as_completed(futures):
            status, elapsed_ms = future.result()
            assert status == 200, f"Unexpected status {status} from seat map read"
            latencies.append(elapsed_ms)
    return latencies


def percentile(sorted_values, pct):
    if not sorted_values:
        return float("nan")
    idx = min(len(sorted_values) - 1, int(len(sorted_values) * pct / 100))
    return sorted_values[idx]


def summarize(name, latencies):
    s = sorted(latencies)
    print(f"{name}: n={len(s)}  p50={percentile(s, 50):.2f}ms  "
          f"p95={percentile(s, 95):.2f}ms  p99={percentile(s, 99):.2f}ms  max={s[-1]:.2f}ms")
    return percentile(s, 50), percentile(s, 95)


def run_phase(name, show_id, churn_seat_ids, churn_delay_s):
    stop_event = threading.Event()
    churn_threads = [
        threading.Thread(target=churn_seat, args=(show_id, seat_id, stop_event, churn_delay_s), daemon=True)
        for seat_id in churn_seat_ids
    ]
    for t in churn_threads:
        t.start()

    # Let churn ramp up before measuring, and keep it running through the read burst.
    time.sleep(0.5)
    latencies = run_read_load(show_id, READS_PER_PHASE, READ_WORKERS)

    stop_event.set()
    for t in churn_threads:
        t.join(timeout=2)

    return summarize(name, latencies)


def main():
    print(f"Warming cache for show {SHOW_ID}...")
    get_json(f"{EVENT_SERVICE_URL}/shows/{SHOW_ID}/seats")

    churn_pool = pick_available_seats(SHOW_ID, 5)
    print(f"Churn pool (will be claimed/released repeatedly): {churn_pool}")
    print()

    print("=== Phase A: no write churn (baseline) ===")
    p50_a, p95_a = run_phase("Phase A (0 seats churning)", SHOW_ID, [], 1.0)
    print()

    print("=== Phase B: light write churn (2 seats) ===")
    p50_b, p95_b = run_phase("Phase B (2 seats churning, 200ms cycle)", SHOW_ID, churn_pool[:2], 0.1)
    print()

    print("=== Phase C: heavy write churn (5 seats) ===")
    p50_c, p95_c = run_phase("Phase C (5 seats churning, 40ms cycle)", SHOW_ID, churn_pool[:5], 0.02)
    print()

    print("=== Summary ===")
    print(f"p50 latency: A={p50_a:.2f}ms  B={p50_b:.2f}ms  C={p50_c:.2f}ms")
    print(f"p95 latency: A={p95_a:.2f}ms  B={p95_b:.2f}ms  C={p95_c:.2f}ms")

    growth = p95_c / p95_a if p95_a > 0 else float("inf")
    print(f"p95 growth factor (C vs A): {growth:.2f}x")

    # Per-seat invalidation should keep this well under a "cache storm"
    # blowup — a generous bound, since network/JIT noise on a shared dev
    # box means p95 won't be perfectly flat, but it shouldn't scale with
    # write volume the way whole-show invalidation would.
    assert growth < 3.0, (
        f"p95 read latency grew {growth:.2f}x from baseline to heavy write load — "
        f"looks like cache invalidation is broader than per-seat"
    )
    print()
    print("PASS: read latency stayed roughly flat as write churn increased.")


if __name__ == "__main__":
    main()
