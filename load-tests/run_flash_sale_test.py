"""
Phase 12 flash-sale load test runner: does the setup flash_sale_load_test.js
needs (a bearer token, a clean pool of 50 AVAILABLE seats) and then invokes
k6 with the right environment variables -- the whole thing is one command.

Usage:
    python load-tests/run_flash_sale_test.py
"""

import json
import os
import subprocess
import urllib.error
import urllib.request

USER_SERVICE_URL = "http://localhost:8084"
SHOW_ID = "33333333-3333-3333-3333-333333333301"
SEAT_POOL_SIZE = 50

LOAD_TEST_EMAIL = "flash-sale-test@ticketbooking.local"
LOAD_TEST_PASSWORD = "FlashSale123!"

PROJECT_ROOT = r"C:\Projects\TicketBooking System"
K6_EXE = r"C:\k6-ticketbooking\k6.exe"


def post_json(url, payload):
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST", headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            return resp.status, json.load(resp)
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8")
        try:
            return e.code, json.loads(body)
        except json.JSONDecodeError:
            return e.code, {"raw": body}


def get_or_create_token():
    status, body = post_json(f"{USER_SERVICE_URL}/auth/register",
                              {"email": LOAD_TEST_EMAIL, "password": LOAD_TEST_PASSWORD})
    if status not in (200, 201):
        status, body = post_json(f"{USER_SERVICE_URL}/auth/login",
                                  {"email": LOAD_TEST_EMAIL, "password": LOAD_TEST_PASSWORD})
    if status not in (200, 201):
        raise RuntimeError(f"Could not obtain a token: HTTP {status} {body}")
    return body["accessToken"]


def reset_seats_to_available():
    env = dict(os.environ)
    env["PGPASSWORD"] = "password"
    sql = f"""
    UPDATE seats SET status = 'AVAILABLE'
    WHERE seat_map_id IN (
      SELECT sm.id FROM seat_maps sm
      JOIN shows sh ON sh.id = sm.show_id
      WHERE sh.id = '{SHOW_ID}'
    );
    """
    subprocess.run(["psql", "-h", "localhost", "-U", "postgres", "-d", "event_db", "-c", sql],
                    capture_output=True, text=True, env=env, check=True)

    # This test's own overselling check queries booking_db by seat_id, so it
    # needs a clean slate there too -- otherwise a PENDING/CONFIRMED booking
    # left over from an earlier, unrelated test run on the same seed seats
    # (this show has been reused across every phase's live testing all
    # session) reads as "two active bookings for one seat" even though
    # nothing in this run actually raced for it.
    subprocess.run(["psql", "-h", "localhost", "-U", "postgres", "-d", "booking_db", "-c",
                     f"DELETE FROM bookings WHERE show_id = '{SHOW_ID}';"],
                    capture_output=True, text=True, env=env, check=True)


def query_seat_pool_from_db():
    # Reads straight from Postgres rather than through GET /shows/{id}/seats
    # -- the reset above writes directly to the DB, bypassing claim/release/
    # book entirely, so Phase 10's Redis cache never gets invalidated and
    # would otherwise serve a stale pre-reset snapshot for up to its 45s TTL.
    env = dict(os.environ)
    env["PGPASSWORD"] = "password"
    sql = f"""
    SELECT s.id FROM seats s
    JOIN seat_maps sm ON sm.id = s.seat_map_id
    JOIN shows sh ON sh.id = sm.show_id
    WHERE sh.id = '{SHOW_ID}' AND s.status = 'AVAILABLE'
    ORDER BY s.row_label, s.seat_number;
    """
    result = subprocess.run(["psql", "-h", "localhost", "-U", "postgres", "-d", "event_db", "-t", "-c", sql],
                             capture_output=True, text=True, env=env, check=True)
    return [line.strip() for line in result.stdout.replace("\r", "").splitlines() if line.strip()]


def main():
    print("Setting up the flash-sale load test...")
    print("Resetting all 50 seats on the test show to AVAILABLE...")
    reset_seats_to_available()

    print("Obtaining an access token...")
    token = get_or_create_token()

    seat_ids = query_seat_pool_from_db()[:SEAT_POOL_SIZE]
    if len(seat_ids) < SEAT_POOL_SIZE:
        raise RuntimeError(f"Only {len(seat_ids)} AVAILABLE seats, need {SEAT_POOL_SIZE}")
    print(f"Seat pool ready: {len(seat_ids)} seats")

    print("\nRunning k6 (ramping 50 -> 5000 req/s over 2 minutes)...\n")
    env = dict(os.environ)
    env["SHOW_ID"] = SHOW_ID
    env["TOKEN"] = token
    env["SEAT_IDS_JSON"] = json.dumps(seat_ids)

    script_path = os.path.join(PROJECT_ROOT, "load-tests", "flash_sale_load_test.js")
    result = subprocess.run([K6_EXE, "run", script_path], env=env, cwd=PROJECT_ROOT)

    print("\nVerifying zero overselling directly against the database...")
    env2 = dict(os.environ)
    env2["PGPASSWORD"] = "password"
    check = subprocess.run(
        ["psql", "-h", "localhost", "-U", "postgres", "-d", "booking_db", "-t", "-c",
         f"SELECT seat_id, count(*) FROM bookings WHERE show_id = '{SHOW_ID}' AND status IN ('PENDING','CONFIRMED') "
         f"GROUP BY seat_id HAVING count(*) > 1;"],
        capture_output=True, text=True, env=env2,
    )
    oversold_rows = check.stdout.strip().replace("\r", "")
    if oversold_rows:
        print(f"OVERSELLING DETECTED:\n{oversold_rows}")
        raise SystemExit(1)
    print("Zero overselling confirmed: no seat has more than one active booking.")

    raise SystemExit(result.returncode)


if __name__ == "__main__":
    main()
