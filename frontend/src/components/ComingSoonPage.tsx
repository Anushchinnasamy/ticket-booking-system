import { Link } from 'react-router-dom'

interface ComingSoonPageProps {
  title: string
  phase: string
}

export function ComingSoonPage({ title, phase }: ComingSoonPageProps) {
  return (
    <div className="flex min-h-[70vh] flex-col items-center justify-center gap-3 px-6 text-center">
      <span className="font-display text-xs font-extrabold uppercase tracking-[0.18em] text-accent">{phase}</span>
      <h1 className="font-display text-2xl font-bold tracking-tight">{title}</h1>
      <p className="max-w-sm text-sm text-text-secondary">
        This screen is routed and ready — the real implementation lands when we build this phase.
      </p>
      <Link to="/" className="mt-4 rounded-xl bg-accent px-6 py-3 text-sm font-semibold cursor-pointer">
        Back to Home
      </Link>
    </div>
  )
}
