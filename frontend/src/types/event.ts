// Matches event-service's EventCategory enum exactly (see event-service EventController).
export type EventCategory = 'MOVIE' | 'CONCERT' | 'SPORTS' | 'COMEDY'

// Matches event-service's EventSummaryResponse record exactly — do not add fields here.
export interface EventSummaryResponse {
  id: string
  title: string
  category: EventCategory
  description: string
}

export type BookingStatus = 'available' | 'filling-fast' | 'housefull'

// event-service does not yet return poster/rating/price/status/bookedCount.
// These are deterministically derived placeholders (see enrichEvent) until the
// backend contract is extended — swap this out once real fields exist.
export interface EnrichedEvent extends EventSummaryResponse {
  posterUrl: string
  rating: number
  price: number
  bookedCount: string
  status: BookingStatus
}
