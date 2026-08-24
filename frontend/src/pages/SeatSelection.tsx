import { lazy, Suspense, useEffect, useMemo, useRef, useState } from 'react'
import { useLocation, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { useReducedMotion } from 'framer-motion'
import { fetchSeatMap } from '../api/seats'
import { lockSeat, SeatConflictError, AuthRequiredError, HOLD_TTL_MINUTES } from '../api/bookings'
import { useCountdown } from '../hooks/useCountdown'
import { SeatCell } from '../components/SeatCell'
import { CountdownBadge } from '../components/CountdownBadge'
import type { BookingResponse, SeatMapResponse, SeatResponse, SeatType } from '../types/seat'

// Three.js/R3F only loads when someone actually opens the 3D view — keeps it
// off every other page's bundle per the plan's "don't mount Three.js on every
// page" guardrail.
const SeatAuditorium3D = lazy(() => import('../components/seat3d/SeatAuditorium3D'))

const POLL_INTERVAL_MS = 4000

const TIER_INFO: Record<SeatType, { name: string; border: string }> = {
  VIP: { name: 'VIP', border: '#F5A623' },
  PREMIUM: { name: 'Premium', border: '#FFC857' },
  REGULAR: { name: 'Regular', border: '#777777' },
}

function formatTime(iso: string) {
  return new Date(iso).toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })
}
function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'short' })
}

export function SeatSelection() {
  const { eventId } = useParams<{ eventId: string }>()
  const [searchParams] = useSearchParams()
  const showId = searchParams.get('showId')
  const navigate = useNavigate()
  const location = useLocation()

  const [seatMap, setSeatMap] = useState<SeatMapResponse | null>(null)
  const [loading, setLoading] = useState(true)
  const [isFallback, setIsFallback] = useState(false)
  const [myBookings, setMyBookings] = useState<Map<string, BookingResponse>>(new Map())
  const [lockingSeatIds, setLockingSeatIds] = useState<Set<string>>(new Set())
  const [toast, setToast] = useState<string | null>(null)
  const [view3D, setView3D] = useState(false)
  // Asked up front, same idea as most booking sites' "how many tickets" step —
  // caps how many seats can be held so a stray tap can't run away with an
  // oversized cart. Adjustable at any time, just never below what's already selected.
  const [seatCountConfirmed, setSeatCountConfirmed] = useState(false)
  const [desiredSeatCount, setDesiredSeatCount] = useState(2)
  const prefersReducedMotion = useReducedMotion()

  const myBookingsRef = useRef(myBookings)
  myBookingsRef.current = myBookings

  useEffect(() => {
    if (!showId) return
    let cancelled = false

    async function load() {
      const result = await fetchSeatMap(showId!)
      if (cancelled) return

      // a seat I hold that now polls back AVAILABLE means the server-side
      // 5-minute hold lapsed (there's no push notification for this — polling
      // is how we find out)
      const stillHeld = new Set(
        result.seatMap.seats.filter((s) => s.status !== 'AVAILABLE').map((s) => s.id)
      )
      const expiredIds = [...myBookingsRef.current.keys()].filter((id) => !stillHeld.has(id))
      if (expiredIds.length > 0) {
        setMyBookings((prev) => {
          const next = new Map(prev)
          for (const id of expiredIds) next.delete(id)
          return next
        })
        setToast('One of your held seats expired and was released.')
      }

      setSeatMap(result.seatMap)
      setIsFallback(result.isFallback)
      setLoading(false)
    }

    load()
    const interval = setInterval(load, POLL_INTERVAL_MS)
    return () => {
      cancelled = true
      clearInterval(interval)
    }
  }, [showId])

  const earliestExpiry = useMemo(() => {
    if (myBookings.size === 0) return null
    let earliest = Infinity
    for (const booking of myBookings.values()) {
      const expiry = new Date(booking.createdAt).getTime() + HOLD_TTL_MINUTES * 60_000
      if (expiry < earliest) earliest = expiry
    }
    return new Date(earliest)
  }, [myBookings])

  const countdown = useCountdown(earliestExpiry)

  useEffect(() => {
    if (countdown.expired && myBookingsRef.current.size > 0) {
      setMyBookings(new Map())
      setToast('Your held seats were released — please select again.')
    }
  }, [countdown.expired])

  useEffect(() => {
    if (!toast) return
    const timer = setTimeout(() => setToast(null), 3500)
    return () => clearTimeout(timer)
  }, [toast])

  async function handleSeatClick(seat: SeatResponse) {
    if (myBookings.has(seat.id)) {
      setMyBookings((prev) => {
        const next = new Map(prev)
        next.delete(seat.id)
        return next
      })
      return
    }
    if (seat.status !== 'AVAILABLE' || lockingSeatIds.has(seat.id) || !showId) return
    if (myBookings.size >= desiredSeatCount) {
      setToast(`You asked for ${desiredSeatCount} seat${desiredSeatCount === 1 ? '' : 's'} — deselect one, or raise the count above, to pick another.`)
      return
    }

    setLockingSeatIds((prev) => new Set(prev).add(seat.id))
    try {
      const { booking } = await lockSeat(showId, seat.id)
      setMyBookings((prev) => new Map(prev).set(seat.id, booking))
    } catch (err) {
      if (err instanceof AuthRequiredError) {
        navigate('/login', { state: { from: location } })
        return
      }
      if (err instanceof SeatConflictError) {
        // The backend now distinguishes several 409 reasons (seat taken,
        // already booked this show, show already started) — show its actual
        // message rather than assuming it's always "seat taken".
        setToast(err.message)
      } else {
        setToast('Could not hold that seat — please try again.')
      }
    } finally {
      setLockingSeatIds((prev) => {
        const next = new Set(prev)
        next.delete(seat.id)
        return next
      })
    }
  }

  const rows = useMemo(() => {
    if (!seatMap) return []
    const byRow = new Map<string, SeatResponse[]>()
    for (const seat of seatMap.seats) {
      if (!byRow.has(seat.rowLabel)) byRow.set(seat.rowLabel, [])
      byRow.get(seat.rowLabel)!.push(seat)
    }
    return [...byRow.entries()]
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([label, seats]) => [label, seats.sort((a, b) => a.seatNumber - b.seatNumber)] as const)
  }, [seatMap])

  const tiersPresent = useMemo(() => {
    if (!seatMap) return []
    const seen = new Map<SeatType, number>()
    for (const seat of seatMap.seats) {
      if (!seen.has(seat.seatType) || seat.price < seen.get(seat.seatType)!) seen.set(seat.seatType, seat.price)
    }
    return [...seen.entries()]
  }, [seatMap])

  const selectedSeats = useMemo(() => {
    if (!seatMap) return []
    return seatMap.seats.filter((s) => myBookings.has(s.id))
  }, [seatMap, myBookings])

  const selectedIdSet = useMemo(() => new Set(myBookings.keys()), [myBookings])

  const subtotal = selectedSeats.reduce((sum, s) => sum + s.price, 0)
  const fee = selectedSeats.length > 0 ? 45 : 0
  const total = subtotal + fee

  function handleProceed() {
    if (!showId || selectedSeats.length === 0) return
    navigate('/checkout/payment', {
      state: {
        eventId,
        showId,
        eventTitle: seatMap!.eventTitle,
        venueName: seatMap!.venueName,
        startTime: seatMap!.startTime,
        // paired explicitly by seat id — selectedSeats (grid order) and
        // myBookings (lock-insertion order) aren't guaranteed to line up by index
        seats: selectedSeats.map((s) => ({
          bookingId: myBookings.get(s.id)!.id,
          label: `${s.rowLabel}${s.seatNumber}`,
          price: s.price,
        })),
        total,
      },
    })
  }

  if (!showId) {
    return <div className="px-4 sm:px-6 lg:px-[90px] py-16 text-center text-sm text-text-secondary">No show selected.</div>
  }

  if (loading || !seatMap) {
    return (
      <div className="flex flex-col items-center gap-4 px-4 sm:px-6 lg:px-[90px] py-16">
        <div className="h-6 w-64 animate-pulse rounded bg-surface" />
        <div className="h-[300px] w-full max-w-[720px] animate-pulse rounded-2xl bg-surface" />
      </div>
    )
  }

  return (
    <div className="flex flex-col">
      {isFallback && (
        <div className="border-b border-divider bg-accent-dim/40 px-4 sm:px-6 lg:px-[90px] py-2.5 text-center text-xs text-gold">
          Showing a sample seat map — couldn't reach the booking API. Seat holds are simulated locally.
        </div>
      )}

      <div className="flex items-center gap-5 border-b border-divider px-4 sm:px-6 lg:px-[90px] py-5">
        <button onClick={() => navigate(-1)} className="flex items-center gap-2 text-[13px] text-text-secondary cursor-pointer">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-secondary)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round"><path d="M15 18l-6-6 6-6" /></svg>
          Back
        </button>
        <div className="h-5 w-px bg-border" />
        <div>
          <div className="font-display text-[15px] font-bold">{seatMap.eventTitle}</div>
          <div className="text-[11.5px] text-text-secondary">
            {seatMap.venueName} &middot; {formatDate(seatMap.startTime)} &middot; {formatTime(seatMap.startTime)}
          </div>
        </div>
      </div>

      {!seatCountConfirmed && (
        <div className="flex flex-col items-center gap-4 border-b border-divider bg-surface px-4 py-7 sm:px-6 lg:px-[90px]">
          <div className="text-center">
            <div className="font-display text-base font-bold">How many seats would you like to book?</div>
            <div className="mt-1 text-xs text-text-secondary">You'll be able to pick up to this many on the map below.</div>
          </div>
          <div className="flex items-center gap-5">
            <button
              onClick={() => setDesiredSeatCount((n) => Math.max(selectedSeats.length || 1, n - 1))}
              aria-label="Decrease seat count"
              className="flex h-10 w-10 items-center justify-center rounded-full border border-border bg-surface-raised text-lg font-bold cursor-pointer"
            >
              −
            </button>
            <span className="w-8 text-center font-display text-2xl font-extrabold">{desiredSeatCount}</span>
            <button
              onClick={() => setDesiredSeatCount((n) => Math.min(10, n + 1))}
              aria-label="Increase seat count"
              className="flex h-10 w-10 items-center justify-center rounded-full border border-border bg-surface-raised text-lg font-bold cursor-pointer"
            >
              +
            </button>
          </div>
          <button
            onClick={() => setSeatCountConfirmed(true)}
            className="rounded-xl bg-accent px-8 py-3 text-sm font-bold text-obsidian cursor-pointer"
          >
            Continue
          </button>
        </div>
      )}

      <div className="flex min-w-0 flex-col items-stretch gap-8 px-4 py-9 sm:px-6 lg:flex-row lg:items-start lg:gap-10 lg:px-[90px]">
        <div className="flex min-w-0 w-full flex-1 flex-col items-center gap-7">
          <div className="flex w-full flex-col items-center gap-4">
            <div className="flex flex-wrap justify-center gap-x-6 gap-y-2">
              {tiersPresent.map(([type, price]) => (
                <div key={type} className="flex items-center gap-2 text-[12.5px] font-semibold text-text-soft">
                  <div className="h-3.5 w-3.5 rounded-[4px] border-2" style={{ borderColor: TIER_INFO[type].border }} />
                  {TIER_INFO[type].name} · ₹{price}
                </div>
              ))}
            </div>
            <div className="flex flex-wrap justify-center gap-x-6 gap-y-2">
              <div className="flex items-center gap-2 text-xs text-text-secondary">
                <div className="h-[18px] w-[18px] rounded-[5px] border-[1.5px] border-[#9A9AA266]" />
                Available
              </div>
              <div className="flex items-center gap-2 text-xs text-text-secondary">
                <div className="h-[18px] w-[18px] rounded-[5px] bg-accent shadow-[0_0_10px_rgba(245,166,35,0.5)]" />
                Selected
              </div>
              <div className="flex items-center gap-2 text-xs text-text-secondary">
                <div className="h-[18px] w-[18px] rounded-[5px] border-[1.5px] border-danger/35 bg-danger/10" />
                Held by others
              </div>
              <div className="flex items-center gap-2 text-xs text-text-secondary">
                <div className="h-[18px] w-[18px] rounded-[5px] border-[1.5px] border-[#232326] bg-[#1C1C1F]" />
                Booked
              </div>
            </div>
          </div>

          <div className="flex gap-1.5 rounded-full bg-surface p-1">
            <button
              onClick={() => setView3D(false)}
              className={`rounded-full px-4 py-1.5 text-xs font-semibold cursor-pointer ${!view3D ? 'bg-accent text-obsidian' : 'text-text-secondary'}`}
            >
              2D
            </button>
            <button
              onClick={() => setView3D(true)}
              className={`rounded-full px-4 py-1.5 text-xs font-semibold cursor-pointer ${view3D ? 'bg-accent text-obsidian' : 'text-text-secondary'}`}
            >
              3D Auditorium
            </button>
          </div>

          {view3D ? (
            <Suspense
              fallback={
                <div className="flex h-[520px] w-full max-w-[720px] items-center justify-center rounded-2xl bg-surface text-sm text-text-secondary">
                  Loading 3D view…
                </div>
              }
            >
              <SeatAuditorium3D
                rows={rows}
                selectedIds={selectedIdSet}
                lockingIds={lockingSeatIds}
                onSeatClick={handleSeatClick}
                reducedMotion={!!prefersReducedMotion}
              />
            </Suspense>
          ) : (
            <>
              <svg className="w-full max-w-[480px]" height="48" viewBox="0 0 480 48" preserveAspectRatio="xMidYMid meet">
                <path d="M 8 44 Q 240 -8 472 44" stroke="var(--color-cinema-muted-gray)" strokeWidth="2" fill="none" />
              </svg>
              <div className="-mt-6 text-[11px] tracking-[0.2em] text-text-muted">SCREEN THIS WAY</div>

              <div className="flex w-full min-w-0 max-w-full flex-col gap-2.5 overflow-x-auto pt-3">
                {rows.map(([rowLabel, seats]) => {
                  const mid = Math.floor(seats.length / 2)
                  return (
                    <div key={rowLabel} className="flex items-center gap-3.5">
                      <div className="w-4 flex-shrink-0 text-center text-[11px] font-semibold text-text-muted">{rowLabel}</div>
                      <div className="flex">
                        {seats.map((seat, i) => (
                          <div key={seat.id} style={{ marginRight: i === mid - 1 ? '18px' : '4px' }}>
                            <SeatCell
                              seat={seat}
                              selected={myBookings.has(seat.id)}
                              locking={lockingSeatIds.has(seat.id)}
                              onClick={() => handleSeatClick(seat)}
                            />
                          </div>
                        ))}
                      </div>
                      <div className="w-4 flex-shrink-0 text-center text-[11px] font-semibold text-text-muted">{rowLabel}</div>
                    </div>
                  )
                })}
              </div>
            </>
          )}
        </div>

        <div className="flex w-full flex-col gap-5 rounded-2xl bg-surface p-6 lg:sticky lg:top-7 lg:w-[360px] lg:flex-shrink-0">
          <div>
            <div className="mb-2.5 flex items-center justify-between text-xs font-semibold text-text-secondary">
              <span>SELECTED SEATS ({selectedSeats.length}/{desiredSeatCount})</span>
              <button onClick={() => setSeatCountConfirmed(false)} className="font-semibold text-accent cursor-pointer">
                Change
              </button>
            </div>
            {selectedSeats.length === 0 ? (
              <div className="text-[13px] text-text-secondary">Tap an available seat to hold it.</div>
            ) : (
              <div className="flex flex-wrap gap-2">
                {selectedSeats.map((s) => (
                  <div key={s.id} className="rounded-full bg-surface-raised px-3 py-1.5 text-xs font-semibold font-variant-numeric-tabular">
                    {s.rowLabel}{s.seatNumber}
                  </div>
                ))}
              </div>
            )}
          </div>

          {selectedSeats.length > 0 && (
            <>
              <div className="h-px bg-border" />
              <div className="flex flex-col gap-2">
                <div className="flex justify-between text-[13px] text-text-secondary">
                  <span>Seats x {selectedSeats.length}</span>
                  <span className="font-variant-numeric-tabular text-text-primary">₹{subtotal}</span>
                </div>
                <div className="flex justify-between text-[13px] text-text-secondary">
                  <span>Convenience fee</span>
                  <span className="font-variant-numeric-tabular text-text-primary">₹{fee}</span>
                </div>
                <div className="mt-1 flex justify-between text-[15px] font-bold">
                  <span>Total</span>
                  <span className="font-variant-numeric-tabular">₹{total}</span>
                </div>
              </div>
            </>
          )}

          <CountdownBadge countdown={countdown} />

          <button
            onClick={handleProceed}
            disabled={selectedSeats.length === 0}
            className="rounded-xl bg-accent py-4 text-[15px] font-bold text-obsidian shadow-[0_10px_26px_rgba(245,166,35,0.35)] disabled:cursor-not-allowed disabled:bg-border-muted disabled:text-text-muted disabled:shadow-none cursor-pointer"
          >
            Proceed to Pay
          </button>
        </div>
      </div>

      {toast && (
        <div className="fixed bottom-8 left-1/2 -translate-x-1/2 rounded-xl bg-surface-raised px-5 py-3 text-sm font-medium shadow-[0_10px_30px_rgba(0,0,0,0.5)]">
          {toast}
        </div>
      )}
    </div>
  )
}
