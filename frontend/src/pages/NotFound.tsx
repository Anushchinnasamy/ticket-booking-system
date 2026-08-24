import { Link } from 'react-router-dom'

export function NotFound() {
  return (
    <div className="flex min-h-[70vh] flex-col items-center justify-center gap-3 text-center">
      <div className="font-display text-5xl font-extrabold tracking-tight text-accent">404</div>
      <p className="text-sm text-text-secondary">This page doesn't exist.</p>
      <Link
        to="/"
        className="mt-4 rounded-xl bg-accent px-6 py-3 text-sm font-semibold text-obsidian shadow-[0_8px_24px_rgba(245,166,35,0.35)] cursor-pointer transition-transform hover:brightness-110 active:scale-[0.97]"
      >
        Back to Home
      </Link>
    </div>
  )
}
