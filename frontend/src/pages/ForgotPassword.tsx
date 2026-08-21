import { useState } from 'react'
import { Link } from 'react-router-dom'
import { forgotPassword } from '../api/auth'
import { PosterCollagePanel } from '../components/PosterCollagePanel'

export function ForgotPassword() {
  const [email, setEmail] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [sent, setSent] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setSubmitting(true)
    await forgotPassword(email)
    setSent(true)
    setSubmitting(false)
  }

  return (
    <div className="flex min-h-screen bg-bg text-text-primary">
      <PosterCollagePanel />

      <div className="flex flex-1 items-center justify-center px-4 sm:px-6">
        <form onSubmit={handleSubmit} className="flex w-full max-w-[380px] flex-col gap-5">
          <div>
            <div className="font-display text-[28px] font-extrabold tracking-tight">Reset your password</div>
            <div className="mt-2 text-[13.5px] text-text-secondary">
              Enter the email on your account — we'll send a link to set a new password.
            </div>
          </div>

          <div className="flex flex-col gap-1.5">
            <label className="text-xs font-semibold text-text-secondary">Email</label>
            <input
              type="email"
              required
              autoFocus
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@example.com"
              className="rounded-[10px] border border-border bg-surface px-4 py-3 text-sm text-text-primary placeholder:text-text-muted focus:border-accent focus:outline-none"
            />
          </div>

          <button
            type="submit"
            disabled={submitting || sent}
            className="rounded-xl bg-accent py-3.5 text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
          >
            {submitting ? 'Sending…' : 'Send Reset Link'}
          </button>

          {sent && (
            <div className="flex items-center gap-2.5 rounded-[10px] border border-success/30 bg-success/10 px-3.5 py-3">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2ECC71" strokeWidth={2.5} strokeLinecap="round" strokeLinejoin="round"><path d="M20 6L9 17l-5-5" /></svg>
              <span className="text-[12.5px] text-success">If that email has an account, a reset link is on its way.</span>
            </div>
          )}

          <Link to="/login" className="text-center text-[12.5px] font-semibold text-text-secondary cursor-pointer">&larr; Back to Log In</Link>
        </form>
      </div>
    </div>
  )
}
