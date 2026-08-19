// Phase 12 formal load test: ramps from 50 to 5,000 requests/sec over 2
// minutes against POST /bookings for a single 50-seat show — the flash-sale
// scenario from the system design (thousands of people hitting refresh for
// one of 50 tickets).
//
// What this proves:
//   - zero overselling even under extreme concurrency (checked separately,
//     after the run, by querying the DB directly — see run_load_tests.py)
//   - the system returns EXPECTED status codes (201 or 409) under load,
//     never crashes into 5xx/timeouts
//   - p99 latency stays within a documented bound even as the request rate
//     outpaces what a single dev-box instance can realistically sustain
//
// Run directly with:
//   k6 run load-tests/flash_sale_load_test.js
// (needs TOKEN and SHOW_ID env vars — see run_load_tests.py, which sets
// these up: registers a user, resets the show's seats to AVAILABLE, then
// invokes this script.)

import http from 'k6/http';
import { check } from 'k6';
import { Counter } from 'k6/metrics';

const BOOKING_SERVICE_URL = 'http://localhost:8082';
const SHOW_ID = __ENV.SHOW_ID || '33333333-3333-3333-3333-333333333301';
const TOKEN = __ENV.TOKEN;
const SEAT_IDS = JSON.parse(__ENV.SEAT_IDS_JSON || '[]');

export const created201 = new Counter('booking_created_201');
export const conflict409 = new Counter('booking_conflict_409');
export const unexpectedStatus = new Counter('booking_unexpected_status');

export const options = {
  scenarios: {
    flash_sale: {
      executor: 'ramping-arrival-rate',
      startRate: 50,
      timeUnit: '1s',
      preAllocatedVUs: 300,
      maxVUs: 2000,
      stages: [
        { target: 5000, duration: '2m' },
      ],
    },
  },
  thresholds: {
    // Generous on purpose: this is a single dev-box instance (default
    // HikariCP pool = 10, default Tomcat threads = 200), not a tuned
    // production deployment. The point is proving the system degrades to
    // *queueing*, not to errors, once demand outstrips capacity.
    'http_req_duration': ['p(99)<5000'],
    // Only 201 (booked) and 409 (seat taken) are acceptable outcomes here —
    // anything else (5xx, timeouts) counts as a real failure.
    'booking_unexpected_status': ['count==0'],
  },
};

export default function () {
  const seatId = SEAT_IDS[Math.floor(Math.random() * SEAT_IDS.length)];
  const payload = JSON.stringify({ showId: SHOW_ID, seatId: seatId });
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${TOKEN}`,
    },
  };

  const res = http.post(`${BOOKING_SERVICE_URL}/bookings`, payload, params);

  check(res, {
    'status is 201 or 409': (r) => r.status === 201 || r.status === 409,
  });

  if (res.status === 201) {
    created201.add(1);
  } else if (res.status === 409) {
    conflict409.add(1);
  } else {
    unexpectedStatus.add(1);
  }
}
