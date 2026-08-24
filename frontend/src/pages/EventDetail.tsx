import { useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { motion } from 'framer-motion'
import gsap from 'gsap'
import { fetchEventDetail, type FetchEventDetailResult } from '../api/eventDetail'
import { getCastCrew } from '../api/castCrew'
import { GalleryLightbox } from '../components/GalleryLightbox'
import { ErrorState } from '../components/ErrorState'
import type { EnrichedShow, ShowFormat } from '../types/show'

type DetailTab = 'about' | 'showtimes' | 'reviews' | 'gallery'

const STATUS_PILL: Record<EnrichedShow['availability'], string> = {
  available: 'bg-success/12 text-success border border-success/35',
  'filling-fast': 'bg-accent-dim text-gold border border-gold/30',
  housefull: 'bg-surface-raised text-text-muted border border-border-muted cursor-not-allowed',
}

const STATUS_SENTIMENT: Record<EnrichedShow['availability'], string> = {
  available: 'Good availability',
  'filling-fast': 'Selling fast',
  housefull: 'Almost sold out',
}

const SHOW_LABEL: Record<EnrichedShow['availability'], string> = {
  available: '',
  'filling-fast': 'Few Seats',
  housefull: 'Sold Out',
}

const TABS: { key: DetailTab; label: string }[] = [
  { key: 'about', label: 'About' },
  { key: 'showtimes', label: 'Showtimes' },
  { key: 'reviews', label: 'Reviews' },
  { key: 'gallery', label: 'Gallery' },
]

function formatDateKey(iso: string) {
  return new Date(iso).toDateString()
}

function formatDayLabel(iso: string) {
  const d = new Date(iso)
  return {
    weekday: d.toLocaleDateString('en-US', { weekday: 'short' }).toUpperCase(),
    day: d.getDate(),
    month: d.toLocaleDateString('en-US', { month: 'short' }).toUpperCase(),
  }
}

function formatShortDate(iso: string) {
  return new Date(iso).toLocaleDateString('en-US', { day: 'numeric', month: 'short' })
}

function formatTime(iso: string) {
  return new Date(iso).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })
}

function isStarted(iso: string) {
  return new Date(iso).getTime() <= Date.now()
}

function useWatchlist(eventId: string | undefined) {
  const [watchlisted, setWatchlisted] = useState(false)

  useEffect(() => {
    if (!eventId) return
    try {
      const raw = localStorage.getItem('watchlist')
      const ids: string[] = raw ? JSON.parse(raw) : []
      setWatchlisted(ids.includes(eventId))
    } catch {
      setWatchlisted(false)
    }
  }, [eventId])

  const toggle = () => {
    if (!eventId) return
    try {
      const raw = localStorage.getItem('watchlist')
      const ids: string[] = raw ? JSON.parse(raw) : []
      const next = ids.includes(eventId) ? ids.filter((id) => id !== eventId) : [...ids, eventId]
      localStorage.setItem('watchlist', JSON.stringify(next))
      setWatchlisted(next.includes(eventId))
    } catch {
      // localStorage unavailable — watchlist is a nice-to-have, fail silently
    }
  }

  return [watchlisted, toggle] as const
}

export function EventDetail() {
  const { eventId } = useParams<{ eventId: string }>()
  const navigate = useNavigate()
  const [result, setResult] = useState<FetchEventDetailResult | null | undefined>(undefined)
  const [fetchFailed, setFetchFailed] = useState(false)
  const [format, setFormat] = useState<ShowFormat | null>(null)
  const [selectedDate, setSelectedDate] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState<DetailTab>('about')
  const [galleryIndex, setGalleryIndex] = useState<number | null>(null)
  const [watchlisted, toggleWatchlist] = useWatchlist(eventId)

  const aboutRef = useRef<HTMLDivElement>(null)
  const showtimesRef = useRef<HTMLDivElement>(null)
  const reviewsRef = useRef<HTMLDivElement>(null)
  const galleryRef = useRef<HTMLDivElement>(null)

  const badgeRef = useRef<HTMLDivElement>(null)
  const titleRef = useRef<HTMLHeadingElement>(null)
  const metaRef = useRef<HTMLDivElement>(null)
  const descRef = useRef<HTMLParagraphElement>(null)
  const ctaRef = useRef<HTMLDivElement>(null)
  const panelRef = useRef<HTMLDivElement>(null)
  const bgRef = useRef<HTMLDivElement>(null)

  function load() {
    if (!eventId) return
    setResult(undefined)
    setFetchFailed(false)
    fetchEventDetail(eventId)
      .then(setResult)
      .catch(() => {
        setResult(null)
        setFetchFailed(true)
      })
  }

  useEffect(load, [eventId])

  const allDates = useMemo(() => {
    if (!result) return []
    const seen = new Map<string, string>()
    for (const show of result.detail.shows) {
      const key = formatDateKey(show.startTime)
      if (!seen.has(key)) seen.set(key, show.startTime)
    }
    return [...seen.values()].sort()
  }, [result])

  const availableFormats = useMemo(() => {
    if (!result) return []
    return [...new Set(result.detail.shows.map((s) => s.format))]
  }, [result])

  const allVenueCount = useMemo(() => {
    if (!result) return 0
    return new Set(result.detail.shows.map((s) => `${s.venueName}__${s.venueCity}`)).size
  }, [result])

  useEffect(() => {
    if (allDates.length > 0 && !selectedDate) setSelectedDate(formatDateKey(allDates[0]))
  }, [allDates, selectedDate])

  const filteredShows = useMemo(() => {
    if (!result) return []
    return result.detail.shows.filter((show) => {
      const matchesDate = !selectedDate || formatDateKey(show.startTime) === selectedDate
      const matchesFormat = !format || show.format === format
      return matchesDate && matchesFormat
    })
  }, [result, selectedDate, format])

  const nextBookableShow = useMemo(() => result?.detail.shows.find((s) => !isStarted(s.startTime)), [result])

  const venueGroups = useMemo(() => {
    const groups = new Map<string, { venueName: string; venueCity: string; venueRating: number; shows: EnrichedShow[] }>()
    for (const show of filteredShows) {
      const key = `${show.venueName}__${show.venueCity}`
      if (!groups.has(key)) groups.set(key, { venueName: show.venueName, venueCity: show.venueCity, venueRating: show.venueRating, shows: [] })
      groups.get(key)!.shows.push(show)
    }
    return [...groups.values()]
  }, [filteredShows])

  const castCrew = result ? getCastCrew(result.summary.title) : undefined

  const metadataParts = useMemo(() => {
    if (!result) return []
    const parts: string[] = []
    if (allDates.length === 1) parts.push(formatShortDate(allDates[0]))
    else if (allDates.length > 1) parts.push(`${formatShortDate(allDates[0])} – ${formatShortDate(allDates[allDates.length - 1])}`)
    if (allVenueCount > 0) parts.push(`${allVenueCount} venue${allVenueCount > 1 ? 's' : ''}`)
    if (castCrew?.language) parts.push(castCrew.language)
    return parts
  }, [result, allDates, allVenueCount, castCrew])

  // Hero entrance choreography — runs once the summary is available. Poster
  // itself uses a framer-motion layoutId (shared-element continuity from the
  // Home/Search poster card) so it's deliberately excluded from this timeline.
  useLayoutEffect(() => {
    if (!result) return
    const targets = [badgeRef.current, titleRef.current, metaRef.current, descRef.current, ctaRef.current, panelRef.current, bgRef.current]
    if (targets.some((t) => !t)) return

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      gsap.set(targets, { clearProps: 'all' })
      return
    }

    gsap.set(bgRef.current, { opacity: 0, scale: 1.08 })
    gsap.set([badgeRef.current, metaRef.current, descRef.current, panelRef.current], { opacity: 0, y: 14 })
    gsap.set(titleRef.current, { opacity: 0, y: 18 })
    gsap.set(ctaRef.current, { opacity: 0, y: 10 })

    const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })
    tl.to(bgRef.current, { opacity: 1, scale: 1, duration: 1.2, ease: 'power2.out' })
      .to(badgeRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.25)
      .to(titleRef.current, { opacity: 1, y: 0, duration: 0.5 }, 0.35)
      .to(metaRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.5)
      .to(descRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.6)
      .to(ctaRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.7)
      .to(panelRef.current, { opacity: 1, y: 0, duration: 0.4 }, 0.75)

    return () => {
      tl.kill()
    }
  }, [result])

  // Scroll-spy: the active tab is the last section (in page order) whose top
  // has crossed above the trigger line. A ratio/overlap-based IntersectionObserver
  // doesn't work here — the Showtimes column is much taller than the About/Gallery
  // subsections beside it, so it stays "intersecting" almost continuously and
  // starves the short sections out. Tracking top-crossing (classic scrollspy)
  // avoids that regardless of section height.
  const suppressSpyUntil = useRef(0)

  useEffect(() => {
    if (!result) return
    const allSections: { key: DetailTab; el: HTMLDivElement | null }[] = [
      { key: 'about', el: aboutRef.current },
      { key: 'showtimes', el: showtimesRef.current },
      { key: 'gallery', el: galleryRef.current },
      { key: 'reviews', el: reviewsRef.current },
    ]
    const sections = allSections.filter((s): s is { key: DetailTab; el: HTMLDivElement } => s.el !== null)
    const triggerY = 140
    let ticking = false

    function evaluate() {
      ticking = false
      if (Date.now() < suppressSpyUntil.current) return
      let current = sections[0]
      for (const s of sections) {
        if (s.el.getBoundingClientRect().top <= triggerY) current = s
      }
      setActiveTab(current.key)
    }

    function onScroll() {
      if (ticking) return
      ticking = true
      requestAnimationFrame(evaluate)
    }

    window.addEventListener('scroll', onScroll, { passive: true })
    evaluate()
    return () => window.removeEventListener('scroll', onScroll)
  }, [result])

  function scrollToTab(tab: DetailTab) {
    setActiveTab(tab)
    suppressSpyUntil.current = Date.now() + 700
    const map: Record<DetailTab, HTMLDivElement | null> = {
      about: aboutRef.current,
      showtimes: showtimesRef.current,
      gallery: galleryRef.current,
      reviews: reviewsRef.current,
    }
    map[tab]?.scrollIntoView({ behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth', block: 'start' })
  }

  if (result === undefined) {
    return (
      <div className="flex flex-col gap-6 pb-20">
        <div className="h-[420px] w-full animate-pulse bg-surface sm:h-[460px]" />
        <div className="flex flex-col gap-6 px-4 sm:px-6 lg:px-[90px]">
          <div className="h-8 w-72 animate-pulse rounded bg-surface" />
          <div className="flex flex-col gap-4 lg:flex-row">
            <div className="flex flex-1 flex-col gap-3">
              <div className="h-24 w-full animate-pulse rounded-2xl bg-surface" />
              <div className="h-24 w-full animate-pulse rounded-2xl bg-surface" />
              <div className="h-24 w-full animate-pulse rounded-2xl bg-surface" />
            </div>
            <div className="h-48 w-full animate-pulse rounded-2xl bg-surface lg:w-[340px]" />
          </div>
        </div>
      </div>
    )
  }

  if (result === null) {
    return (
      <ErrorState
        message={fetchFailed ? "We couldn't load this event. Check your connection and try again." : "This event doesn't exist or may have been removed."}
        actionLabel={fetchFailed ? 'Try Again' : 'Back to Home'}
        onAction={fetchFailed ? load : () => navigate('/')}
      />
    )
  }

  const { summary, isFallback } = result
  const galleryImages = [{ src: summary.posterUrl, alt: `${summary.title} poster` }]

  return (
    <div className="flex flex-col pb-24 lg:pb-20">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing sample showtimes — couldn't reach the event catalog API.
        </div>
      )}

      {/* Hero */}
      <section className="relative overflow-hidden">
        <div ref={bgRef} className="absolute inset-0">
          <img src={summary.posterUrl} alt="" aria-hidden className="h-full w-full object-cover brightness-[0.5]" />
          <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/85 to-bg/25" />
          <div className="absolute inset-0 bg-gradient-to-r from-bg via-bg/55 to-transparent" />
          <div className="absolute inset-0 shadow-[inset_0_0_180px_60px_rgba(0,0,0,0.65)]" />
        </div>

        <div className="relative flex flex-col gap-5 px-4 pb-8 pt-9 sm:px-6 sm:pb-10 sm:pt-12 lg:flex-row lg:items-end lg:gap-9 lg:px-[90px] lg:pb-14 lg:pt-24">
          <motion.img
            layoutId={`poster-${summary.id}`}
            src={summary.posterUrl}
            alt={summary.title}
            className="aspect-[2/3] w-[120px] flex-shrink-0 rounded-xl border-[3px] border-bg object-cover shadow-[0_20px_50px_-10px_rgba(0,0,0,0.7)] sm:w-[160px] sm:rounded-2xl lg:w-[210px]"
          />

          <div className="flex flex-1 flex-col gap-2.5 sm:gap-3">
            <div ref={badgeRef} className="flex flex-wrap items-center gap-2 sm:gap-2.5">
              <span className={`rounded-md px-2 py-1 text-[10px] font-bold sm:px-2.5 sm:py-1.5 sm:text-[11px] ${STATUS_PILL[summary.status]}`}>
                {summary.status.replace('-', ' ').toUpperCase()}
              </span>
              <div className="flex items-center gap-1">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="var(--color-gold)"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
                <span className="font-variant-numeric-tabular text-xs font-bold sm:text-[13px]">{summary.rating.toFixed(1)}</span>
                <span className="text-[11px] text-text-secondary sm:text-xs">({summary.bookedCount} booked)</span>
              </div>
            </div>

            <h1 ref={titleRef} className="font-display text-2xl font-extrabold tracking-tight sm:text-3xl lg:text-[44px]">
              {summary.title}
            </h1>

            <div ref={metaRef} className="flex flex-wrap items-center gap-x-2 gap-y-1 text-xs text-text-secondary sm:text-sm">
              <span className="font-semibold uppercase tracking-wide text-gold">{summary.category}</span>
              {metadataParts.map((part, i) => (
                <span key={i} className="flex items-center gap-2">
                  <span className="text-text-muted">·</span>
                  <span>{part}</span>
                </span>
              ))}
            </div>

            <p ref={descRef} className="max-w-xl text-[13px] leading-relaxed text-text-secondary line-clamp-2 sm:text-sm">
              {summary.description}
            </p>

            <div ref={ctaRef} className="mt-1 flex flex-wrap items-center gap-3 sm:mt-2">
              <button
                onClick={() => scrollToTab('showtimes')}
                className="group inline-flex cursor-pointer items-center gap-2 rounded-xl bg-accent px-6 py-3 text-[13px] font-bold text-obsidian shadow-[0_10px_28px_rgba(245,166,35,0.4)] transition-transform hover:brightness-110 active:scale-[0.97] sm:px-7 sm:py-3.5 sm:text-sm"
              >
                Book Tickets
                <span className="transition-transform duration-200 group-hover:translate-x-1">→</span>
              </button>
              <button
                onClick={toggleWatchlist}
                aria-pressed={watchlisted}
                className="inline-flex cursor-pointer items-center gap-2 rounded-xl border border-border bg-surface/70 px-5 py-3 text-[13px] font-semibold text-text-primary transition-colors hover:border-gold/40 sm:py-3.5 sm:text-sm"
              >
                <svg width="15" height="15" viewBox="0 0 24 24" fill={watchlisted ? 'var(--color-gold)' : 'none'} stroke={watchlisted ? 'var(--color-gold)' : 'currentColor'} strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
                  <path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8z" />
                </svg>
                {watchlisted ? 'On Watchlist' : 'Add to Watchlist'}
              </button>
            </div>
          </div>

          <div ref={panelRef} className="hidden w-[220px] flex-shrink-0 flex-col gap-2 rounded-2xl border border-border bg-surface/70 p-5 backdrop-blur-sm lg:flex">
            <div className="flex items-baseline gap-1.5">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="var(--color-gold)"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
              <span className="font-display text-2xl font-extrabold">{summary.rating.toFixed(1)}</span>
              <span className="text-xs text-text-muted">/ 10</span>
            </div>
            <div className="text-xs text-text-secondary">{summary.bookedCount} booked</div>
            <div className="mt-1 text-[12.5px] font-semibold text-gold">{STATUS_SENTIMENT[summary.status]}</div>
          </div>
        </div>
      </section>

      <div className="mt-2 flex flex-col gap-6 px-4 sm:px-6 lg:mt-3 lg:px-[90px]">
        {/* Tabs */}
        <div role="tablist" aria-label="Event details" className="flex items-center justify-between overflow-x-auto border-b border-divider pb-1 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          <div className="flex gap-6 sm:gap-9">
            {TABS.map((tab) => (
              <button
                key={tab.key}
                role="tab"
                aria-selected={activeTab === tab.key}
                onClick={() => scrollToTab(tab.key)}
                className={`cursor-pointer border-b-2 pb-3.5 font-display text-[15px] font-bold ${
                  activeTab === tab.key ? 'border-accent text-text-primary' : 'border-transparent text-text-muted'
                }`}
              >
                {tab.label}
              </button>
            ))}
          </div>
        </div>

        {/* Main content: showtimes (~70%) + information (~30%) */}
        <div className="flex flex-col gap-10 lg:flex-row lg:items-start lg:gap-8">
          <div ref={showtimesRef} className="flex flex-col gap-4 scroll-mt-24 lg:flex-1">
            <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
              {/* Cinema formats (2D/3D/IMAX) only mean something for movies —
                  every other category's shows still carry the same enrichShow
                  placeholder field, so showing it for a cricket match or a
                  concert would be actively wrong, not just incomplete. */}
              {summary.category === 'MOVIE' && (
                <div className="flex gap-2.5 overflow-x-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
                  <button
                    onClick={() => setFormat(null)}
                    className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer ${format === null ? 'bg-accent text-obsidian' : 'border border-border bg-surface text-text-secondary'}`}
                  >
                    All Formats
                  </button>
                  {availableFormats.map((f) => (
                    <button
                      key={f}
                      onClick={() => setFormat(f)}
                      className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer ${format === f ? 'bg-accent text-obsidian' : 'border border-border bg-surface text-text-secondary'}`}
                    >
                      {f}
                    </button>
                  ))}
                </div>
              )}

              {allDates.length > 0 && (
                <div className="flex gap-2.5 overflow-x-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
                  {allDates.map((iso) => {
                    const key = formatDateKey(iso)
                    const { weekday, day, month } = formatDayLabel(iso)
                    const selected = selectedDate === key
                    return (
                      <button
                        key={key}
                        onClick={() => setSelectedDate(key)}
                        className={`flex min-w-[56px] flex-shrink-0 flex-col items-center gap-0.5 rounded-xl px-4 py-2.5 cursor-pointer transition-transform duration-150 ${
                          selected ? 'scale-[1.04] bg-accent text-obsidian' : 'border border-border bg-surface text-text-primary hover:border-gold/40'
                        }`}
                      >
                        <span className={`text-[10.5px] font-semibold ${selected ? 'text-obsidian/70' : 'text-text-muted'}`}>{weekday}</span>
                        <span className="font-display text-[17px] font-extrabold">{day}</span>
                        <span className={`text-[9.5px] font-semibold tracking-wide ${selected ? 'text-obsidian/70' : 'text-text-muted'}`}>{month}</span>
                      </button>
                    )
                  })}
                </div>
              )}
            </div>

            <div className="flex flex-col gap-4 pt-2">
              {venueGroups.length === 0 && (
                <div className="py-16 text-center text-sm text-text-secondary">No showtimes match this filter.</div>
              )}
              {venueGroups.map((group) => (
                <div key={`${group.venueName}-${group.venueCity}`} className="flex flex-col gap-4 rounded-2xl border border-border bg-surface p-[22px_24px] transition-colors duration-200 hover:border-gold/40">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="font-display text-base font-bold">{group.venueName}</div>
                      <div className="mt-0.5 text-[12.5px] text-text-secondary">{group.venueCity}</div>
                    </div>
                    <div className="flex items-center gap-1">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="var(--color-gold)"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
                      <span className="font-variant-numeric-tabular text-[12.5px] font-semibold">{group.venueRating.toFixed(1)}</span>
                    </div>
                  </div>
                  <div className="flex flex-wrap gap-3">
                    {group.shows.map((show) => {
                      const started = isStarted(show.startTime)
                      return (
                        <button
                          key={show.id}
                          disabled={started || show.availability === 'housefull'}
                          onClick={() => navigate(`/events/${summary.id}/seats?showId=${show.id}`)}
                          className={`rounded-lg px-3.5 py-2 text-[12.5px] font-bold font-variant-numeric-tabular cursor-pointer ${
                            started ? 'bg-surface-raised text-text-muted border border-border-muted cursor-not-allowed' : STATUS_PILL[show.availability]
                          }`}
                          title={started ? 'This show has already started — choose another showtime.' : `${show.format} · ₹${show.basePrice}`}
                        >
                          {started ? 'Started' : (
                            <>
                              {formatTime(show.startTime)} <span className="opacity-70">· {show.format}</span>
                              {SHOW_LABEL[show.availability] && <span className="ml-1 opacity-70">· {SHOW_LABEL[show.availability]}</span>}
                            </>
                          )}
                        </button>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Information panel */}
          <div className="flex flex-col gap-8 lg:w-[320px] lg:flex-shrink-0">
            <div ref={aboutRef} className="flex flex-col gap-5 scroll-mt-24">
              <h2 className="font-display text-base font-bold">About</h2>
              <p className="text-sm leading-relaxed text-text-secondary">{summary.description}</p>

              {castCrew && (
                <div className="flex flex-col gap-4">
                  <div className="flex flex-wrap gap-6">
                    <div className="flex flex-col gap-1">
                      <span className="text-[11px] font-semibold uppercase tracking-wide text-text-muted">Language</span>
                      <span className="text-sm font-semibold">{castCrew.language}</span>
                    </div>
                    <div className="flex flex-col gap-1">
                      <span className="text-[11px] font-semibold uppercase tracking-wide text-text-muted">Director</span>
                      <span className="text-sm font-semibold">{castCrew.director}</span>
                    </div>
                  </div>
                  <div className="flex flex-col gap-2.5">
                    <span className="text-[11px] font-semibold uppercase tracking-wide text-text-muted">Cast</span>
                    <div className="flex flex-wrap gap-2">
                      {castCrew.cast.map((name) => (
                        <span key={name} className="rounded-full border border-border bg-surface px-3.5 py-1.5 text-[12.5px] font-medium">
                          {name}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </div>

            <div ref={galleryRef} className="flex flex-col gap-4 scroll-mt-24">
              <h2 className="font-display text-base font-bold">Gallery</h2>
              <div className="flex gap-2.5">
                {galleryImages.map((img, i) => (
                  <button
                    key={img.src}
                    onClick={() => setGalleryIndex(i)}
                    className="h-20 w-20 flex-shrink-0 cursor-pointer overflow-hidden rounded-lg border border-border"
                  >
                    <img src={img.src} alt={img.alt} className="h-full w-full object-cover transition-transform duration-200 hover:scale-105" />
                  </button>
                ))}
              </div>
              <button
                onClick={() => setGalleryIndex(0)}
                className="w-fit cursor-pointer text-[12.5px] font-semibold text-gold hover:underline"
              >
                View All →
              </button>
            </div>
          </div>
        </div>

        <div ref={reviewsRef} className="flex flex-col items-center gap-2 py-16 text-center scroll-mt-24">
          <h2 className="font-display text-base font-bold">No reviews yet</h2>
          <p className="max-w-sm text-sm text-text-secondary">Reviews aren't live yet — check back after you've watched {summary.title}.</p>
        </div>
      </div>

      {/* Mobile sticky booking CTA */}
      <div className="fixed inset-x-0 bottom-0 z-30 flex items-center justify-between gap-3 border-t border-divider bg-surface/95 px-4 py-3 backdrop-blur-sm lg:hidden">
        <div className="flex flex-col">
          <span className="text-[10px] font-semibold uppercase tracking-wide text-text-muted">From</span>
          <span className="font-display text-lg font-extrabold">
            {nextBookableShow ? `₹${nextBookableShow.basePrice}` : '—'}
          </span>
        </div>
        <button
          onClick={() => scrollToTab('showtimes')}
          disabled={!nextBookableShow}
          className="flex-1 cursor-pointer rounded-xl bg-accent px-6 py-3 text-center text-sm font-bold text-obsidian shadow-[0_10px_28px_rgba(245,166,35,0.4)] disabled:cursor-not-allowed disabled:opacity-40"
        >
          Book Tickets
        </button>
      </div>

      {galleryIndex !== null && (
        <GalleryLightbox images={galleryImages} index={galleryIndex} onClose={() => setGalleryIndex(null)} onNavigate={setGalleryIndex} />
      )}
    </div>
  )
}
