import { useEffect, useState } from 'react'
import { CategoryTab } from '../components/CategoryTab'
import { HeroCarousel } from '../components/HeroCarousel'
import { EventRow } from '../components/EventRow'
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
  const recommended = isAllTab ? events.slice(0, 5) : events
  const thisWeekend = isAllTab ? events.slice(5, 9) : []
  const activeCategory = TABS.find((t) => t.label === activeTab)?.category ?? undefined

  return (
    <div className="flex flex-col">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing sample data — couldn't reach the event catalog API. Is the backend running?
        </div>
      )}

      <div className="flex gap-2.5 overflow-x-auto px-4 pt-9 sm:px-6 lg:px-[90px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {TABS.map((tab) => (
          <CategoryTab key={tab.label} label={tab.label} active={activeTab === tab.label} onClick={() => setActiveTab(tab.label)} />
        ))}
      </div>

      <div className="px-4 sm:px-6 lg:px-[90px] pt-9">
        {loading ? (
          <div className="h-[420px] w-full animate-pulse rounded-[22px] bg-surface" />
        ) : (
          <HeroCarousel slides={events.slice(0, 3)} />
        )}
      </div>

      <div className="mt-11 flex flex-col gap-10 pb-20">
        {isAllTab ? (
          <>
            <EventRow title="Recommended for you" events={recommended} loading={loading} seeAllCategory="MOVIE" />
            {(loading || thisWeekend.length > 0) && <EventRow title="This Weekend" events={thisWeekend} loading={loading} seeAllCategory="MOVIE" />}
          </>
        ) : (
          <EventRow title={activeTab} events={events} loading={loading} seeAllCategory={activeCategory} />
        )}
      </div>
    </div>
  )
}
