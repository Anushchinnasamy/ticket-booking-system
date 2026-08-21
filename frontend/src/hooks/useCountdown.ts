import { useEffect, useState } from 'react'

export interface CountdownState {
  label: string | null
  remainingMs: number | null
  expired: boolean
  pulsing: boolean
}

/** Ticks once a second toward `expiresAt`. Pass null when there's nothing being held. */
export function useCountdown(expiresAt: Date | null): CountdownState {
  const [now, setNow] = useState(() => Date.now())

  useEffect(() => {
    if (!expiresAt) return
    setNow(Date.now()) // the initial state can be stale by the time expiresAt first arrives
    const id = setInterval(() => setNow(Date.now()), 1000)
    return () => clearInterval(id)
  }, [expiresAt])

  if (!expiresAt) {
    return { label: null, remainingMs: null, expired: false, pulsing: false }
  }

  const remainingMs = Math.max(0, expiresAt.getTime() - now)
  const totalSeconds = Math.ceil(remainingMs / 1000)
  const mm = Math.floor(totalSeconds / 60)
  const ss = totalSeconds % 60
  const label = `${String(mm).padStart(2, '0')}:${String(ss).padStart(2, '0')}`

  return { label, remainingMs, expired: remainingMs <= 0, pulsing: remainingMs > 0 && remainingMs <= 60_000 }
}
