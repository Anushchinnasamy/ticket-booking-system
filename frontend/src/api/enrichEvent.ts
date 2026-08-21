import type { BookingStatus, EnrichedEvent, EventCategory, EventSummaryResponse } from '../types/event'

import poster1 from '../assets/posters/poster-1.jpg'
import poster2 from '../assets/posters/poster-2.jpg'
import poster3 from '../assets/posters/poster-3.jpg'
import poster4 from '../assets/posters/poster-4.jpg'
import poster5 from '../assets/posters/poster-5.jpg'
import poster6 from '../assets/posters/poster-6.jpg'
import poster7 from '../assets/posters/poster-7.jpg'
import poster8 from '../assets/posters/poster-8.jpg'
import poster9 from '../assets/posters/poster-9.jpg'
import poster10 from '../assets/posters/poster-10.jpg'
import posterJurassic from '../assets/posters/poster-jurassic.jpg'
import posterBladeRunner from '../assets/posters/poster-bladerunner.jpg'
import posterArrival from '../assets/posters/poster-arrival.jpg'

const POSTERS = [poster1, poster2, poster3, poster4, poster5, poster6, poster7, poster8, poster9, poster10]

// Curated (not hash-assigned) posters for a few named movies in the seed
// catalog — event-service still has no posterUrl field, so this is a
// hand-picked override keyed by title (not id, which changes across catalog
// migrations), layered over the generic deterministic assignment every
// other event still gets.
const POSTER_OVERRIDES: Record<string, string> = {
  'jurassic park': posterJurassic,
  'blade runner 2049': posterBladeRunner,
  arrival: posterArrival,
}

const PRICE_RANGES: Record<EventCategory, [number, number]> = {
  MOVIE: [180, 350],
  CONCERT: [600, 2000],
  SPORTS: [300, 900],
  COMEDY: [250, 500],
}

// Deterministic string hash so the same event id always enriches to the same
// poster/rating/price/status — stable across re-fetches, not random flicker.
function hashString(str: string): number {
  let h = 0
  for (let i = 0; i < str.length; i++) {
    h = (Math.imul(31, h) + str.charCodeAt(i)) | 0
  }
  return Math.abs(h)
}

/** Same poster an event gets everywhere else in the app. */
export function pickPoster(id: string, title?: string): string {
  const override = title ? POSTER_OVERRIDES[title.trim().toLowerCase()] : undefined
  return override ?? POSTERS[hashString(id) % POSTERS.length]
}

function statusFromHash(h: number): BookingStatus {
  const bucket = h % 10
  if (bucket < 1) return 'housefull'
  if (bucket < 4) return 'filling-fast'
  return 'available'
}

/**
 * event-service's GET /events only returns {id, title, category, description}.
 * Poster/rating/price/status/bookedCount are placeholders derived deterministically
 * from the event id until the backend contract is extended to include them.
 */
export function enrichEvent(event: EventSummaryResponse): EnrichedEvent {
  const h = hashString(event.id)
  const [min, max] = PRICE_RANGES[event.category]

  return {
    ...event,
    posterUrl: pickPoster(event.id, event.title),
    rating: Math.round((6.5 + (h % 31) / 10) * 10) / 10,
    price: min + (h % (max - min)),
    bookedCount: `${((h % 320) / 10 + 1).toFixed(1)}K`,
    status: statusFromHash(h),
  }
}
