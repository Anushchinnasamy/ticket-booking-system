import { Link } from 'react-router-dom'
import poster1 from '../assets/posters/poster-1.jpg'
import poster2 from '../assets/posters/poster-2.jpg'
import poster3 from '../assets/posters/poster-3.jpg'
import poster4 from '../assets/posters/poster-4.jpg'
import poster5 from '../assets/posters/poster-5.jpg'
import poster6 from '../assets/posters/poster-6.jpg'
import poster7 from '../assets/posters/poster-7.jpg'
import poster8 from '../assets/posters/poster-8.jpg'
import poster9 from '../assets/posters/poster-9.jpg'
import poster10 from '../assets/posters/poster-10.jpg'

const POSTERS = [poster1, poster2, poster3, poster4, poster5, poster6, poster7, poster8, poster9, poster10, poster2, poster5, poster8, poster3, poster6]

// Mobile ordering per plan section 22 ("brand → form → cinematic accent") —
// the full poster collage below is desktop-only, so mobile gets a compact
// brand bar up top and a thin poster strip as a closing accent.
export function PosterCollagePanel() {
  return (
    <>
      <div className="flex items-center justify-center gap-2 border-b border-divider py-5 lg:hidden">
        <Link to="/" className="flex items-center gap-2">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="5" width="18" height="14" rx="2" />
            <path d="M9 9l6 3-6 3z" fill="var(--color-gold)" stroke="none" />
          </svg>
          <span className="font-display text-lg font-bold tracking-tight text-text-primary">TickIT</span>
        </Link>
      </div>

      <div className="relative hidden w-[640px] flex-shrink-0 overflow-hidden bg-bg lg:block">
        <div
          className="absolute inset-0 grid gap-2.5 p-2.5"
          style={{ gridTemplateColumns: 'repeat(3, 1fr)', gridTemplateRows: 'repeat(5, 1fr)', transform: 'scale(1.08) rotate(-2deg)' }}
        >
          {POSTERS.map((src, i) => (
            <div key={i} className="overflow-hidden rounded-[10px]">
              <img src={src} alt="" className="h-full w-full object-cover" />
            </div>
          ))}
        </div>
        <div className="absolute inset-0 bg-gradient-to-b from-bg/55 via-bg/35 to-bg" />

        <Link to="/" className="absolute left-12 top-10 flex items-center gap-2">
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="5" width="18" height="14" rx="2" />
            <path d="M9 9l6 3-6 3z" fill="var(--color-gold)" stroke="none" />
          </svg>
          <span className="font-display text-lg font-bold tracking-tight text-text-primary">TickIT</span>
        </Link>

        <div className="absolute bottom-14 left-12 max-w-[460px]">
          <div className="font-display text-[30px] font-bold leading-[1.2] tracking-tight text-text-primary">Your seat is waiting.</div>
          <div className="mt-2.5 text-sm text-text-soft">Movies, concerts, and live shows — booked in seconds, no queues.</div>
        </div>
      </div>
    </>
  )
}

/** Thin poster strip closing accent — mobile-only, placed after the form. */
export function MobileAuthAccent() {
  return (
    <div className="relative flex h-20 gap-1.5 overflow-hidden lg:hidden">
      {POSTERS.slice(0, 6).map((src, i) => (
        <div key={i} className="h-full flex-1 overflow-hidden">
          <img src={src} alt="" className="h-full w-full object-cover" />
        </div>
      ))}
      <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/40 to-bg/10" />
    </div>
  )
}
