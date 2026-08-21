import { useEffect, useMemo, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { motion } from 'framer-motion'
import { fetchEventDetail, type FetchEventDetailResult } from '../api/eventDetail'
import { getCastCrew } from '../api/castCrew'
import type { EnrichedShow, ShowFormat } from '../types/show'

type DetailTab = 'about' | 'showtimes' | 'reviews'

const STATUS_PILL: Record<EnrichedShow['availability'], string> = {
  available: 'bg-success/12 text-success border border-success/35',
  'filling-fast': 'bg-accent-dim text-gold border border-gold/30',
  housefull: 'bg-surface-raised text-text-muted border border-border-muted cursor-not-allowed',
}

function formatDateKey(iso: string) {
  return new Date(iso).toDateString()
}

function formatDayLabel(iso: string) {
  const d = new Date(iso)
  return { weekday: d.toLocaleDateString('en-US', { weekday: 'short' }).toUpperCase(), day: d.getDate() }
}

function formatTime(iso: string) {
  return new Date(iso).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })
}

function isStarted(iso: string) {
  return new Date(iso).getTime() <= Date.now()
}

export function EventDetail() {
  const { eventId } = useParams<{ eventId: string }>()
  const navigate = useNavigate()
  const [result, setResult] = useState<FetchEventDetailResult | null | undefined>(undefined)
  const [format, setFormat] = useState<ShowFormat | null>(null)
  const [selectedDate, setSelectedDate] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState<DetailTab>('showtimes')

  useEffect(() => {
    if (!eventId) return
    setResult(undefined)
    fetchEventDetail(eventId).then(setResult)
  }, [eventId])

  const dates = useMemo(() => {
    if (!result) return []
    const seen = new Map<string, string>()
    for (const show of result.detail.shows) {
      const key = formatDateKey(show.startTime)
      if (!seen.has(key)) seen.set(key, show.startTime)
    }
    return [...seen.values()].sort()
  }, [result])

  useEffect(() => {
    if (dates.length > 0 && !selectedDate) setSelectedDate(formatDateKey(dates[0]))
  }, [dates, selectedDate])

  const filteredShows = useMemo(() => {
    if (!result) return []
    return result.detail.shows.filter((show) => {
      const matchesDate = !selectedDate || formatDateKey(show.startTime) === selectedDate
      const matchesFormat = !format || show.format === format
      return matchesDate && matchesFormat
    })
  }, [result, selectedDate, format])

  const bookableShow = useMemo(() => filteredShows.find((s) => !isStarted(s.startTime)), [filteredShows])

  const venueGroups = useMemo(() => {
    const groups = new Map<string, { venueName: string; venueCity: string; venueRating: number; shows: EnrichedShow[] }>()
    for (const show of filteredShows) {
      const key = `${show.venueName}__${show.venueCity}`
      if (!groups.has(key)) groups.set(key, { venueName: show.venueName, venueCity: show.venueCity, venueRating: show.venueRating, shows: [] })
      groups.get(key)!.shows.push(show)
    }
    return [...groups.values()]
  }, [filteredShows])

  if (result === undefined) {
    return (
      <div className="flex flex-col gap-6 px-4 sm:px-6 lg:px-[90px] py-10">
        <div className="h-[380px] w-full animate-pulse rounded-3xl bg-surface" />
        <div className="h-8 w-64 animate-pulse rounded bg-surface" />
      </div>
    )
  }

  if (result === null) {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center gap-3 text-center">
        <div className="font-display text-xl font-bold">Event not found</div>
        <button onClick={() => navigate('/')} className="mt-2 rounded-xl bg-accent px-6 py-3 text-sm font-semibold cursor-pointer">
          Back to Home
        </button>
      </div>
    )
  }

  const { summary, isFallback } = result
  const castCrew = getCastCrew(summary.title)

  return (
    <div className="flex flex-col pb-20">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing sample showtimes — couldn't reach the event catalog API.
        </div>
      )}

      <div className="relative h-[300px] w-full sm:h-[340px] lg:h-[380px]">
        {/* Clipped to the hero box on its own — the poster+title block below
            deliberately overflows past this boundary (bleeds into the page
            content section) and must NOT share this overflow-hidden, or its
            bottom gets sliced off. */}
        <div className="absolute inset-0 overflow-hidden">
          <img src={summary.posterUrl} alt="" className="absolute inset-0 h-full w-full object-cover brightness-[0.7]" />
          <div className="absolute inset-0 bg-gradient-to-b from-bg/15 via-bg/55 to-bg" />
        </div>

        <div className="absolute bottom-[-56px] left-4 flex items-end gap-4 sm:bottom-[-64px] sm:left-6 sm:gap-7 lg:left-[90px]">
          <motion.img
            layoutId={`poster-${summary.id}`}
            src={summary.posterUrl}
            alt={summary.title}
            className="h-[130px] w-[88px] flex-shrink-0 rounded-xl border-[3px] border-bg object-cover shadow-[0_20px_50px_-10px_rgba(0,0,0,0.7)] sm:h-[246px] sm:w-[164px] sm:rounded-2xl"
          />
          <div className="flex flex-col gap-1.5 pb-1 sm:gap-2.5 sm:pb-2">
            <div className="flex flex-wrap items-center gap-2 sm:gap-2.5">
              <span className={`rounded-md px-2 py-1 text-[10px] font-bold sm:px-2.5 sm:py-1.5 sm:text-[11px] ${STATUS_PILL[summary.status]}`}>
                {summary.status.replace('-', ' ').toUpperCase()}
              </span>
              <div className="flex items-center gap-1">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="#F5C518"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
                <span className="font-variant-numeric-tabular text-xs font-bold sm:text-[13px]">{summary.rating.toFixed(1)}</span>
                <span className="text-[11px] text-text-secondary sm:text-xs">({summary.bookedCount} booked)</span>
              </div>
            </div>
            <div className="font-display text-xl font-extrabold tracking-tight sm:text-2xl lg:text-4xl">{summary.title}</div>
            <div className="text-xs text-text-secondary sm:text-sm">{summary.category}</div>
          </div>
        </div>

        <button
          onClick={() => bookableShow && navigate(`/events/${summary.id}/seats?showId=${bookableShow.id}`)}
          disabled={!bookableShow}
          className="absolute bottom-3 right-4 rounded-xl bg-accent px-4 py-2.5 text-xs font-bold shadow-[0_10px_28px_rgba(226,55,68,0.4)] disabled:cursor-not-allowed disabled:opacity-40 cursor-pointer sm:bottom-6 sm:right-6 sm:px-[34px] sm:py-3.5 sm:text-[15px] lg:right-[90px]"
        >
          Book Tickets
        </button>
      </div>

      <div className="mt-[76px] flex flex-col gap-6 px-4 sm:mt-[88px] sm:px-6 lg:px-[90px]">
        <div className="flex items-center justify-between overflow-x-auto border-b border-divider pb-1 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          <div className="flex gap-6 sm:gap-9">
            {([
              { key: 'about', label: 'About' },
              { key: 'showtimes', label: 'Showtimes' },
              { key: 'reviews', label: 'Reviews' },
            ] as { key: DetailTab; label: string }[]).map((tab) => (
              <button
                key={tab.key}
                onClick={() => setActiveTab(tab.key)}
                className={`cursor-pointer border-b-2 pb-3.5 font-display text-[15px] font-bold ${
                  activeTab === tab.key ? 'border-accent text-text-primary' : 'border-transparent text-text-muted'
                }`}
              >
                {tab.label}
              </button>
            ))}
          </div>
        </div>

        {activeTab === 'about' && (
          <div className="flex flex-col gap-7 pb-4">
            <p className="max-w-2xl text-sm leading-relaxed text-text-secondary">{summary.description}</p>

            {castCrew && (
              <div className="flex flex-col gap-4">
                <div className="font-display text-base font-bold">Cast &amp; Crew</div>
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
        )}

        {activeTab === 'showtimes' && (
          <>
            <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
              <div className="flex gap-2.5 overflow-x-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
                <button
                  onClick={() => setFormat(null)}
                  className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer ${format === null ? 'bg-accent' : 'border border-border bg-surface text-text-secondary'}`}
                >
                  All Formats
                </button>
                {(['2D', '3D', 'IMAX'] as ShowFormat[]).map((f) => (
                  <button
                    key={f}
                    onClick={() => setFormat(f)}
                    className={`flex-shrink-0 rounded-full px-5 py-2.5 text-[13px] font-semibold cursor-pointer ${format === f ? 'bg-accent' : 'border border-border bg-surface text-text-secondary'}`}
                  >
                    {f}
                  </button>
                ))}
              </div>

              {dates.length > 0 && (
                <div className="flex gap-2.5 overflow-x-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
                  {dates.map((iso) => {
                    const key = formatDateKey(iso)
                    const { weekday, day } = formatDayLabel(iso)
                    return (
                      <button
                        key={key}
                        onClick={() => setSelectedDate(key)}
                        className={`flex min-w-[56px] flex-shrink-0 flex-col items-center gap-0.5 rounded-xl px-4 py-2.5 cursor-pointer ${selectedDate === key ? 'bg-accent' : 'border border-border bg-surface'}`}
                      >
                        <span className={`text-[10.5px] font-semibold ${selectedDate === key ? 'text-white/75' : 'text-text-muted'}`}>{weekday}</span>
                        <span className="font-display text-[17px] font-extrabold">{day}</span>
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
                <div key={`${group.venueName}-${group.venueCity}`} className="flex flex-col gap-4 rounded-2xl bg-surface p-[22px_24px]">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="font-display text-base font-bold">{group.venueName}</div>
                      <div className="mt-0.5 text-[12.5px] text-text-secondary">{group.venueCity}</div>
                    </div>
                    <div className="flex items-center gap-1">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="#F5C518"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
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
                            </>
                          )}
                        </button>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>
          </>
        )}

        {activeTab === 'reviews' && (
          <div className="flex flex-col items-center gap-2 py-16 text-center">
            <div className="font-display text-base font-bold">No reviews yet</div>
            <p className="max-w-sm text-sm text-text-secondary">Reviews aren't live yet — check back after you've watched {summary.title}.</p>
          </div>
        )}
      </div>
    </div>
  )
}
