import { useEffect, useRef } from 'react'
import { useLocation } from 'react-router-dom'
import Lenis from 'lenis'

// Desktop-feel smooth scrolling (plan section 32: "Lenis — smooth desktop
// scrolling"). Skipped entirely under prefers-reduced-motion rather than
// just tuned down, per section 34. Elements that need real native wheel
// behavior (the 3D seat auditorium's OrbitControls zoom/pan) opt out via the
// `data-lenis-prevent` attribute, which Lenis honors automatically.
export function useSmoothScroll() {
  const lenisRef = useRef<Lenis | null>(null)
  const location = useLocation()

  useEffect(() => {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

    const lenis = new Lenis({ duration: 1.1, smoothWheel: true })
    lenisRef.current = lenis

    let rafId: number
    function raf(time: number) {
      lenis.raf(time)
      rafId = requestAnimationFrame(raf)
    }
    rafId = requestAnimationFrame(raf)

    return () => {
      cancelAnimationFrame(rafId)
      lenis.destroy()
      lenisRef.current = null
    }
  }, [])

  // React Router doesn't reset scroll position on push navigation. Once Lenis
  // owns the scroll it has its own animated-position state, so a raw
  // window.scrollTo would desync from it — route through Lenis when it's
  // active, otherwise (reduced motion) fall back to the native scrollTo so
  // the reset itself isn't the thing that regresses under reduced motion.
  useEffect(() => {
    if (lenisRef.current) lenisRef.current.scrollTo(0, { immediate: true })
    else window.scrollTo(0, 0)
  }, [location.pathname])
}
