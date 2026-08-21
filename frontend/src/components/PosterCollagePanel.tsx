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

export function PosterCollagePanel() {
  return (
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
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#E23744" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
          <rect x="3" y="5" width="18" height="14" rx="2" />
          <path d="M9 9l6 3-6 3z" fill="#E23744" stroke="none" />
        </svg>
        <span className="font-display text-lg font-extrabold tracking-tight text-text-primary">ReelRow</span>
      </Link>

      <div className="absolute bottom-14 left-12 max-w-[460px]">
        <div className="font-display text-[30px] font-extrabold leading-[1.2] tracking-tight text-text-primary">Your seat is waiting.</div>
        <div className="mt-2.5 text-sm text-text-soft">Movies, concerts, and live shows — booked in seconds, no queues.</div>
      </div>
    </div>
  )
}
