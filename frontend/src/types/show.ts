// Matches event-service's ShowSummaryResponse record exactly — do not add fields here.
export interface ShowSummaryResponse {
  id: string
  venueName: string
  venueCity: string
  startTime: string // ISO 8601 instant
  basePrice: number
}

export interface EventDetailResponse {
  id: string
  title: string
  category: import('./event').EventCategory
  description: string
  shows: ShowSummaryResponse[]
}

export type ShowFormat = '2D' | '3D' | 'IMAX'
export type ShowAvailability = 'available' | 'filling-fast' | 'housefull'

// ShowSummaryResponse has no format/availability/venue-rating fields yet —
// same placeholder-enrichment approach as EnrichedEvent (see api/enrichShow.ts).
export interface EnrichedShow extends ShowSummaryResponse {
  format: ShowFormat
  availability: ShowAvailability
  venueRating: number
}

export interface EnrichedEventDetail {
  id: string
  title: string
  category: import('./event').EventCategory
  description: string
  shows: EnrichedShow[]
}
