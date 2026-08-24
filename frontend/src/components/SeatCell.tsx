import { HOLD_TTL_MINUTES } from '../api/bookings'
import type { SeatResponse, SeatType } from '../types/seat'

interface SeatCellProps {
  seat: SeatResponse
  selected: boolean
  locking: boolean
  onClick: () => void
}

const TIER_BORDER: Record<SeatType, string> = {
  VIP: '#F5A62366',
  PREMIUM: '#FFC85788',
  REGULAR: '#77777766',
}

/**
 * Approximate only — event-service's lockedAt is a best-effort mirror of
 * booking-service's real Redis lock TTL, not the source of truth for it.
 * Rounds up so it never reads "0m" while genuinely still held.
 */
function approxUnlockLabel(lockedAt: string): string {
  const expiresAt = new Date(lockedAt).getTime() + HOLD_TTL_MINUTES * 60_000
  const remainingMs = expiresAt - Date.now()
  if (remainingMs <= 0) return 'any moment'
  const minutes = Math.ceil(remainingMs / 60_000)
  return minutes <= 1 ? '<1m' : `~${minutes}m`
}

export function SeatCell({ seat, selected, locking, onClick }: SeatCellProps) {
  const label = `${seat.rowLabel}${seat.seatNumber}`
  const isBooked = seat.status === 'BOOKED'
  const isLockedByOther = seat.status === 'LOCKED' && !selected
  const disabled = isBooked || isLockedByOther || locking
  const unlockLabel = isLockedByOther && seat.lockedAt ? approxUnlockLabel(seat.lockedAt) : null

  let style: string
  if (selected) {
    style = locking
      ? 'bg-accent/50 border-accent text-obsidian animate-pulse'
      : 'bg-accent border-accent text-obsidian shadow-[0_0_0_3px_rgba(245,166,35,0.28)]'
  } else if (isBooked) {
    style = 'bg-surface-sunken border-border-muted text-text-muted cursor-not-allowed'
  } else if (isLockedByOther) {
    style = 'bg-danger/10 border-danger/35 text-danger cursor-not-allowed'
  } else {
    style = 'bg-transparent text-text-secondary hover:bg-surface-raised cursor-pointer'
  }

  const title = unlockLabel
    ? `${label} · Held by another user — unlocks in ${unlockLabel}`
    : `${label} · ${seat.seatType} · ₹${seat.price}`

  return (
    <button
      type="button"
      disabled={disabled}
      onClick={onClick}
      title={title}
      style={{ borderColor: selected || isBooked || isLockedByOther ? undefined : TIER_BORDER[seat.seatType] }}
      className={`flex h-[26px] w-[26px] flex-shrink-0 items-center justify-center rounded-md border-[1.5px] font-semibold font-variant-numeric-tabular transition-colors ${unlockLabel ? 'text-[8px] leading-none' : 'text-[10px]'} ${style}`}
    >
      {isBooked ? '' : unlockLabel ?? seat.seatNumber}
    </button>
  )
}
