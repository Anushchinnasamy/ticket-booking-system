import { Outlet, useLocation } from 'react-router-dom'
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'
import { Header } from '../components/Header'
import { Footer } from '../components/Footer'
import { useSmoothScroll } from '../hooks/useSmoothScroll'

export function MainLayout() {
  const location = useLocation()
  const prefersReducedMotion = useReducedMotion()
  useSmoothScroll()

  return (
    <div className="flex min-h-screen flex-col bg-bg text-text-primary">
      <Header />
      {/* mode="wait" — "sync" let exiting route trees pile up unremoved on rapid
          navigation (their intervals/effects kept running in the background).
          Costs the shared-element crossfade its overlap-morph (now a plain
          fade), but that's a fair trade for not leaking mounted pages. */}
      <AnimatePresence mode="wait" initial={false}>
        <motion.div
          key={location.pathname}
          className="flex-1"
          initial={{ opacity: 0, y: prefersReducedMotion ? 0 : 12 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.38, ease: 'easeOut' }}
        >
          <Outlet />
        </motion.div>
      </AnimatePresence>
      <Footer />
    </div>
  )
}
