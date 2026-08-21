import { Outlet, useLocation } from 'react-router-dom'
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'
import { Header } from '../components/Header'

export function MainLayout() {
  const location = useLocation()
  const prefersReducedMotion = useReducedMotion()

  return (
    <div className="min-h-screen bg-bg text-text-primary">
      <Header />
      {/* mode="wait" — "sync" let exiting route trees pile up unremoved on rapid
          navigation (their intervals/effects kept running in the background).
          Costs the shared-element crossfade its overlap-morph (now a plain
          fade), but that's a fair trade for not leaking mounted pages. */}
      <AnimatePresence mode="wait" initial={false}>
        <motion.div
          key={location.pathname}
          initial={{ opacity: 0, y: prefersReducedMotion ? 0 : 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.22, ease: 'easeOut' }}
        >
          <Outlet />
        </motion.div>
      </AnimatePresence>
    </div>
  )
}
