import type { EnrichedEvent } from '../types/event'
import type { EnrichedEventDetail, EventDetailResponse } from '../types/show'
import { enrichEvent } from './enrichEvent'
import { enrichEventDetail } from './enrichShow'
import { MOCK_EVENTS } from './mockEvents'
import { generateMockShows } from './mockShows'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export interface FetchEventDetailResult {
  summary: EnrichedEvent
  detail: EnrichedEventDetail
  isFallback: boolean
}

export async function fetchEventDetail(eventId: string): Promise<FetchEventDetailResult | null> {
  try {
    const res = await fetch(new URL(`/events/${eventId}`, API_BASE), { signal: AbortSignal.timeout(12000) })
    if (!res.ok) throw new Error(`GET /events/${eventId} failed with ${res.status}`)
    const data: EventDetailResponse = await res.json()
    return {
      summary: enrichEvent(data),
      detail: enrichEventDetail(data),
      isFallback: false,
    }
  } catch (err) {
    console.warn(`[eventDetail] could not reach the event catalog for ${eventId}, falling back to mock data:`, err)
    const mockEvent = MOCK_EVENTS.find((e) => e.id === eventId)
    if (!mockEvent) return null

    const summary = enrichEvent(mockEvent)
    const detailResponse: EventDetailResponse = {
      ...mockEvent,
      shows: generateMockShows(mockEvent.id, summary.price),
    }
    return { summary, detail: enrichEventDetail(detailResponse), isFallback: true }
  }
}
