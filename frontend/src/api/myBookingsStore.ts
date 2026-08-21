const STORAGE_KEY = 'reelrow.myBookings'

export interface MyBookingRecord {
  bookingId: string
  eventId: string
  eventTitle: string
  venueName: string
  startTime: string
  seatLabel: string
  price: number
  createdAt: string
}

/**
 * booking-service has no "list my bookings" endpoint (only GET /bookings/{id}
 * for a single booking you already know the id of) — there is no way to ask
 * the backend "what has this user booked." This is a client-tracked history
 * of bookings made from this browser, recorded at confirmation time, enriched
 * with a live status check per entry (see api/myBookings.ts). It will not
 * show bookings made from another device — that's a real backend gap, not a
 * corner we cut.
 */
function readAll(): MyBookingRecord[] {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) ?? '[]')
  } catch {
    return []
  }
}

export function getMyBookingRecords(): MyBookingRecord[] {
  return readAll()
}

export function addMyBookingRecord(record: MyBookingRecord): void {
  const all = readAll()
  if (all.some((r) => r.bookingId === record.bookingId)) return
  all.push(record)
  localStorage.setItem(STORAGE_KEY, JSON.stringify(all))
}
