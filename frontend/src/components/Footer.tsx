import { Link, useNavigate } from 'react-router-dom'
import { clearAuth, isAuthenticated as checkIsAuthenticated } from '../api/authStore'
import type { EventCategory } from '../types/event'

const EXPLORE_LINKS: { label: string; to: string; category?: EventCategory }[] = [
  { label: 'Movies', to: '/search', category: 'MOVIE' },
  { label: 'Events', to: '/search', category: 'CONCERT' },
  { label: 'Sports', to: '/search', category: 'SPORTS' },
  { label: 'Plays', to: '/plays' },
  { label: 'Live', to: '/live' },
]

// Purely visual — this app has no real social presence, so these are
// decorative brand marks (no href, no click behavior) rather than links to
// somewhere that doesn't exist.
const SOCIAL_ICONS: { label: string; path: string }[] = [
  { label: 'Instagram', path: 'M7 2h10a5 5 0 0 1 5 5v10a5 5 0 0 1-5 5H7a5 5 0 0 1-5-5V7a5 5 0 0 1 5-5zm5 5.5a4.5 4.5 0 1 0 0 9 4.5 4.5 0 0 0 0-9zm0 2a2.5 2.5 0 1 1 0 5 2.5 2.5 0 0 1 0-5zM17.4 6a1 1 0 1 0 0 2 1 1 0 0 0 0-2z' },
  { label: 'X', path: 'M4 4l16 16M20 4L4 20' },
  { label: 'Facebook', path: 'M14 9h3V6h-3a4 4 0 0 0-4 4v2H8v3h2v6h3v-6h3l1-3h-4v-2a1 1 0 0 1 1-1z' },
  { label: 'YouTube', path: 'M22 12s0-3.4-.4-5a2.5 2.5 0 0 0-1.8-1.8C18.1 4.8 12 4.8 12 4.8s-6.1 0-7.8.4A2.5 2.5 0 0 0 2.4 7C2 8.6 2 12 2 12s0 3.4.4 5a2.5 2.5 0 0 0 1.8 1.8c1.7.4 7.8.4 7.8.4s6.1 0 7.8-.4a2.5 2.5 0 0 0 1.8-1.8c.4-1.6.4-5 .4-5zM10 15.2V8.8L15.5 12z' },
]

export function Footer() {
  const navigate = useNavigate()
  const isAuthenticated = checkIsAuthenticated()

  function handleLogOut() {
    clearAuth()
    navigate('/')
  }

  return (
    <footer className="relative border-t border-gold/25 bg-surface">
      <div className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-gold/60 to-transparent" />

      <div className="mx-auto flex max-w-[1400px] flex-col gap-10 px-4 py-14 sm:px-6 sm:py-16 lg:flex-row lg:justify-between lg:px-[90px]">
        <div className="max-w-sm">
          <Link to="/" className="flex items-center gap-2">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="5" width="18" height="14" rx="2" />
              <path d="M9 9l6 3-6 3z" fill="var(--color-gold)" stroke="none" />
            </svg>
            <span className="font-display text-lg font-bold tracking-tight">TickIT</span>
          </Link>
          <p className="mt-4 text-[13.5px] leading-relaxed text-text-secondary">
            Experience cinema like never before. Book tickets, watch trailers, live the movie magic.
          </p>

          <div className="mt-6 flex items-center gap-3">
            {SOCIAL_ICONS.map((s) => (
              <span
                key={s.label}
                aria-label={s.label}
                title={s.label}
                className="flex h-9 w-9 items-center justify-center rounded-full border border-border text-text-muted transition-colors hover:border-gold/50 hover:text-gold"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} strokeLinecap="round" strokeLinejoin="round">
                  <path d={s.path} />
                </svg>
              </span>
            ))}
          </div>
        </div>

        <div className="flex flex-wrap gap-10 sm:gap-16">
          <div>
            <h3 className="font-display text-xs font-bold uppercase tracking-[0.14em] text-text-muted">Explore</h3>
            <ul className="mt-4 flex flex-col gap-3">
              {EXPLORE_LINKS.map((link) => (
                <li key={link.label}>
                  <button
                    onClick={() => navigate(link.to, link.category ? { state: { category: link.category } } : undefined)}
                    className="cursor-pointer text-[13.5px] text-text-soft transition-colors hover:text-gold"
                  >
                    {link.label}
                  </button>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h3 className="font-display text-xs font-bold uppercase tracking-[0.14em] text-text-muted">Account</h3>
            <ul className="mt-4 flex flex-col gap-3">
              <li>
                <Link to="/my-bookings" className="text-[13.5px] text-text-soft transition-colors hover:text-gold">
                  My Bookings
                </Link>
              </li>
              {isAuthenticated && (
                <li>
                  <button
                    onClick={handleLogOut}
                    className="cursor-pointer text-[13.5px] text-text-soft transition-colors hover:text-gold"
                  >
                    Log Out
                  </button>
                </li>
              )}
            </ul>
          </div>
        </div>
      </div>

      <div className="border-t border-divider bg-surface-sunken px-4 py-6 text-center text-[12px] text-text-muted sm:px-6 lg:px-[90px]">
        © {new Date().getFullYear()} TickIT. All rights reserved.
      </div>
    </footer>
  )
}
