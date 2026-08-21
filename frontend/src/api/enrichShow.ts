import type { EnrichedEventDetail, EventDetailResponse, ShowAvailability, ShowFormat, ShowSummaryResponse } from '../types/show'

function hashString(str: string): number {
  let h = 0
  for (let i = 0; i < str.length; i++) {
    h = (Math.imul(31, h) + str.charCodeAt(i)) | 0
  }
  return Math.abs(h)
}

const FORMATS: ShowFormat[] = ['2D', '2D', '3D', 'IMAX'] // weighted toward 2D

function availabilityFromHash(h: number): ShowAvailability {
  const bucket = h % 10
  if (bucket < 1) return 'housefull'
  if (bucket < 4) return 'filling-fast'
  return 'available'
}

/**
 * ShowSummaryResponse has no format, seat-availability, or venue-rating fields yet.
 * Derived deterministically from the show id so the same show always looks the
 * same — placeholder until the backend contract grows to include real values.
 */
function enrichShow(show: ShowSummaryResponse) {
  const h = hashString(show.id)
  return {
    ...show,
    format: FORMATS[h % FORMATS.length],
    availability: availabilityFromHash(h),
    venueRating: Math.round((3.8 + (h % 13) / 10) * 10) / 10,
  }
}

export function enrichEventDetail(detail: EventDetailResponse): EnrichedEventDetail {
  return { ...detail, shows: detail.shows.map(enrichShow) }
}
