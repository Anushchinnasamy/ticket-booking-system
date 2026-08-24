import { Link } from 'react-router-dom'

interface ComingSoonPageProps {
  /** Section 24 style category label + tagline, e.g. "PLAYS" / "Stories beyond the screen." */
  title: string
  tagline: string
  badge: string
  /** What to say instead of a generic placeholder line — kept honest, no fabricated listings. */
  message: string
  gradient: string
}

export function ComingSoonPage({ title, tagline, badge, message, gradient }: ComingSoonPageProps) {
  return (
    <div className="relative flex min-h-[70vh] flex-col items-center justify-center gap-5 overflow-hidden px-6 text-center">
      <div className={`absolute inset-0 bg-gradient-to-br ${gradient}`} />
      <div className="absolute inset-0 bg-gradient-to-t from-bg via-bg/40 to-bg/70" />

      <span className="relative inline-flex items-center gap-2 rounded-full border border-gold/35 bg-accent-dim px-3.5 py-1.5 text-[11px] font-bold uppercase tracking-[0.18em] text-gold">
        {badge}
      </span>
      <h1 className="relative font-display text-[34px] font-bold tracking-tight sm:text-[44px]">{title}</h1>
      <p className="relative font-display text-lg italic text-gold sm:text-xl">{tagline}</p>
      <p className="relative max-w-sm text-sm leading-relaxed text-text-secondary">{message}</p>
      <Link
        to="/"
        className="relative mt-2 rounded-xl bg-accent px-6 py-3 text-sm font-semibold text-obsidian shadow-[0_8px_24px_rgba(245,166,35,0.35)] cursor-pointer transition-transform hover:brightness-110 active:scale-[0.97]"
      >
        Explore What's Live Now
      </Link>
    </div>
  )
}
