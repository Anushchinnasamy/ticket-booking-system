// Matches event-service's SeatResponse/SeatMapResponse exactly.
export type SeatStatus = 'AVAILABLE' | 'LOCKED' | 'BOOKED'
export type SeatType = 'REGULAR' | 'PREMIUM' | 'VIP'

export interface SeatResponse {
  id: string
  rowLabel: string
  seatNumber: number
  seatType: SeatType
  price: number
  status: SeatStatus
  // Only set while LOCKED — when someone else holds it, used to show an
  // approximate "unlocks in ~Xm" on the seat itself. Null otherwise.
  lockedAt: string | null
}

export interface SeatMapResponse {
  showId: string
  eventTitle: string
  venueName: string
  startTime: string
  basePrice: number
  seats: SeatResponse[]
}

// Matches booking-service's CreateBookingRequest/BookingResponse exactly.
// NOTE: locking one seat = creating one PENDING booking. There is no batch-lock
// endpoint and no release/unlock endpoint reachable from the frontend — see
// api/bookings.ts for how the UI works around that.
export interface CreateBookingRequest {
  showId: string
  seatId: string
}

export interface BookingResponse {
  id: string
  showId: string
  seatId: string
  userId: string
  status: 'PENDING' | 'CONFIRMED' | 'CHECKED_IN' | 'CANCELLED'
  createdAt: string // ISO instant
}

export interface ApiErrorResponse {
  errorCode: string
  message: string
  timestamp: string
}
