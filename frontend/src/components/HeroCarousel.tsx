import { useEffect, useState } from 'react'
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import type { EnrichedEvent } from '../types/event'

interface HeroCarouselProps {
  slides: EnrichedEvent[]
}

const AUTO_ADVANCE_MS = 5000

// Trending can surface any category (see Home.tsx), not just movies — this
// used to hardcode "In cinemas now" under every slide, which was wrong the
// moment a concert or sports fixture showed up here.
const CATEGORY_TAGLINE: Record<EnrichedEvent['category'], string> = {
  MOVIE: 'In cinemas now',
  CONCERT: 'Live in concert',
  SPORTS: 'Live sporting event',
  COMEDY: 'Live comedy show',
}

export function HeroCarousel({ slides }: HeroCarouselProps) {
  const [index, setIndex] = useState(0)
  const prefersReducedMotion = useReducedMotion()
  const navigate = useNavigate()

  // slides is a fresh array every time the catalog is refetched (new city,
  // new category) — reset to the first slide whenever the actual lineup
  // changes so a stale index from a longer previous list can't point past
  // the end of a shorter new one and crash the render.
  const slidesKey = slides.map((s) => s.id).join(',')
  useEffect(() => {
    setIndex(0)
  }, [slidesKey])

  useEffect(() => {
    if (slides.length < 2) return
    const timer = setInterval(() => setIndex((i) => (i + 1) % slides.length), AUTO_ADVANCE_MS)
    return () => clearInterval(timer)
  }, [slides.length])

  if (slides.length === 0) return null
  const slide = slides[index] ?? slides[0]

  return (
    <div className="relative h-[260px] w-full overflow-hidden rounded-2xl sm:h-[320px] lg:h-[420px] lg:rounded-[22px] bg-[#160b28]">
      <AnimatePresence mode="sync">
        <motion.div
          key={slide.id}
          initial={{ opacity: 0, scale: prefersReducedMotion ? 1 : 1 }}
          animate={{ opacity: 1, scale: prefersReducedMotion ? 1 : 1.08 }}
          exit={{ opacity: 0 }}
          transition={{ opacity: { duration: 0.6 }, scale: { duration: AUTO_ADVANCE_MS / 1000, ease: 'linear' } }}
          className="absolute inset-0"
        >
          <img src={slide.posterUrl} alt={slide.title} className="h-full w-full object-cover" />
        </motion.div>
      </AnimatePresence>

      <div className="absolute inset-0 bg-gradient-to-r from-black/75 via-black/25 to-transparent" />

      <div className="absolute bottom-8 left-5 max-w-[calc(100%-40px)] sm:bottom-10 sm:left-8 sm:max-w-[420px] lg:bottom-14 lg:left-16 lg:max-w-[520px]">
        <span className="mb-2.5 inline-block rounded-full bg-accent-dim px-3 py-1.5 text-[10px] font-bold tracking-wider text-gold sm:mb-4 sm:text-[11px]">
          TRENDING NOW
        </span>
        <div className="font-display text-[22px] font-extrabold leading-[1.1] tracking-tight sm:text-[32px] lg:text-[44px] lg:leading-[1.05]">{slide.title}</div>
        <div className="mt-2 text-[13px] text-text-soft sm:mt-3 sm:text-[15px]">{slide.category} &middot; {CATEGORY_TAGLINE[slide.category]}</div>
        <button
          onClick={() => navigate(`/events/${slide.id}`)}
          className="mt-3.5 rounded-[10px] bg-accent px-5 py-2.5 text-[13px] font-semibold text-obsidian shadow-[0_8px_24px_rgba(226,55,68,0.35)] cursor-pointer sm:mt-6 sm:px-[30px] sm:py-3 sm:text-sm"
        >
          Book Tickets
        </button>
      </div>

      {slides.length > 1 && (
        <>
          <button
            aria-label="Previous slide"
            onClick={() => setIndex((i) => (i - 1 + slides.length) % slides.length)}
            className="absolute left-6 top-1/2 flex h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full border border-white/15 bg-bg/55 cursor-pointer"
          >
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-primary)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round"><path d="M15 18l-6-6 6-6" /></svg>
          </button>
          <button
            aria-label="Next slide"
            onClick={() => setIndex((i) => (i + 1) % slides.length)}
            className="absolute right-6 top-1/2 flex h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full border border-white/15 bg-bg/55 cursor-pointer"
          >
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-primary)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round"><path d="M9 18l6-6-6-6" /></svg>
          </button>

          <div className="absolute bottom-3.5 left-5 flex gap-1.5 sm:left-8 lg:bottom-6 lg:left-16">
            {slides.map((s, i) => (
              <button
                key={s.id}
                aria-label={`Go to slide ${i + 1}`}
                onClick={() => setIndex(i)}
                className={`h-1 rounded-full transition-all duration-300 cursor-pointer ${i === index ? 'w-4.5 bg-accent' : 'w-1 bg-white/35'}`}
              />
            ))}
          </div>
        </>
      )}
    </div>
  )
}
