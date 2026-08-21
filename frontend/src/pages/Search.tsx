import { useEffect, useMemo, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { CategoryTab } from '../components/CategoryTab'
import { MovieCard } from '../components/MovieCard'
import { CardSkeleton } from '../components/CardSkeleton'
import { fetchEvents } from '../api/events'
import { useCity } from '../hooks/useCity'
import type { EnrichedEvent, EventCategory } from '../types/event'

const TABS: { label: string; category: EventCategory | null }[] = [
  { label: 'All', category: null },
  { label: 'Movies', category: 'MOVIE' },
  { label: 'Concerts', category: 'CONCERT' },
  { label: 'Sports', category: 'SPORTS' },
  { label: 'Comedy', category: 'COMEDY' },
]

const DEBOUNCE_MS = 300

export function Search() {
  const navigate = useNavigate()
  const location = useLocation()
  const city = useCity()
  const presetCategory = (location.state as { category?: EventCategory } | null)?.category
  const [allEvents, setAllEvents] = useState<EnrichedEvent[]>([])
  const [loading, setLoading] = useState(true)
  const [rawQuery, setRawQuery] = useState('')
  const [debouncedQuery, setDebouncedQuery] = useState('')
  const [activeTab, setActiveTab] = useState(() => TABS.find((t) => t.category === presetCategory)?.label ?? 'All')

  // event-service has no title-search endpoint yet — fetch the (city-filtered)
  // catalog once per city and filter by title client-side until one exists.
  useEffect(() => {
    setLoading(true)
    fetchEvents(undefined, city).then((result) => {
      setAllEvents(result.events)
      setLoading(false)
    })
  }, [city])

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedQuery(rawQuery.trim().toLowerCase()), DEBOUNCE_MS)
    return () => clearTimeout(timer)
  }, [rawQuery])

  // clears the query when the category changes, per the SearchBar spec
  useEffect(() => {
    setRawQuery('')
    setDebouncedQuery('')
  }, [activeTab])

  const category = TABS.find((t) => t.label === activeTab)?.category ?? null

  const results = useMemo(() => {
    return allEvents.filter((event) => {
      const matchesCategory = category === null || event.category === category
      const matchesQuery = debouncedQuery === '' || event.title.toLowerCase().includes(debouncedQuery)
      return matchesCategory && matchesQuery
    })
  }, [allEvents, category, debouncedQuery])

  return (
    <div className="flex flex-col gap-5 px-4 pb-20 pt-7 sm:px-6 lg:px-[90px]">
      <div className="mx-auto flex w-full max-w-[520px] items-center gap-2.5 rounded-[10px] border border-accent bg-surface px-4 py-2.5">
        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-secondary)" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
          <circle cx="11" cy="11" r="7" />
          <path d="M21 21l-4.3-4.3" />
        </svg>
        <input
          autoFocus
          value={rawQuery}
          onChange={(e) => setRawQuery(e.target.value)}
          placeholder="Search for movies, events, plays..."
          className="w-full bg-transparent text-[13.5px] text-text-primary placeholder:text-text-secondary focus:outline-none"
        />
      </div>

      <div className="text-center text-[13px] text-text-secondary">
        {debouncedQuery ? (
          <>
            Showing results for <span className="font-semibold text-text-primary">"{debouncedQuery}"</span> · {results.length} match{results.length === 1 ? '' : 'es'}
          </>
        ) : (
          `${results.length} shows`
        )}
      </div>

      <div className="flex justify-start gap-2.5 overflow-x-auto px-1 sm:justify-center [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {TABS.map((tab) => (
          <CategoryTab key={tab.label} label={tab.label} active={activeTab === tab.label} onClick={() => setActiveTab(tab.label)} />
        ))}
      </div>

      <div className="mt-4 grid grid-cols-1 place-items-center gap-5 sm:grid-cols-3 sm:gap-7 sm:place-items-stretch lg:grid-cols-5">
        {loading ? (
          Array.from({ length: 5 }).map((_, i) => <CardSkeleton key={i} />)
        ) : results.length === 0 ? (
          <div className="col-span-full flex flex-col items-center gap-2 py-20 text-center">
            <div className="font-display text-lg font-bold">No matches</div>
            <div className="text-sm text-text-secondary">Try a different title or category.</div>
          </div>
        ) : (
          results.map((event) => (
            <MovieCard
              key={event.id}
              id={event.id}
              title={event.title}
              genre={event.category}
              price={event.price}
              rating={event.rating}
              bookedCount={event.bookedCount}
              status={event.status}
              posterUrl={event.posterUrl}
              onClick={() => navigate(`/events/${event.id}`)}
            />
          ))
        )}
      </div>
    </div>
  )
}
