import { useState } from 'react'
import { useLocation, useNavigate, Link } from 'react-router-dom'
import { login, AuthError } from '../api/auth'
import { PosterCollagePanel } from '../components/PosterCollagePanel'

export function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: { pathname: string; search?: string; state?: unknown } } | null)?.from

  const [email, setEmail] = useState('admin@ticketbooking.local')
  const [password, setPassword] = useState('AdminPass123!')
  const [showPassword, setShowPassword] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [fallbackNotice, setFallbackNotice] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setSubmitting(true)
    setError(null)
    try {
      const { isFallback } = await login({ email, password })
      if (isFallback) setFallbackNotice(true)
      navigate((from?.pathname ?? '/') + (from?.search ?? ''), { state: from?.state, replace: true })
    } catch (err) {
      setError(err instanceof AuthError ? err.message : 'Something went wrong — please try again.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="flex min-h-screen bg-bg text-text-primary">
      <PosterCollagePanel />

      <div className="flex flex-1 items-center justify-center px-4 sm:px-6">
        <form onSubmit={handleSubmit} className="flex w-full max-w-[380px] flex-col gap-5">
          <div>
            <div className="font-display text-[28px] font-extrabold tracking-tight">Welcome back</div>
            <div className="mt-2 text-[13.5px] text-text-secondary">Log in to hold seats and manage your bookings.</div>
          </div>

          {error && <div className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">{error}</div>}
          {fallbackNotice && (
            <div className="rounded-lg border border-gold/30 bg-accent-dim px-3.5 py-2.5 text-[13px] text-gold">
              Couldn't reach the auth API — signed in with a simulated session for local testing.
            </div>
          )}

          <div className="flex flex-col gap-1.5">
            <label className="text-xs font-semibold text-text-secondary">Email</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="rounded-[10px] border border-border bg-surface px-4 py-3 text-sm text-text-primary focus:border-accent focus:outline-none"
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <label className="text-xs font-semibold text-text-secondary">Password</label>
            <div className="flex items-center rounded-[10px] border border-border bg-surface px-4 py-3 focus-within:border-accent">
              <input
                type={showPassword ? 'text' : 'password'}
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-transparent text-sm text-text-primary focus:outline-none"
              />
              <button type="button" onClick={() => setShowPassword((v) => !v)} className="text-text-secondary cursor-pointer">
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
                  <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z" /><circle cx="12" cy="12" r="3" />
                </svg>
              </button>
            </div>
          </div>

          <div className="-mt-1.5 flex justify-end">
            <Link to="/forgot-password" className="text-[12.5px] font-semibold text-accent cursor-pointer">Forgot password?</Link>
          </div>

          <button
            type="submit"
            disabled={submitting}
            className="mt-1 rounded-xl bg-accent py-3.5 text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
          >
            {submitting ? 'Signing in…' : 'Log In'}
          </button>

          <div className="flex items-center gap-3 text-xs text-text-secondary">
            <div className="h-px flex-1 bg-border" /> or <div className="h-px flex-1 bg-border" />
          </div>

          <Link
            to="/verify-otp"
            className="rounded-xl border border-border bg-surface py-3.5 text-center text-[15px] font-semibold cursor-pointer"
          >
            Log In with a Code Instead
          </Link>

          <div className="text-center text-xs text-text-secondary">Pre-filled with the seeded admin account for local testing.</div>
        </form>
      </div>
    </div>
  )
}
