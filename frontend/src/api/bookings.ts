import type { ApiErrorResponse, BookingResponse } from '../types/seat'
import { setMockBooking } from './mockBookingsStore'
import { authFetch } from './auth'
import { isAuthenticated } from './authStore'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

// booking-service holds a Redis lock for this long (application.yml:
// booking.hold-ttl-minutes: 5) but never returns it in the response — the
// frontend has to know this out of band. Keep in sync with the backend config.
export const HOLD_TTL_MINUTES = 5

export class SeatConflictError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'SeatConflictError'
  }
}

export class AuthRequiredError extends Error {
  constructor(message = 'Please sign in to hold a seat.') {
    super(message)
    this.name = 'AuthRequiredError'
  }
}

/**
 * Locking a seat = creating a PENDING booking (POST /bookings, requires auth —
 * the owner is derived from the JWT server-side). There is no separate lock
 * endpoint and no batch endpoint — one call per seat. There is also no
 * release/unlock endpoint reachable from the frontend; an abandoned hold only
 * clears when its 5-minute TTL expires server-side.
 */
export async function lockSeat(showId: string, seatId: string): Promise<{ booking: BookingResponse; isFallback: boolean }> {
  // Not logged in: don't silently fall back to the offline simulation for an
  // endpoint that's reachable but would genuinely reject this — surface it.
  if (!isAuthenticated()) throw new AuthRequiredError()

  let res: Response
  try {
    res = await authFetch(new URL('/bookings', API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ showId, seatId }),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn(`[bookings] could not reach booking-service to lock seat ${seatId}, simulating a successful hold:`, err)
    const booking: BookingResponse = {
      id: crypto.randomUUID(),
      showId,
      seatId,
      userId: 'local-dev-user',
      status: 'PENDING',
      createdAt: new Date().toISOString(),
    }
    setMockBooking(booking)
    return { booking, isFallback: true }
  }

  if (res.status === 409) {
    const body: ApiErrorResponse = await res.json().catch(() => ({ errorCode: 'CONFLICT', message: 'Seat already held', timestamp: new Date().toISOString() }))
    throw new SeatConflictError(body.message)
  }
  if (!res.ok) {
    throw new Error(`POST /bookings failed with ${res.status}`)
  }

  const booking: BookingResponse = await res.json()
  return { booking, isFallback: false }
}
