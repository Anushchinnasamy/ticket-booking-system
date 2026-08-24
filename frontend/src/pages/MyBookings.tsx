import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { motion, useReducedMotion } from 'framer-motion'
import { fetchMyBookings, type EnrichedMyBooking } from '../api/myBookings'
import { pickPoster } from '../api/enrichEvent'

const STATUS_META: Record<string, { label: string; badge: string; icon: 'check' | 'clock' | 'x' }> = {
  PENDING: { label: 'Pending', badge: 'bg-accent-dim text-gold', icon: 'clock' },
  CONFIRMED: { label: 'Confirmed', badge: 'bg-success/15 text-success', icon: 'check' },
  CHECKED_IN: { label: 'Checked In', badge: 'bg-accent-dim text-gold', icon: 'check' },
  CANCELLED: { label: 'Cancelled', badge: 'bg-danger/15 text-danger', icon: 'x' },
}

function formatShowtime(iso: string) {
  return new Date(iso).toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'short' }) + ' · ' + new Date(iso).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })
}

function relativeLabel(iso: string): string {
  const diffMs = new Date(iso).getTime() - Date.now()
  const days = Math.round(diffMs / 86_400_000)
  if (days === 0) return 'Today'
  if (days === 1) return 'Tomorrow'
  if (days === -1) return 'Yesterday'
  if (days > 1) return `In ${days} days`
  return `${Math.abs(days)} days ago`
}

export function MyBookings() {
  const [bookings, setBookings] = useState<EnrichedMyBooking[] | null>(null)
  const [tab, setTab] = useState<'upcoming' | 'past'>('upcoming')
  const prefersReducedMotion = useReducedMotion()

  useEffect(() => {
    fetchMyBookings().then(setBookings)
  }, [])

  const now = Date.now()
  const upcoming = (bookings ?? []).filter((b) => new Date(b.startTime).getTime() >= now && b.liveStatus !== 'CANCELLED')
  const past = (bookings ?? []).filter((b) => new Date(b.startTime).getTime() < now || b.liveStatus === 'CANCELLED')
  const list = tab === 'upcoming' ? upcoming : past

  const confirmedCount = (bookings ?? []).filter((b) => (b.liveStatus ?? 'CONFIRMED') !== 'CANCELLED').length
  const totalSpent = (bookings ?? []).reduce((sum, b) => sum + (b.liveStatus === 'CANCELLED' ? 0 : b.price), 0)

  return (
    <div className="flex flex-col gap-8 px-4 pb-20 pt-8 sm:px-6 lg:max-w-[980px] lg:px-[90px]">
      <div className="flex flex-col gap-1">
        <div className="font-display text-[28px] font-extrabold tracking-tight sm:text-[34px]">My Bookings</div>
        <p className="text-sm text-text-secondary">Every seat you've held, confirmed, or watched — in one place.</p>
      </div>

      {bookings !== null && bookings.length > 0 && (
        <div className="grid grid-cols-3 gap-3 sm:gap-4">
          <StatTile value={String(confirmedCount)} label="Tickets booked" />
          <StatTile value={String(upcoming.length)} label="Upcoming shows" />
          <StatTile value={`₹${totalSpent.toLocaleString('en-IN')}`} label="Total spent" />
        </div>
      )}

      <div className="flex gap-2.5">
        <button
          onClick={() => setTab('upcoming')}
          className={`rounded-full px-5 py-2.5 text-sm font-semibold cursor-pointer ${tab === 'upcoming' ? 'bg-accent text-obsidian' : 'border border-border bg-surface text-text-secondary'}`}
        >
          Upcoming ({upcoming.length})
        </button>
        <button
          onClick={() => setTab('past')}
          className={`rounded-full px-5 py-2.5 text-sm font-semibold cursor-pointer ${tab === 'past' ? 'bg-accent text-obsidian' : 'border border-border bg-surface text-text-secondary'}`}
        >
          Past ({past.length})
        </button>
      </div>

      {bookings === null ? (
        <div className="flex flex-col gap-4">
          {[0, 1].map((i) => <div key={i} className="h-[168px] animate-pulse rounded-3xl bg-surface" />)}
        </div>
      ) : list.length === 0 ? (
        <div className="flex flex-col items-center gap-3 py-20 text-center">
          <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="var(--color-cinema-muted-gray)" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round">
            <path d="M3 10a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v1.5a1.5 1.5 0 0 0 0 3V16a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-1.5a1.5 1.5 0 0 0 0-3z" />
            <path d="M9 8v10" strokeDasharray="2.5 3" />
          </svg>
          <div className="font-display text-lg font-bold">
            {tab === 'upcoming' ? 'No upcoming bookings' : 'No past bookings'}
          </div>
          <p className="max-w-xs text-sm text-text-secondary">Explore what's playing near you and book your first show in seconds.</p>
          <Link to="/" className="mt-2 rounded-xl bg-accent px-6 py-3 text-sm font-semibold text-obsidian cursor-pointer">Explore Shows</Link>
        </div>
      ) : (
        <div className="flex flex-col gap-5">
          {list.map((b, i) => {
            const status = b.liveStatus ?? 'CONFIRMED'
            const meta = STATUS_META[status] ?? STATUS_META.CONFIRMED
            const poster = pickPoster(b.eventId || b.bookingId, b.eventTitle)
            return (
              <motion.div
                key={b.bookingId}
                initial={{ opacity: 0, y: prefersReducedMotion ? 0 : 22 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.45, delay: prefersReducedMotion ? 0 : i * 0.06, ease: [0.22, 0.85, 0.25, 1] }}
              >
                <Link
                  to={`/bookings/${b.bookingId}/confirmation`}
                  state={{ seats: [{ bookingId: b.bookingId, label: b.seatLabel, price: b.price }], showId: '', eventId: b.eventId, eventTitle: b.eventTitle, venueName: b.venueName, startTime: b.startTime, total: b.price }}
                  className="group relative flex overflow-hidden rounded-3xl bg-surface shadow-[0_18px_40px_-22px_rgba(0,0,0,0.55)] transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_28px_56px_-20px_rgba(0,0,0,0.65)]"
                >
                  {/* Poster panel */}
                  <div className="relative h-auto w-[100px] flex-shrink-0 overflow-hidden sm:w-[140px]">
                    <img
                      src={poster}
                      alt={b.eventTitle}
                      className="absolute inset-0 h-full w-full object-cover transition-transform duration-500 group-hover:scale-110"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/50 via-black/5 to-transparent" />
                    <div className={`absolute left-2.5 top-2.5 flex items-center gap-1 rounded-full px-2 py-1 text-[9px] font-bold uppercase tracking-wide ${meta.badge}`}>
                      <StatusIcon icon={meta.icon} />
                      {meta.label}
                    </div>
                  </div>

                  {/* Perforated ticket divider */}
                  <div className="relative hidden w-0 flex-shrink-0 sm:block">
                    <div className="absolute inset-y-3 left-0 border-l-2 border-dashed border-bg" />
                    <div className="absolute -left-2.5 -top-2.5 h-5 w-5 rounded-full bg-bg" />
                    <div className="absolute -bottom-2.5 -left-2.5 h-5 w-5 rounded-full bg-bg" />
                  </div>

                  {/* Details */}
                  <div className="flex min-w-0 flex-1 flex-col justify-between gap-3 p-4 sm:p-5">
                    <div className="flex flex-col gap-1.5">
                      <div className="flex flex-wrap items-center justify-between gap-2">
                        <span className="truncate font-display text-lg font-extrabold tracking-tight sm:text-xl">{b.eventTitle}</span>
                        <span className="flex-shrink-0 text-xs font-semibold text-text-secondary">{relativeLabel(b.startTime)}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-[13px] text-text-secondary">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0">
                          <path d="M12 21s-7-6.1-7-11.5A7 7 0 0 1 19 9.5C19 14.9 12 21 12 21z" /><circle cx="12" cy="9.5" r="2.3" />
                        </svg>
                        <span className="truncate">{b.venueName}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-[13px] text-text-secondary">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0">
                          <rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 10h18M8 3v4M16 3v4" />
                        </svg>
                        {formatShowtime(b.startTime)}
                      </div>
                    </div>

                    <div className="flex items-end justify-between gap-3 border-t border-divider pt-3">
                      <div className="flex items-center gap-4">
                        <div className="flex flex-col">
                          <span className="text-[10px] font-semibold uppercase tracking-wide text-text-muted">Seat</span>
                          <span className="font-display text-base font-bold font-variant-numeric-tabular">{b.seatLabel}</span>
                        </div>
                        <div className="flex flex-col">
                          <span className="text-[10px] font-semibold uppercase tracking-wide text-text-muted">Paid</span>
                          <span className="font-display text-base font-bold font-variant-numeric-tabular">₹{b.price}</span>
                        </div>
                      </div>
                      <span className="flex-shrink-0 rounded-lg bg-surface-raised px-3 py-2 text-xs font-semibold text-text-primary opacity-0 transition-opacity group-hover:opacity-100">
                        View Ticket →
                      </span>
                    </div>
                    {b.liveStatus === null && <div className="text-[10.5px] text-text-muted">Couldn't verify current status — showing last known.</div>}
                  </div>
                </Link>
              </motion.div>
            )
          })}
        </div>
      )}
    </div>
  )
}

function StatTile({ value, label }: { value: string; label: string }) {
  return (
    <div className="flex flex-col items-center gap-1 rounded-2xl bg-surface py-4 text-center sm:py-5">
      <span className="font-display text-xl font-extrabold tracking-tight sm:text-2xl">{value}</span>
      <span className="text-[10.5px] font-semibold uppercase tracking-wide text-text-secondary sm:text-[11px]">{label}</span>
    </div>
  )
}

function StatusIcon({ icon }: { icon: 'check' | 'clock' | 'x' }) {
  if (icon === 'check') {
    return <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3.5} strokeLinecap="round" strokeLinejoin="round"><path d="M20 6L9 17l-5-5" /></svg>
  }
  if (icon === 'x') {
    return <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3.5} strokeLinecap="round" strokeLinejoin="round"><path d="M18 6L6 18M6 6l12 12" /></svg>
  }
  return <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 3" /></svg>
}
