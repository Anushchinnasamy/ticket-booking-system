"""
Phase 12 chaos test: automates the two Phase 9 scenarios (see
docs/adr/003-resilience-chaos-test.md for the original manual run) so
they're re-runnable with one command instead of a step-by-step manual
process.

Scenario 1 -- kill booking-service, hammer payment-service:
    Verifies payment-service's circuit breaker on BookingServiceClient
    opens under repeated failures (fast-fail, no hangs), then recovers to
    CLOSED once booking-service comes back up.

Scenario 2 -- kill payment-service mid-transaction:
    Creates a booking, initiates a charge, then kills payment-service
    before /verify is ever called. Verifies the *existing* Phase 3
    StaleBookingSweeper auto-cancels the orphaned PENDING booking once its
    hold TTL expires -- this needs zero payment-service involvement, which
    is the point.

Requires all 6 services + native infra (Postgres/Redis/Kafka/MinIO)
already running, matching every other live-verification script in this
project. Restarts booking-service and payment-service itself as part of
the test -- run this against a dev environment, not anything shared.

Usage:
    python load-tests/chaos_test.py
"""

import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
import uuid

PROJECT_ROOT = r"C:\Projects\TicketBooking System"
EVENT_SERVICE_URL = "http://localhost:8081"
BOOKING_SERVICE_URL = "http://localhost:8082"
PAYMENT_SERVICE_URL = "http://localhost:8083"
USER_SERVICE_URL = "http://localhost:8084"

RAZORPAY_ENV = {
    "RAZORPAY_KEY_ID": "rzp_test_TRXnNFZ4H3okES",
    "RAZORPAY_KEY_SECRET": "1VHxs9wBbkAUonANuQFCpGxk",
}

SERVICES = {
    "booking-service": {"port": 8082, "jar": r"booking-service\target\booking-service-0.1.0-SNAPSHOT.jar", "env": {}},
    "payment-service": {"port": 8083, "jar": r"payment-service\target\payment-service-0.1.0-SNAPSHOT.jar", "env": RAZORPAY_ENV},
}


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
    except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
        return None, {"error": str(e)}


def find_pid_by_port(port):
    out = subprocess.run(["netstat", "-ano"], capture_output=True, text=True).stdout
    for line in out.splitlines():
        if f":{port} " in line and "LISTENING" in line:
            return line.split()[-1]
    return None


def kill_pid(pid):
    subprocess.run(["taskkill", "/F", "/PID", pid], capture_output=True, text=True)


def kill_service(name):
    port = SERVICES[name]["port"]
    pid = find_pid_by_port(port)
    if not pid:
        print(f"  [warn] {name} doesn't appear to be running on port {port}")
        return
    print(f"  Killing {name} (PID {pid}, port {port})")
    kill_pid(pid)
    deadline = time.time() + 10
    while find_pid_by_port(port) and time.time() < deadline:
        time.sleep(0.5)


def start_service(name, log_path, extra_env=None):
    cfg = SERVICES[name]
    jar_path = f"{PROJECT_ROOT}\\{cfg['jar']}"
    env = dict(os.environ)
    env.update(cfg["env"])
    if extra_env:
        env.update(extra_env)
    print(f"  Starting {name}...")
    with open(log_path, "w") as log_file:
        # DETACHED_PROCESS + CREATE_NEW_PROCESS_GROUP: the service must keep
        # running after this script exits, same as every other service
        # started throughout this project's live testing. Plain Popen
        # without these flags on Windows ties the child's lifetime to this
        # script's console, which chaos scripts especially can't rely on.
        subprocess.Popen(
            ["java", "-jar", jar_path],
            cwd=PROJECT_ROOT,
            env=env,
            stdout=log_file,
            stderr=subprocess.STDOUT,
            creationflags=subprocess.DETACHED_PROCESS | subprocess.CREATE_NEW_PROCESS_GROUP,
        )


def wait_for_health(port, timeout=60):
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            status, body = get_json(f"http://localhost:{port}/actuator/health")
            if status == 200 and body.get("status") == "UP":
                return True
        except Exception:
            pass
        time.sleep(1)
    return False


def get_circuit_breaker_state(name="booking-service"):
    status, body = get_json(f"{PAYMENT_SERVICE_URL}/actuator/circuitbreakers")
    cb = body.get("circuitBreakers", {}).get(name, {})
    return cb.get("state")


def get_or_create_token(email, password):
    status, body = post_json(f"{USER_SERVICE_URL}/auth/register", {"email": email, "password": password})
    if status not in (200, 201):
        status, body = post_json(f"{USER_SERVICE_URL}/auth/login", {"email": email, "password": password})
    if status not in (200, 201):
        raise RuntimeError(f"Could not obtain a token: HTTP {status} {body}")
    return body["accessToken"]


def scenario_1_circuit_breaker(token):
    print("\n=== Scenario 1: kill booking-service, verify payment-service's circuit breaker ===")

    state = get_circuit_breaker_state()
    print(f"  Initial breaker state: {state}")
    assert state == "CLOSED", f"Expected CLOSED before the test, got {state}"

    kill_service("booking-service")
    print("  booking-service is down. Hammering payment-service /payments/charge...")

    opened = False
    latencies = []
    for i in range(15):
        start = time.perf_counter()
        status, body = post_json(
            f"{PAYMENT_SERVICE_URL}/payments/charge",
            {"bookingId": "00000000-0000-0000-0000-000000000099", "amount": 100.00},
            headers={"Authorization": f"Bearer {token}", "Idempotency-Key": f"chaos-{uuid.uuid4()}"},
        )
        elapsed_ms = (time.perf_counter() - start) * 1000
        latencies.append(elapsed_ms)
        print(f"    request {i + 1}: HTTP {status}, {elapsed_ms:.0f}ms")
        if status == 503:
            opened = True

    state = get_circuit_breaker_state()
    print(f"  Breaker state after the burst: {state}")
    assert opened, "Never observed a 503 (circuit open) response -- breaker didn't trip"
    assert state == "OPEN", f"Expected OPEN after repeated failures, got {state}"
    # Bounded by the RestClient's own configured timeouts (2s connect + 3s
    # read = 5s), not an arbitrary round number: the very first request can
    # land in the brief window right after the kill where the OS hasn't
    # started actively refusing the port yet, so it pays close to the full
    # timeout before failing. Every later request in this same burst failed
    # in well under 100ms once that window closed -- see the printed
    # per-request latencies above.
    assert max(latencies) < 6000, f"Worst-case latency {max(latencies):.0f}ms suggests a real hang, not a bounded timeout"
    print(f"  PASS: breaker opened, worst-case latency {max(latencies):.0f}ms (bounded, no hangs)")

    print("  Restarting booking-service...")
    start_service("booking-service", f"{PROJECT_ROOT}\\chaos_booking_service.log")
    if not wait_for_health(8082, timeout=60):
        raise RuntimeError("booking-service did not come back healthy")
    print("  booking-service is back up.")

    print("  Waiting for the breaker to leave OPEN (wait-duration-in-open-state=10s)...")
    deadline = time.time() + 30
    while time.time() < deadline:
        state = get_circuit_breaker_state()
        if state in ("HALF_OPEN", "CLOSED"):
            break
        time.sleep(1)
    print(f"  Breaker state: {state}")

    # HALF_OPEN needs genuinely EVALUATED trial calls to progress anywhere --
    # a 404 for a nonexistent booking is explicitly *ignored* by the breaker
    # (see payment-service's resilience4j config), so it never counts toward
    # the half-open trial window at all and the breaker would sit in
    # HALF_OPEN forever. Real bookings behind real charges are what actually
    # exercises (and closes) the breaker.
    for _ in range(3):
        _, seat_map = get_json(f"{EVENT_SERVICE_URL}/shows/33333333-3333-3333-3333-333333333301/seats")
        seat_id = next(s["id"] for s in seat_map["seats"] if s["status"] == "AVAILABLE")
        status, booking = post_json(
            f"{BOOKING_SERVICE_URL}/bookings",
            {"showId": "33333333-3333-3333-3333-333333333301", "seatId": seat_id},
            headers={"Authorization": f"Bearer {token}"},
        )
        if status == 201:
            post_json(
                f"{PAYMENT_SERVICE_URL}/payments/charge",
                {"bookingId": booking["id"], "amount": 100.00},
                headers={"Authorization": f"Bearer {token}", "Idempotency-Key": f"chaos-recover-{uuid.uuid4()}"},
            )
        time.sleep(0.3)

    state = get_circuit_breaker_state()
    print(f"  Final breaker state: {state}")
    assert state == "CLOSED", f"Expected the breaker to recover to CLOSED, got {state}"
    print("  PASS: breaker recovered to CLOSED once booking-service came back.")


def scenario_2_stale_booking_sweep(token):
    print("\n=== Scenario 2: kill payment-service mid-transaction, verify the stale-booking sweep ===")

    print("  Restarting booking-service with a 1-minute hold TTL for a fast test...")
    kill_service("booking-service")
    start_service("booking-service", f"{PROJECT_ROOT}\\chaos_booking_service.log",
                   extra_env={"BOOKING_HOLD_TTL_MINUTES": "1"})
    if not wait_for_health(8082, timeout=60):
        raise RuntimeError("booking-service did not come back healthy")

    _, seat_map = get_json(f"{EVENT_SERVICE_URL}/shows/33333333-3333-3333-3333-333333333301/seats")
    seat_id = next(s["id"] for s in seat_map["seats"] if s["status"] == "AVAILABLE")
    print(f"  Using seat {seat_id}")

    status, booking = post_json(
        f"{BOOKING_SERVICE_URL}/bookings",
        {"showId": "33333333-3333-3333-3333-333333333301", "seatId": seat_id},
        headers={"Authorization": f"Bearer {token}"},
    )
    assert status == 201, f"Failed to create booking: HTTP {status} {booking}"
    booking_id = booking["id"]
    print(f"  Created booking {booking_id} (PENDING)")

    status, charge = post_json(
        f"{PAYMENT_SERVICE_URL}/payments/charge",
        {"bookingId": booking_id, "amount": 250.00},
        headers={"Authorization": f"Bearer {token}", "Idempotency-Key": f"chaos2-{uuid.uuid4()}"},
    )
    assert status == 201, f"Failed to initiate charge: HTTP {status} {charge}"
    print(f"  Initiated charge (Payment {charge['paymentId']}, status={charge['status']})")

    kill_service("payment-service")
    print("  payment-service is down. Booking is orphaned: PENDING with an INITIATED payment.")

    print("  Waiting for the stale-booking sweep (up to ~2 minutes: 1-min TTL + up to 60s sweep interval)...")
    deadline = time.time() + 150
    final_status = None
    while time.time() < deadline:
        status, current = get_json(f"{BOOKING_SERVICE_URL}/bookings/{booking_id}",
                                    headers={"Authorization": f"Bearer {token}"})
        final_status = current.get("status")
        if final_status == "CANCELLED":
            break
        time.sleep(5)

    print(f"  Final booking status: {final_status}")
    assert final_status == "CANCELLED", f"Expected the sweep to cancel the booking, got {final_status}"
    print("  PASS: orphaned booking was auto-cancelled with zero payment-service involvement.")

    print("  Restarting payment-service...")
    cfg = SERVICES["payment-service"]
    start_service("payment-service", f"{PROJECT_ROOT}\\chaos_payment_service.log")
    if not wait_for_health(8083, timeout=60):
        raise RuntimeError("payment-service did not come back healthy")

    print("  Restarting booking-service with its normal hold TTL...")
    kill_service("booking-service")
    start_service("booking-service", f"{PROJECT_ROOT}\\chaos_booking_service.log")
    if not wait_for_health(8082, timeout=60):
        raise RuntimeError("booking-service did not come back healthy")
    print("  Full recovery confirmed: both services healthy again.")


def main():
    print("Phase 12 automated chaos test")
    print("=" * 60)
    token = get_or_create_token("chaos-test@ticketbooking.local", "ChaosTest123!")

    try:
        scenario_1_circuit_breaker(token)
        scenario_2_stale_booking_sweep(token)
    except AssertionError as e:
        print(f"\nFAIL: {e}")
        sys.exit(1)

    print("\n" + "=" * 60)
    print("ALL CHAOS SCENARIOS PASSED")


if __name__ == "__main__":
    main()
