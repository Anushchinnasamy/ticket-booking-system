import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { CategoryTab } from '../components/CategoryTab'
import { CinematicHero } from '../components/CinematicHero'
import { HeroCarousel } from '../components/HeroCarousel'
import { TopCategories } from '../components/TopCategories'
import { EventRow } from '../components/EventRow'
import { PrimaryButton } from '../components/PrimaryButton'
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

export function Home() {
  const navigate = useNavigate()
  const city = useCity()
  const [activeTab, setActiveTab] = useState<string>('All')
  const [events, setEvents] = useState<EnrichedEvent[]>([])
  const [loading, setLoading] = useState(true)
  const [isFallback, setIsFallback] = useState(false)

  useEffect(() => {
    const category = TABS.find((t) => t.label === activeTab)?.category ?? undefined
    let cancelled = false
    setLoading(true)

    fetchEvents(category, city).then((result) => {
      if (cancelled) return
      setEvents(result.events)
      setIsFallback(result.isFallback)
      setLoading(false)
    })

    return () => {
      cancelled = true
    }
  }, [activeTab, city])

  const isAllTab = activeTab === 'All'
  // "Now Showing"/"This Weekend" are movie-specific sections (their heading,
  // and their "See all" both say so) — slicing the raw `events` list here
  // silently let non-movie events show up under a "Now Showing" label
  // whenever they happened to sort near the front.
  const movies = events.filter((e) => e.category === 'MOVIE')
  const recommended = isAllTab ? movies.slice(0, 5) : events
  const thisWeekend = isAllTab ? movies.slice(5, 9) : []
  // Trending previously just re-sliced the same movie-heavy front of the
  // list, so it was effectively a duplicate of "Now Showing" and never
  // visibly changed when switching cities — the backend returns ~60 movies
  // that play in every city, so a plain events.slice(0, 3) is movies every
  // time. Concerts/Sports/Comedy are the events that actually differ by
  // city, so surface those first (real data, just reordered) and only fill
  // remaining slots with movies.
  const trending = isAllTab
    ? [...events.filter((e) => e.category !== 'MOVIE'), ...movies].slice(0, 3)
    : []
  const activeCategory = TABS.find((t) => t.label === activeTab)?.category ?? undefined

  return (
    <div className="flex flex-col">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing sample data — couldn't reach the event catalog API. Is the backend running?
        </div>
      )}

      <CinematicHero loading={loading} />

      <div className="flex gap-2.5 overflow-x-auto px-4 pt-9 sm:px-6 lg:px-[90px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {TABS.map((tab) => (
          <CategoryTab key={tab.label} label={tab.label} active={activeTab === tab.label} onClick={() => setActiveTab(tab.label)} />
        ))}
      </div>

      <div className="mt-11 flex flex-col gap-14 pb-20">
        {isAllTab ? (
          <>
            <EventRow title="Now Showing" events={recommended} loading={loading} seeAllCategory="MOVIE" />
            <TopCategories />
            <section className="flex flex-col gap-4.5">
              <div className="px-4 sm:px-6 lg:px-[90px]">
                <h2 className="font-display text-[22px] font-bold tracking-tight">Trending</h2>
              </div>
              <div className="px-4 sm:px-6 lg:px-[90px]">
                {loading ? (
                  <div className="h-[260px] w-full animate-pulse rounded-2xl bg-surface sm:h-[320px]" />
                ) : (
                  <HeroCarousel slides={trending} />
                )}
              </div>
            </section>
            {(loading || thisWeekend.length > 0) && <EventRow title="This Weekend" events={thisWeekend} loading={loading} seeAllCategory="MOVIE" />}

            <section className="mx-4 flex flex-col items-center gap-4 rounded-[22px] border border-border bg-surface px-6 py-14 text-center sm:mx-6 lg:mx-[90px]">
              <h2 className="font-display text-2xl font-bold tracking-tight sm:text-3xl">Ready for the next show?</h2>
              <p className="max-w-sm text-sm text-text-secondary">Find a seat, grab your tickets, and live the movie magic.</p>
              <PrimaryButton onClick={() => navigate('/search')} className="mt-2">Browse Movies</PrimaryButton>
            </section>
          </>
        ) : (
          <EventRow title={activeTab} events={events} loading={loading} seeAllCategory={activeCategory} />
        )}
      </div>
    </div>
  )
}
