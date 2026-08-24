import { useLayoutEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import gsap from 'gsap'
import heroBackdrop from '../assets/hero-home.png'

interface CinematicHeroProps {
  loading: boolean
}

export function CinematicHero({ loading }: CinematicHeroProps) {
  const navigate = useNavigate()
  const eyebrowRef = useRef<HTMLSpanElement>(null)
  const line1Ref = useRef<HTMLSpanElement>(null)
  const line2Ref = useRef<HTMLSpanElement>(null)
  const copyRef = useRef<HTMLParagraphElement>(null)
  const ctaRef = useRef<HTMLButtonElement>(null)
  const bgRef = useRef<HTMLDivElement>(null)
  const imgRef = useRef<HTMLImageElement>(null)
  const sweepRef = useRef<HTMLDivElement>(null)

  // Entrance choreography runs exactly once per mount.
  useLayoutEffect(() => {
    const targets = [eyebrowRef.current, line1Ref.current, line2Ref.current, copyRef.current, ctaRef.current, bgRef.current, imgRef.current, sweepRef.current]
    if (targets.some((t) => !t)) return

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      gsap.set(targets, { clearProps: 'all' })
      return
    }

    gsap.set([eyebrowRef.current, copyRef.current], { opacity: 0, y: 16 })
    gsap.set([line1Ref.current, line2Ref.current], { clipPath: 'inset(0% 0 100% 0)', y: 12 })
    gsap.set(ctaRef.current, { opacity: 0, scale: 0.92 })
    gsap.set(bgRef.current, { opacity: 0 })
    gsap.set(imgRef.current, { scale: 1.12 })
    gsap.set(sweepRef.current, { xPercent: -130, opacity: 0 })

    const tl = gsap.timeline({ defaults: { ease: 'power3.out' } })
    tl.to(bgRef.current, { opacity: 1, duration: 1.2, ease: 'power2.out' })
      .to(sweepRef.current, { opacity: 0.4, duration: 0.15 }, 0.25)
      .to(sweepRef.current, { xPercent: 130, opacity: 0, duration: 0.9, ease: 'power1.inOut' }, 0.25)
      .to(eyebrowRef.current, { opacity: 1, y: 0, duration: 0.5 }, 0.15)
      .to([line1Ref.current, line2Ref.current], { clipPath: 'inset(0% 0 0% 0)', y: 0, duration: 0.7, stagger: 0.12 }, 0.35)
      .to(copyRef.current, { opacity: 1, y: 0, duration: 0.5 }, 0.75)
      .to(ctaRef.current, { opacity: 1, scale: 1, duration: 0.4 }, 0.9)
      // Slow continuous Ken Burns drift — settles in right where the entrance
      // zoom (1.12 -> 1.06) leaves off, so the two tweens read as one motion.
      .to(imgRef.current, { scale: 1.06, duration: 1.4, ease: 'power2.out' }, 0)

    const driftTl = gsap.timeline({ delay: 1.4, repeat: -1, yoyo: true, defaults: { ease: 'sine.inOut' } })
    driftTl.to(imgRef.current, { scale: 1.12, duration: 14 })

    return () => {
      tl.kill()
      driftTl.kill()
    }
  }, [])

  return (
    <div className="relative overflow-hidden">
      <div ref={bgRef} className="absolute inset-0">
        <img ref={imgRef} src={heroBackdrop} alt="" aria-hidden className="h-full w-full object-cover brightness-125 saturate-[1.15]" />
        <div ref={sweepRef} className="pointer-events-none absolute inset-y-0 left-0 w-1/3 -skew-x-12 bg-gradient-to-r from-transparent via-white/25 to-transparent" />
        <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/50 to-transparent" />
        <div className="absolute inset-0 bg-gradient-to-r from-bg via-bg/25 to-transparent" />
      </div>

      <div className="relative flex flex-col gap-4 px-4 pb-14 pt-16 sm:px-6 sm:pb-20 sm:pt-24 lg:px-[90px] lg:pb-28 lg:pt-32">
        <span ref={eyebrowRef} className="text-[11px] font-bold uppercase tracking-[0.22em] text-gold sm:text-xs">
          Premium Cinema Experience
        </span>
        <h1 className="font-display text-[34px] font-bold leading-[1.05] tracking-tight sm:text-[52px] lg:text-[68px]">
          <span ref={line1Ref} className="block overflow-hidden">Experience Cinema</span>
          <span ref={line2Ref} className="block overflow-hidden">Like Never Before</span>
        </h1>
        <p ref={copyRef} className="max-w-md text-[15px] leading-relaxed text-text-secondary sm:text-base">
          Book tickets. Watch trailers. Live the movie magic.
        </p>
        <button
          ref={ctaRef}
          onClick={() => navigate('/search', { state: { category: 'MOVIE' } })}
          disabled={loading}
          className="mt-2 w-fit cursor-pointer rounded-xl bg-accent px-7 py-3.5 text-sm font-semibold text-obsidian shadow-[0_8px_24px_rgba(245,166,35,0.35)] transition-transform hover:brightness-110 active:scale-[0.97]"
        >
          Browse Movies
        </button>
      </div>
    </div>
  )
}
