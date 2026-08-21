import { useEffect, useState } from 'react'
import { useLocation, useParams, Link } from 'react-router-dom'
import { motion, useReducedMotion } from 'framer-motion'
import { waitForTicketReady, downloadCombinedTicketPdf, createCombinedShareLink, TicketError } from '../api/tickets'
import { addMyBookingRecord } from '../api/myBookingsStore'

interface ConfirmationSeat {
  bookingId: string
  label: string
  price: number
}

interface ConfirmationState {
  seats: ConfirmationSeat[]
  showId: string
  eventId?: string
  eventTitle?: string
  venueName?: string
  startTime?: string
  total: number
}

type TicketGroupState = {
  ready: boolean
  checking: boolean
  shareUrl?: string
  error?: string
  busyAction?: 'view' | 'download' | 'share' | null
}

function formatShowtime(iso?: string) {
  if (!iso) return ''
  return new Date(iso).toLocaleString('en-US', { weekday: 'short', day: 'numeric', month: 'short', hour: 'numeric', minute: '2-digit' })
}

export function Confirmation() {
  const { bookingId } = useParams<{ bookingId: string }>()
  const location = useLocation()
  const state = location.state as ConfirmationState | null
  const prefersReducedMotion = useReducedMotion()

  const seats: ConfirmationSeat[] = state?.seats ?? (bookingId ? [{ bookingId, label: '—', price: 0 }] : [])
  const bookingIds = seats.map((s) => s.bookingId)

  // One ticket group covering every seat in this booking — not a separate
  // ticket per seat — so there's a single ready/error/share state for the
  // whole checkout rather than one per seat.
  const [ticket, setTicket] = useState<TicketGroupState>({ ready: false, checking: true })

  useEffect(() => {
    Promise.all(bookingIds.map((id) => waitForTicketReady(id))).then((results) => {
      setTicket((prev) => ({ ...prev, ready: results.every(Boolean), checking: false }))
    })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  // record for My Bookings — booking-service has no "list mine" endpoint,
  // so this is the only place a booking gets remembered at all
  useEffect(() => {
    if (!state) return
    for (const seat of state.seats) {
      addMyBookingRecord({
        bookingId: seat.bookingId,
        eventId: state.eventId ?? '',
        eventTitle: state.eventTitle ?? 'Event',
        venueName: state.venueName ?? '',
        startTime: state.startTime ?? new Date().toISOString(),
        seatLabel: seat.label,
        price: seat.price,
        createdAt: new Date().toISOString(),
      })
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  async function handleView() {
    setTicket((prev) => ({ ...prev, busyAction: 'view', error: undefined }))
    try {
      const url = ticket.shareUrl ?? (await createCombinedShareLink(bookingIds))
      setTicket((prev) => ({ ...prev, shareUrl: url, busyAction: null }))
      window.open(url, '_blank', 'noopener,noreferrer')
    } catch (err) {
      setTicket((prev) => ({ ...prev, busyAction: null, error: err instanceof TicketError ? err.message : 'Could not open your ticket.' }))
    }
  }

  async function handleDownload() {
    setTicket((prev) => ({ ...prev, busyAction: 'download', error: undefined }))
    try {
      await downloadCombinedTicketPdf(bookingIds)
      setTicket((prev) => ({ ...prev, busyAction: null }))
    } catch (err) {
      setTicket((prev) => ({ ...prev, busyAction: null, error: err instanceof TicketError ? err.message : 'Could not download your ticket.' }))
    }
  }

  async function handleShare() {
    setTicket((prev) => ({ ...prev, busyAction: 'share', error: undefined }))
    try {
      const url = ticket.shareUrl ?? (await createCombinedShareLink(bookingIds))
      setTicket((prev) => ({ ...prev, shareUrl: url, busyAction: null }))

      const seatSummary = `${seats.length} seat${seats.length === 1 ? '' : 's'} (${seats.map((s) => s.label).join(', ')})`
      if (navigator.share) {
        await navigator.share({ title: state?.eventTitle ?? 'My tickets', text: seatSummary, url })
      } else {
        await navigator.clipboard.writeText(url)
        setTicket((prev) => ({ ...prev, error: 'Link copied to clipboard.' }))
      }
    } catch (err) {
      if (err instanceof Error && err.name === 'AbortError') return // user dismissed the native share sheet
      setTicket((prev) => ({ ...prev, busyAction: null, error: err instanceof TicketError ? err.message : 'Could not share your tickets.' }))
    }
  }

  if (seats.length === 0) {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center gap-3 text-center">
        <div className="font-display text-lg font-bold">No booking to show</div>
        <Link to="/" className="mt-2 rounded-xl bg-accent px-6 py-3 text-sm font-semibold cursor-pointer">Back to Home</Link>
      </div>
    )
  }

  return (
    <div className="flex flex-col items-center gap-10 px-6 py-14">
      <div className="flex flex-col items-center gap-3">
        <motion.svg
          width="56" height="56" viewBox="0 0 56 56"
          initial={{ scale: prefersReducedMotion ? 1 : 0.7, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.4, ease: [0.2, 0.9, 0.3, 1.2] }}
        >
          <circle cx="28" cy="28" r="26" fill="rgba(46,204,113,0.12)" stroke="#2ECC71" strokeWidth="2" />
          <motion.path
            d="M17 29l7 7 15-16" fill="none" stroke="#2ECC71" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round"
            initial={{ pathLength: prefersReducedMotion ? 1 : 0 }}
            animate={{ pathLength: 1 }}
            transition={{ duration: 0.35, delay: 0.3, ease: 'easeOut' }}
          />
        </motion.svg>
        <div className="font-display text-2xl font-extrabold tracking-tight">Booking Confirmed!</div>
        {state?.eventTitle && (
          <div className="text-[13px] text-text-secondary">
            {state.eventTitle} &middot; {state.venueName} &middot; {formatShowtime(state.startTime)}
          </div>
        )}
      </div>

      <div className="flex w-full max-w-[720px] flex-col gap-5">
        <div style={{ perspective: 1400 }}>
          <motion.div
            initial={{ rotateY: prefersReducedMotion ? 0 : 90, opacity: 0 }}
            animate={{ rotateY: 0, opacity: 1 }}
            transition={{ duration: 0.6, ease: [0.22, 0.85, 0.25, 1] }}
            style={{ transformStyle: 'preserve-3d' }}
            className="flex flex-col gap-4 rounded-2xl bg-surface p-6 shadow-[0_20px_50px_-16px_rgba(0,0,0,0.6)] sm:flex-row sm:items-center sm:justify-between"
          >
            <div className="flex flex-col gap-1.5">
              <div className="flex items-center gap-2">
                <span className="font-display text-lg font-bold">
                  {seats.length} Seat{seats.length === 1 ? '' : 's'} &middot; {seats.map((s) => s.label).join(', ')}
                </span>
                <span className="rounded-full bg-accent-dim px-2.5 py-1 text-[10.5px] font-bold text-gold">CONFIRMED</span>
              </div>
              <div className="text-xs text-text-secondary">One e-ticket covers all {seats.length} seat{seats.length === 1 ? '' : 's'} on this booking.</div>
              {ticket.error && <div className="text-xs text-danger">{ticket.error}</div>}
            </div>

            <div className="flex items-center gap-2.5">
              {ticket.checking ? (
                <div className="flex items-center gap-2 text-xs text-text-secondary">
                  <div className="h-3.5 w-3.5 animate-spin rounded-full border-2 border-gold/40 border-t-gold" />
                  Preparing your ticket…
                </div>
              ) : (
                <>
                  <ActionButton label="View E-Ticket" busy={ticket.busyAction === 'view'} onClick={handleView} />
                  <ActionButton label="Download PDF" busy={ticket.busyAction === 'download'} onClick={handleDownload} secondary />
                  <ActionButton label="Share" busy={ticket.busyAction === 'share'} onClick={handleShare} secondary icon="share" />
                </>
              )}
            </div>
          </motion.div>
        </div>
      </div>

      <div className="flex gap-4">
        <Link to="/my-bookings" className="rounded-xl border border-border bg-surface px-6 py-3 text-sm font-semibold cursor-pointer">
          View My Bookings
        </Link>
        <Link to="/" className="rounded-xl bg-accent px-6 py-3 text-sm font-semibold cursor-pointer">
          Explore More Shows
        </Link>
      </div>
    </div>
  )
}

function ActionButton({ label, onClick, busy, secondary, icon }: { label: string; onClick: () => void; busy?: boolean; secondary?: boolean; icon?: 'share' }) {
  return (
    <button
      onClick={onClick}
      disabled={busy}
      className={`flex items-center gap-1.5 rounded-lg px-4 py-2.5 text-xs font-semibold disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer ${
        secondary ? 'border border-border bg-surface-raised text-text-primary' : 'bg-accent text-text-primary'
      }`}
    >
      {icon === 'share' && (
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
          <circle cx="18" cy="5" r="3" /><circle cx="6" cy="12" r="3" /><circle cx="18" cy="19" r="3" />
          <path d="M8.6 10.5l6.8-4M8.6 13.5l6.8 4" />
        </svg>
      )}
      {busy ? '…' : label}
    </button>
  )
}
