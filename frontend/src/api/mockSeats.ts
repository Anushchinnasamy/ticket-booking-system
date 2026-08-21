import { HOLD_TTL_MINUTES } from './bookings'
import type { SeatMapResponse, SeatResponse, SeatStatus, SeatType } from '../types/seat'

function hashString(str: string): number {
  let h = 0
  for (let i = 0; i < str.length; i++) {
    h = (Math.imul(31, h) + str.charCodeAt(i)) | 0
  }
  return Math.abs(h)
}

const ROWS: { label: string; seatType: SeatType; count: number; price: number }[] = [
  { label: 'A', seatType: 'VIP', count: 10, price: 650 },
  { label: 'B', seatType: 'VIP', count: 10, price: 650 },
  { label: 'C', seatType: 'PREMIUM', count: 14, price: 450 },
  { label: 'D', seatType: 'PREMIUM', count: 14, price: 450 },
  { label: 'E', seatType: 'PREMIUM', count: 14, price: 450 },
  { label: 'F', seatType: 'PREMIUM', count: 14, price: 450 },
  { label: 'G', seatType: 'REGULAR', count: 16, price: 280 },
  { label: 'H', seatType: 'REGULAR', count: 16, price: 280 },
  { label: 'I', seatType: 'REGULAR', count: 16, price: 280 },
]

function statusFromHash(h: number): SeatStatus {
  const bucket = h % 20
  if (bucket < 2) return 'BOOKED'
  if (bucket < 4) return 'LOCKED'
  return 'AVAILABLE'
}

/**
 * Generates a plausible seat map (same shape as event-service's SeatMapResponse)
 * for local development when the API is unreachable. Status is deterministic per
 * (showId, seatId) so repeated polls in offline mode stay stable.
 */
export function generateMockSeatMap(showId: string, eventTitle: string, venueName: string, startTime: string, basePrice: number): SeatMapResponse {
  const seats: SeatResponse[] = []

  for (const row of ROWS) {
    for (let n = 1; n <= row.count; n++) {
      const id = `${showId}-${row.label}${n}`
      const h = hashString(id)
      const status = statusFromHash(h)
      // A plausible in-progress hold — somewhere between just-now and the
      // full TTL ago — so the offline demo also shows a live countdown.
      const lockedAt = status === 'LOCKED' ? new Date(Date.now() - (h % (HOLD_TTL_MINUTES * 60_000))).toISOString() : null
      seats.push({
        id,
        rowLabel: row.label,
        seatNumber: n,
        seatType: row.seatType,
        price: row.price,
        status,
        lockedAt,
      })
    }
  }

  return { showId, eventTitle, venueName, startTime, basePrice, seats }
}
