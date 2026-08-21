import type { EventSummaryResponse } from '../types/event'

// Fallback data, shaped exactly like event-service's real response, used only
// when the API is unreachable (see fetchEvents) so the UI still has something
// real-looking to render during local frontend development.
export const MOCK_EVENTS: EventSummaryResponse[] = [
  { id: 'mock-1', title: 'Midnight Frequency', category: 'MOVIE', description: 'A sound engineer intercepts a signal that shouldn’t exist.' },
  { id: 'mock-2', title: 'Glasshouse', category: 'MOVIE', description: 'Three generations, one house, one unbearable summer.' },
  { id: 'mock-3', title: 'Northbound', category: 'MOVIE', description: 'A convoy runs the last open road before the border closes.' },
  { id: 'mock-4', title: 'Paper Moons', category: 'MOVIE', description: 'Two strangers, one lost umbrella, a city that keeps them apart.' },
  { id: 'mock-5', title: 'Field Notes', category: 'MOVIE', description: 'A documentary crew follows the last letterpress in the country.' },
  { id: 'mock-6', title: 'Analog Nights Tour', category: 'CONCERT', description: 'A live set built entirely on tape, no laptops on stage.' },
  { id: 'mock-7', title: 'City Jazz Circle', category: 'CONCERT', description: 'A rotating lineup of the city’s best session players.' },
  { id: 'mock-8', title: 'Northbound Sevens', category: 'SPORTS', description: 'Rugby sevens quarterfinal, home ground advantage.' },
  { id: 'mock-9', title: 'Standup: Loose Ends', category: 'COMEDY', description: 'An hour of bits that never quite land where you expect.' },
  { id: 'mock-10', title: 'The Midnight Line', category: 'COMEDY', description: 'A late-night improv troupe takes audience prompts until 1am.' },
]
