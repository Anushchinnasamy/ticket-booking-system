import type { EnrichedEvent, EventCategory, EventSummaryResponse } from '../types/event'
import { enrichEvent } from './enrichEvent'
import { MOCK_EVENTS } from './mockEvents'

// api-gateway exposes event-service's routes unprefixed at /events (see api-gateway
// route config) — override with VITE_API_BASE_URL for a different environment.
const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export interface FetchEventsResult {
  events: EnrichedEvent[]
  /** true when the real API was unreachable and we fell back to local mock data */
  isFallback: boolean
}

export async function fetchEvents(category?: EventCategory, city?: string): Promise<FetchEventsResult> {
  const url = new URL('/events', API_BASE)
  if (category) url.searchParams.set('category', category)
  if (city) url.searchParams.set('city', city)

  try {
    const res = await fetch(url, { signal: AbortSignal.timeout(12000), cache: 'no-store' })
    if (!res.ok) throw new Error(`GET /events failed with ${res.status}`)
    const data: EventSummaryResponse[] = await res.json()
    return { events: data.map(enrichEvent), isFallback: false }
  } catch (err) {
    console.warn('[events] could not reach the event catalog, falling back to mock data:', err)
    // Mock data has no city dimension, so a city filter can't narrow it — the
    // offline banner already tells the user this is sample data.
    const filtered = category ? MOCK_EVENTS.filter((e) => e.category === category) : MOCK_EVENTS
    return { events: filtered.map(enrichEvent), isFallback: true }
  }
}

const FALLBACK_CITIES = ['Bengaluru', 'Chennai', 'Delhi', 'Hyderabad', 'Kolkata', 'Mumbai']

export async function fetchCities(): Promise<string[]> {
  try {
    const res = await fetch(new URL('/events/cities', API_BASE), { signal: AbortSignal.timeout(12000) })
    if (!res.ok) throw new Error(`GET /events/cities failed with ${res.status}`)
    return await res.json()
  } catch (err) {
    console.warn('[events] could not reach the event catalog for cities, falling back to a static list:', err)
    return FALLBACK_CITIES
  }
}
