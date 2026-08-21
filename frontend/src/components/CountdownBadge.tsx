import type { CountdownState } from '../hooks/useCountdown'

export function CountdownBadge({ countdown }: { countdown: CountdownState }) {
  if (!countdown.label) return null

  return (
    <div className={`flex items-center justify-center gap-2 rounded-xl bg-accent-dim p-3.5 ${countdown.pulsing ? 'animate-pulse-glow' : ''}`}>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#F5C518" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="13" r="8" />
        <path d="M12 9v4l3 2" />
        <path d="M9 2h6" />
      </svg>
      <span className="font-variant-numeric-tabular text-[15px] font-bold text-gold">
        Seats held — {countdown.label}
      </span>
    </div>
  )
}
