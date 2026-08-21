import type { BookingResponse } from '../types/seat'

// In-memory store standing in for the backend when it's unreachable, so a lock
// made in offline mode is reflected consistently on the next poll. Cleared on
// page reload — this is a local dev sandbox, not persistence.
const store = new Map<string, BookingResponse>()

export function getMockBooking(seatId: string): BookingResponse | undefined {
  return store.get(seatId)
}

export function setMockBooking(booking: BookingResponse): void {
  store.set(booking.seatId, booking)
}

export function clearMockBooking(seatId: string): void {
  store.delete(seatId)
}
