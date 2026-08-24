import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'
import slideConcerts from '../../assets/auth/login-slide-concerts.png'
import slideSports from '../../assets/auth/login-slide-sports.png'
import slideMovies from '../../assets/auth/login-slide-movies.png'
import slideEvents from '../../assets/auth/login-slide-events.png'

const SLIDES = [
  {
    image: slideConcerts,
    eyebrow: 'Live Moments. Lasting Memories.',
    heading: ['Your Stage is', 'Waiting.'],
    copy: 'Book tickets to the best concerts, events and experiences around you.',
  },
  {
    image: slideSports,
    eyebrow: 'Feel Every Moment.',
    heading: ['The Game is', 'Calling.'],
    copy: 'Courtside seats and sold-out stadiums — never miss the finish.',
  },
  {
    image: slideMovies,
    eyebrow: 'Every Story. One Experience.',
    heading: ['Your Next Movie', 'Awaits.'],
    copy: 'From premiere night to the classics, on the big screen.',
  },
  {
    image: slideEvents,
    eyebrow: 'Make It Unforgettable.',
    heading: ['Your Next', 'Adventure Awaits.'],
    copy: 'Plays, festivals and experiences worth the front row.',
  },
]

const FEATURES = [
  {
    title: 'Exclusive Events',
    desc: 'Access the hottest events before anyone else.',
    icon: (
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v2a2 2 0 0 0 0 4v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2a2 2 0 0 0 0-4z" />
      </svg>
    ),
  },
  {
    title: 'Secure Booking',
    desc: '100% secure payments and instant confirmation.',
    icon: (
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 2 4 5v6c0 5 3.5 8.5 8 11 4.5-2.5 8-6 8-11V5z" />
      </svg>
    ),
  },
  {
    title: '24/7 Support',
    desc: "We're here to help you anytime, anywhere.",
    icon: (
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 18v-6a9 9 0 0 1 18 0v6" /><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
      </svg>
    ),
  },
]

function BrandMark() {
  return (
    <Link to="/" className="flex items-center gap-2">
      <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="5" width="18" height="14" rx="2" />
        <path d="M9 9l6 3-6 3z" fill="var(--color-gold)" stroke="none" />
      </svg>
      <span className="font-display text-lg font-bold tracking-tight text-text-primary">TickIT</span>
    </Link>
  )
}

/**
 * Cinematic login backdrop — a fixed, full-viewport crossfading image (so it fills the
 * whole screen behind both the hero copy and the login card, not just a split panel) with
 * the brand/copy/features layered on top for large screens.
 */
export function LoginHero() {
  const [slide, setSlide] = useState(0)
  const prefersReducedMotion = useReducedMotion()

  useEffect(() => {
    if (prefersReducedMotion) return
    const id = setInterval(() => setSlide((s) => (s + 1) % SLIDES.length), 6000)
    return () => clearInterval(id)
  }, [prefersReducedMotion])

  const active = SLIDES[slide]

  return (
    <>
      {/* Full-bleed cinematic background, fixed behind the entire page */}
      <div className="fixed inset-0 -z-10 overflow-hidden bg-obsidian">
        <AnimatePresence>
          <motion.img
            key={slide}
            src={active.image}
            alt=""
            aria-hidden
            className="absolute inset-0 h-full w-full object-cover"
            initial={prefersReducedMotion ? undefined : { opacity: 0, scale: 1 }}
            animate={prefersReducedMotion ? undefined : { opacity: 1, scale: 1.04 }}
            exit={prefersReducedMotion ? undefined : { opacity: 0 }}
            transition={{ opacity: { duration: 1 }, scale: { duration: 6, ease: 'linear' } }}
          />
        </AnimatePresence>
        <div className="absolute inset-0 bg-gradient-to-t from-obsidian via-obsidian/60 to-obsidian/25" />
        <div className="absolute inset-0 bg-gradient-to-r from-obsidian/85 via-obsidian/45 to-obsidian/55" />
        <div
          className="absolute inset-0 opacity-60"
          style={{ background: 'radial-gradient(ellipse 60% 45% at 15% 85%, rgba(245,166,35,0.16), transparent 70%)' }}
        />
        <div
          className="absolute inset-0 opacity-50"
          style={{ background: 'radial-gradient(ellipse 55% 40% at 90% 15%, rgba(109,60,255,0.14), transparent 70%)' }}
        />
      </div>

      {/* Mobile: compact brand bar */}
      <div className="relative z-10 flex justify-center py-6 lg:hidden">
        <BrandMark />
      </div>

      {/* Desktop: hero copy + features over the shared background */}
      <div className="relative z-10 hidden w-[56%] flex-shrink-0 lg:block">
        <div className="absolute left-12 top-10">
          <BrandMark />
        </div>

        <div className="absolute inset-x-12 bottom-14 max-w-[480px]">
          <AnimatePresence mode="wait">
            <motion.div
              key={slide}
              initial={prefersReducedMotion ? undefined : { opacity: 0, y: 14 }}
              animate={{ opacity: 1, y: 0 }}
              exit={prefersReducedMotion ? undefined : { opacity: 0, y: -10 }}
              transition={{ duration: 0.6, ease: 'easeOut' }}
            >
              <span className="text-xs font-bold uppercase tracking-[0.2em] text-gold">★ {active.eyebrow}</span>
              <h1 className="mt-3 font-display text-[44px] font-bold leading-[1.08] tracking-tight text-text-primary">
                {active.heading[0]}
                <br />
                <span className="text-gold">{active.heading[1]}</span>
              </h1>
              <p className="mt-3 max-w-sm text-[14.5px] leading-relaxed text-text-soft">{active.copy}</p>
            </motion.div>
          </AnimatePresence>

          <div className="mt-8 flex flex-col gap-2.5">
            {FEATURES.map((f) => (
              <div
                key={f.title}
                className="flex items-center gap-3 rounded-[14px] border border-white/[0.06] bg-white/[0.035] px-4 py-3 backdrop-blur-md"
              >
                <div className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-accent-dim text-gold">{f.icon}</div>
                <div>
                  <div className="text-[13px] font-semibold text-text-primary">{f.title}</div>
                  <div className="text-[12px] text-text-soft">{f.desc}</div>
                </div>
              </div>
            ))}
          </div>

          <div className="mt-8 flex items-center gap-4">
            <span className="text-[11px] text-text-muted">© TickIT</span>
            <div className="flex items-center gap-1.5">
              {SLIDES.map((_, i) => (
                <button
                  key={i}
                  onClick={() => setSlide(i)}
                  aria-label={`Show slide ${i + 1}`}
                  className={`h-1.5 cursor-pointer rounded-full transition-all ${i === slide ? 'w-5 bg-gold' : 'w-1.5 bg-white/25'}`}
                />
              ))}
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
