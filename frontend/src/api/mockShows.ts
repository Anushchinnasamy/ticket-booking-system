import type { ShowSummaryResponse } from '../types/show'

const VENUES = [
  { name: 'PVR Forum Mall', city: 'Bengaluru' },
  { name: 'INOX Garuda Mall', city: 'Bengaluru' },
  { name: 'Cinepolis Nexus Mall', city: 'Bengaluru' },
  { name: 'Phoenix Arena', city: 'Bengaluru' },
]

const SHOW_TIMES = ['10:15', '13:45', '16:30', '19:50', '22:30']

function hashString(str: string): number {
  let h = 0
  for (let i = 0; i < str.length; i++) {
    h = (Math.imul(31, h) + str.charCodeAt(i)) | 0
  }
  return Math.abs(h)
}

// Generates a plausible set of shows (same shape as the real backend's
// ShowSummaryResponse) for an event, used only when the API is unreachable.
export function generateMockShows(eventId: string, basePrice: number): ShowSummaryResponse[] {
  const h = hashString(eventId)
  const venueCount = 2 + (h % 3)
  const shows: ShowSummaryResponse[] = []
  const now = new Date()

  for (let v = 0; v < venueCount; v++) {
    const venue = VENUES[(h + v) % VENUES.length]
    const dayOffset = v % 3
    const timesForVenue = 2 + ((h + v) % 3)

    for (let t = 0; t < timesForVenue; t++) {
      const [hh, mm] = SHOW_TIMES[(h + v * 2 + t) % SHOW_TIMES.length].split(':').map(Number)
      const startTime = new Date(now)
      startTime.setDate(now.getDate() + dayOffset)
      startTime.setHours(hh, mm, 0, 0)

      shows.push({
        id: `${eventId}-show-${v}-${t}`,
        venueName: venue.name,
        venueCity: venue.city,
        startTime: startTime.toISOString(),
        basePrice: basePrice + (v % 2 === 0 ? 0 : 40),
      })
    }
  }

  return shows
}
