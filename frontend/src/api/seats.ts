import type { SeatMapResponse } from '../types/seat'
import { generateMockSeatMap } from './mockSeats'
import { getMockBooking } from './mockBookingsStore'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export interface FetchSeatMapResult {
  seatMap: SeatMapResponse
  isFallback: boolean
}

export async function fetchSeatMap(showId: string): Promise<FetchSeatMapResult> {
  try {
    const res = await fetch(new URL(`/shows/${showId}/seats`, API_BASE), { signal: AbortSignal.timeout(12000) })
    if (!res.ok) throw new Error(`GET /shows/${showId}/seats failed with ${res.status}`)
    const seatMap: SeatMapResponse = await res.json()
    return { seatMap, isFallback: false }
  } catch (err) {
    console.warn(`[seats] could not reach event-service for show ${showId}, falling back to mock data:`, err)
    const seatMap = generateMockSeatMap(showId, 'Midnight Frequency', 'PVR Forum Mall', new Date().toISOString(), 280)
    // overlay any seats this browser session has "locked" while offline so
    // repeated polls stay consistent with what lockSeat's fallback recorded
    for (const seat of seatMap.seats) {
      if (getMockBooking(seat.id)) seat.status = 'LOCKED'
    }
    return { seatMap, isFallback: true }
  }
}
