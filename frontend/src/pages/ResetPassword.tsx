import { useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { resetPassword, AuthError } from '../api/auth'
import { PosterCollagePanel } from '../components/PosterCollagePanel'

export function ResetPassword() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token')

  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [done, setDone] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (newPassword !== confirmPassword) {
      setError('Passwords do not match.')
      return
    }
    if (!token) {
      setError('This reset link is missing its token.')
      return
    }
    setSubmitting(true)
    try {
      await resetPassword(token, newPassword)
      setDone(true)
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
        {done ? (
          <div className="flex w-full max-w-[380px] flex-col items-center gap-4 text-center">
            <div className="flex h-14 w-14 items-center justify-center rounded-full bg-success/12">
              <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#2ECC71" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round"><path d="M20 6L9 17l-5-5" /></svg>
            </div>
            <div className="font-display text-2xl font-extrabold tracking-tight">Password updated</div>
            <p className="text-[13.5px] text-text-secondary">You can now log in with your new password.</p>
            <Link to="/login" className="mt-2 w-full rounded-xl bg-accent py-3.5 text-center text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] cursor-pointer">
              Go to Log In
            </Link>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="flex w-full max-w-[380px] flex-col gap-5">
            <div>
              <div className="font-display text-[28px] font-extrabold tracking-tight">Set a new password</div>
              <div className="mt-2 text-[13.5px] text-text-secondary">Must be at least 8 characters.</div>
            </div>

            {!token && (
              <div className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">
                This link is missing its reset token — open it directly from the email we sent you.
              </div>
            )}
            {error && <div className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">{error}</div>}

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-text-secondary">New password</label>
              <input
                type="password"
                required
                minLength={8}
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                className="rounded-[10px] border border-border bg-surface px-4 py-3 text-sm text-text-primary focus:border-accent focus:outline-none"
              />
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-text-secondary">Confirm password</label>
              <input
                type="password"
                required
                minLength={8}
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="rounded-[10px] border border-border bg-surface px-4 py-3 text-sm text-text-primary focus:border-accent focus:outline-none"
              />
            </div>

            <button
              type="submit"
              disabled={submitting || !token}
              className="rounded-xl bg-accent py-3.5 text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
            >
              {submitting ? 'Updating…' : 'Update Password'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
