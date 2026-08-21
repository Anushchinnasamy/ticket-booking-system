import { Link, useLocation, useNavigate } from 'react-router-dom'
import { isAuthenticated as checkIsAuthenticated } from '../api/authStore'
import { CityPicker } from './CityPicker'
import { ThemeToggle } from './ThemeToggle'
import type { EventCategory } from '../types/event'

// event-service's EventCategory has no "Plays"/"Live" equivalent yet, so
// those two are honest coming-soon routes rather than a fake filter.
const NAV_LINKS: { label: string; to: string; category?: EventCategory }[] = [
  { label: 'Movies', to: '/search', category: 'MOVIE' },
  { label: 'Events', to: '/search', category: 'CONCERT' },
  { label: 'Sports', to: '/search', category: 'SPORTS' },
  { label: 'Plays', to: '/plays' },
  { label: 'Live', to: '/live' },
]

export function Header() {
  const navigate = useNavigate()
  // re-reads on every route change (e.g. right after Login redirects back),
  // which is the only time this can actually change in this app
  useLocation()
  const isAuthenticated = checkIsAuthenticated()

  return (
    <header className="flex h-[76px] items-center justify-between gap-3 border-b border-divider px-4 sm:px-6 lg:px-[90px]">
      <div className="flex items-center gap-5 lg:gap-11">
        <Link to="/" className="flex flex-shrink-0 items-center gap-2">
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#E23744" strokeWidth={2.2} strokeLinecap="round" strokeLinejoin="round">
            <rect x="3" y="5" width="18" height="14" rx="2" />
            <path d="M9 9l6 3-6 3z" fill="#E23744" stroke="none" />
          </svg>
          <span className="font-display text-lg font-extrabold tracking-tight">ReelRow</span>
        </Link>
        <nav className="hidden items-center gap-7 lg:flex">
          {NAV_LINKS.map((link) => (
            <button
              key={link.label}
              onClick={() => navigate(link.to, link.category ? { state: { category: link.category } } : undefined)}
              className="cursor-pointer text-sm font-medium text-text-soft transition-colors hover:text-text-primary"
            >
              {link.label}
            </button>
          ))}
        </nav>
      </div>

      <button
        onClick={() => navigate('/search')}
        aria-label="Search"
        className="flex h-10 w-10 flex-shrink-0 items-center justify-center gap-2.5 rounded-full border border-border bg-surface text-left cursor-pointer md:mx-4 md:h-auto md:w-auto md:flex-1 md:max-w-[520px] md:justify-start md:rounded-[10px] md:px-4 md:py-2.5 lg:mx-10"
      >
        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-secondary)" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0">
          <circle cx="11" cy="11" r="7" />
          <path d="M21 21l-4.3-4.3" />
        </svg>
        <span className="hidden text-[13.5px] text-text-secondary md:inline">Search for movies, events, plays...</span>
      </button>

      <div className="flex flex-shrink-0 items-center gap-3 sm:gap-5">
        <CityPicker />
        <ThemeToggle />

        {isAuthenticated ? (
          <Link to="/my-bookings" className="flex cursor-pointer items-center gap-2.5">
            <div className="flex h-[34px] w-[34px] items-center justify-center rounded-full bg-accent font-display text-[13px] font-bold">A</div>
          </Link>
        ) : (
          <Link
            to="/login"
            className="rounded-lg bg-accent px-3.5 py-2.5 text-[13.5px] font-semibold text-text-primary cursor-pointer sm:px-[22px]"
          >
            Sign In
          </Link>
        )}
      </div>
    </header>
  )
}
