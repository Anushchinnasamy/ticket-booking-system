import { useEffect, useRef, useState } from 'react'
import { fetchCities } from '../api/events'
import { setCity } from '../api/cityStore'
import { useCity } from '../hooks/useCity'

export function CityPicker() {
  const city = useCity()
  const [open, setOpen] = useState(false)
  const [cities, setCities] = useState<string[]>([])
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (open && cities.length === 0) fetchCities().then(setCities)
  }, [open, cities.length])

  useEffect(() => {
    if (!open) return
    function onClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener('mousedown', onClickOutside)
    return () => document.removeEventListener('mousedown', onClickOutside)
  }, [open])

  return (
    <div ref={ref} className="relative hidden sm:block">
      <button
        onClick={() => setOpen((v) => !v)}
        className="flex cursor-pointer items-center gap-1.5"
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 21s-7-6.1-7-11.5A7 7 0 0 1 19 9.5C19 14.9 12 21 12 21z" />
          <circle cx="12" cy="9.5" r="2.3" />
        </svg>
        <span className="text-sm font-semibold">{city}</span>
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-secondary)" strokeWidth={2.4} strokeLinecap="round" strokeLinejoin="round" className={`transition-transform ${open ? 'rotate-180' : ''}`}>
          <path d="M6 9l6 6 6-6" />
        </svg>
      </button>

      {open && (
        <div
          role="listbox"
          className="absolute right-0 top-full z-20 mt-2 w-44 overflow-hidden rounded-xl border border-border bg-surface-raised py-1.5 shadow-[0_12px_32px_rgba(0,0,0,0.35)]"
        >
          {cities.length === 0 ? (
            <div className="px-4 py-2.5 text-xs text-text-secondary">Loading…</div>
          ) : (
            cities.map((c) => (
              <button
                key={c}
                role="option"
                aria-selected={c === city}
                onClick={() => {
                  setCity(c)
                  setOpen(false)
                }}
                className={`block w-full cursor-pointer px-4 py-2 text-left text-[13.5px] font-medium transition-colors hover:bg-surface ${c === city ? 'text-accent' : 'text-text-primary'}`}
              >
                {c}
              </button>
            ))
          )}
        </div>
      )}
    </div>
  )
}
