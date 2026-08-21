import { authFetch } from './auth'
import { getMyBookingRecords, type MyBookingRecord } from './myBookingsStore'
import type { BookingResponse } from '../types/seat'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export interface EnrichedMyBooking extends MyBookingRecord {
  liveStatus: BookingResponse['status'] | null // null = couldn't verify (offline)
}

async function fetchLiveStatus(bookingId: string): Promise<BookingResponse['status'] | null> {
  try {
    const res = await authFetch(new URL(`/bookings/${bookingId}`, API_BASE), { signal: AbortSignal.timeout(12000) })
    if (!res.ok) return null
    const body: BookingResponse = await res.json()
    return body.status
  } catch {
    return null
  }
}

export async function fetchMyBookings(): Promise<EnrichedMyBooking[]> {
  const records = getMyBookingRecords()
  const statuses = await Promise.all(records.map((r) => fetchLiveStatus(r.bookingId)))
  return records.map((r, i) => ({ ...r, liveStatus: statuses[i] }))
}
