import { useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react'
import gsap from 'gsap'
import { EventRow } from '../components/EventRow'
import { EmptyState } from '../components/EmptyState'
import { fetchEvents } from '../api/events'
import { inferSportType, type SportType } from '../api/sportType'
import { useCity } from '../hooks/useCity'
import type { EnrichedEvent } from '../types/event'
import stadiumHero from '../assets/sports-hero.png'

const SPORT_PILLS: SportType[] = ['Cricket', 'Football', 'Tennis', 'Badminton', 'Other']

// Only claims this app can actually back — no fabricated "Live Matches"
// (there's no live-match data feed) or "Sports Highlights" (no video content).
const FEATURES = [
  { label: 'Instant Booking', icon: 'M13 2 3 14h7l-1 8 10-12h-7l1-8z' },
  { label: 'Secure Payments', icon: 'M12 2 4 5v6c0 5 3.4 8.6 8 9 4.6-.4 8-4 8-9V5l-8-3z' },
  { label: 'Digital Tickets', icon: 'M4 6h16v4a2 2 0 0 0 0 4v4H4v-4a2 2 0 0 0 0-4V6z' },
  { label: 'Verified Venues', icon: 'M12 21s7-6.1 7-12a7 7 0 1 0-14 0c0 5.9 7 12 7 12z' },
]

export function SportsHome() {
  const city = useCity()
  const [events, setEvents] = useState<EnrichedEvent[]>([])
  const [loading, setLoading] = useState(true)
  const [isFallback, setIsFallback] = useState(false)
  const [activeSport, setActiveSport] = useState<SportType | 'All'>('All')

  const bgRef = useRef<HTMLDivElement>(null)
  const sweepRef = useRef<HTMLDivElement>(null)
  const badgeRef = useRef<HTMLSpanElement>(null)
  const headlineRef = useRef<HTMLHeadingElement>(null)
  const copyRef = useRef<HTMLParagraphElement>(null)
  const ctaRef = useRef<HTMLButtonElement>(null)
  const upcomingRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    setLoading(true)
    fetchEvents('SPORTS', city).then((result) => {
      setEvents(result.events)
      setIsFallback(result.isFallback)
      setLoading(false)
    })
  }, [city])

  const sportOf = (e: EnrichedEvent) => inferSportType(e.title, e.description)

  const availableSports = useMemo(() => {
    const present = new Set(events.map(sportOf))
    return SPORT_PILLS.filter((s) => present.has(s))
  }, [events])

  const filteredEvents = useMemo(() => {
    if (activeSport === 'All') return events
    return events.filter((e) => sportOf(e) === activeSport)
  }, [events, activeSport])

  // Signature sports hero: dark stadium -> one restrained light sweep -> badge
  // -> headline -> CTA. Kept to a single pass (no looping/particles) per the
  // addendum's "do not overdo effects" guidance.
  useLayoutEffect(() => {
    const targets = [bgRef.current, sweepRef.current, badgeRef.current, headlineRef.current, copyRef.current, ctaRef.current]
    if (targets.some((t) => !t)) return

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      gsap.set(targets, { clearProps: 'all' })
      return
    }

    gsap.set(bgRef.current, { opacity: 0, scale: 1.1 })
    gsap.set(sweepRef.current, { xPercent: -130, opacity: 0 })
    gsap.set([badgeRef.current, copyRef.current, ctaRef.current], { opacity: 0, y: 14 })
    gsap.set(headlineRef.current, { opacity: 0, y: 18 })

    const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })
    tl.to(bgRef.current, { opacity: 1, scale: 1, duration: 1.3, ease: 'power2.out' })
      .to(sweepRef.current, { opacity: 0.5, duration: 0.15 }, 0.3)
      .to(sweepRef.current, { xPercent: 130, opacity: 0, duration: 0.9, ease: 'power1.inOut' }, 0.3)
      .to(badgeRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.5)
      .to(headlineRef.current, { opacity: 1, y: 0, duration: 0.5 }, 0.65)
      .to(copyRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.85)
      .to(ctaRef.current, { opacity: 1, y: 0, duration: 0.4 }, 1.0)

    return () => {
      tl.kill()
    }
  }, [])

  function scrollToUpcoming() {
    upcomingRef.current?.scrollIntoView({ behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth', block: 'start' })
  }

  return (
    <div className="flex flex-col pb-20">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing sample data — couldn't reach the event catalog API.
        </div>
      )}

      {/* Hero */}
      <section className="relative overflow-hidden">
        <div ref={bgRef} className="absolute inset-0">
          <img src={stadiumHero} alt="" aria-hidden className="h-full w-full object-cover brightness-[0.55]" />
          <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/75 to-bg/25" />
          <div className="absolute inset-0 bg-gradient-to-r from-bg via-bg/35 to-transparent" />
        </div>
        <div ref={sweepRef} className="pointer-events-none absolute inset-y-0 left-0 w-1/3 -skew-x-12 bg-gradient-to-r from-transparent via-white/25 to-transparent" />

        <div className="relative flex flex-col items-start gap-4 px-4 pb-14 pt-16 sm:px-6 sm:pb-20 sm:pt-24 lg:px-[90px] lg:pb-28 lg:pt-32">
          <span ref={badgeRef} className="inline-flex items-center gap-2 rounded-full border border-gold/35 bg-accent-dim px-3.5 py-1.5 text-[11px] font-bold uppercase tracking-[0.18em] text-gold sm:text-xs">
            🏆 Live Sports Arena
          </span>
          <h1 ref={headlineRef} className="font-display text-[34px] font-bold leading-[1.05] tracking-tight sm:text-[52px] lg:text-[68px]">
            <span className="text-text-primary">Feel the </span>
            <span className="text-gold">GAME LIVE</span>
          </h1>
          <p ref={copyRef} className="max-w-md text-[15px] leading-relaxed text-text-secondary sm:text-base">
            Courtside, pitch-side, ringside — book your seat for the moments everyone will be talking about tomorrow.
          </p>
          <button
            ref={ctaRef}
            onClick={scrollToUpcoming}
            className="group mt-2 inline-flex w-fit cursor-pointer items-center gap-2 rounded-xl bg-accent px-7 py-3.5 text-sm font-semibold text-obsidian shadow-[0_8px_24px_rgba(245,166,35,0.35)] transition-transform hover:brightness-110 active:scale-[0.97]"
          >
            Book Sports Tickets
            <span className="transition-transform duration-200 group-hover:translate-x-1">→</span>
          </button>
        </div>
      </section>

      {/* Sport category pills */}
      {availableSports.length > 0 && (
        <div className="flex gap-2.5 overflow-x-auto px-4 pt-9 sm:px-6 lg:px-[90px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          <button
            onClick={() => setActiveSport('All')}
            className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer transition-colors ${
              activeSport === 'All' ? 'border-2 border-gold bg-accent-dim text-gold shadow-[0_0_0_3px_rgba(245,166,35,0.15)]' : 'border border-border bg-surface text-text-secondary hover:border-gold/40'
            }`}
          >
            All Sports
          </button>
          {availableSports.map((sport) => (
            <button
              key={sport}
              onClick={() => setActiveSport(sport)}
              className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer transition-colors ${
                activeSport === sport ? 'border-2 border-gold bg-accent-dim text-gold shadow-[0_0_0_3px_rgba(245,166,35,0.15)]' : 'border border-border bg-surface text-text-secondary hover:border-gold/40'
              }`}
            >
              {sport}
            </button>
          ))}
        </div>
      )}

      {/* Upcoming sports events */}
      <div ref={upcomingRef} className="mt-11 scroll-mt-6">
        {!loading && events.length === 0 ? (
          <div className="px-4 sm:px-6 lg:px-[90px]">
            <EmptyState
              title="NO SPORTS EVENTS YET"
              message={`No sports fixtures are live in ${city || 'your city'} right now — check back soon or browse another city.`}
            />
          </div>
        ) : !loading && filteredEvents.length === 0 ? (
          <div className="px-4 sm:px-6 lg:px-[90px]">
            <EmptyState title="NO MATCHES" message={`No ${activeSport.toLowerCase()} events right now — try another sport.`} />
          </div>
        ) : (
          <EventRow title="Upcoming Sports Events" events={filteredEvents} loading={loading} seeAllCategory="SPORTS" />
        )}
      </div>

      {/* Feature strip */}
      <div className="mt-16 border-t border-divider px-4 pt-10 sm:px-6 lg:px-[90px]">
        <div className="grid grid-cols-2 gap-6 sm:grid-cols-4">
          {FEATURES.map((f) => (
            <div key={f.label} className="flex flex-col items-center gap-2.5 text-center sm:flex-row sm:text-left">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0">
                <path d={f.icon} />
              </svg>
              <span className="text-[13px] font-semibold text-text-secondary">{f.label}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
