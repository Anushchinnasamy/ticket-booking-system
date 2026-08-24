import type { ReactNode } from 'react'
import { PrimaryButton } from './PrimaryButton'

interface ErrorStateProps {
  title?: string
  message: string
  actionLabel?: string
  onAction?: () => void
  icon?: ReactNode
}

export function ErrorState({ title = 'WE LOST THE SIGNAL.', message, actionLabel = 'Try Again', onAction, icon }: ErrorStateProps) {
  return (
    <div className="flex flex-col items-center justify-center gap-4 px-6 py-20 text-center">
      {icon ?? (
        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="var(--color-gold)" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" className="opacity-70">
          <path d="M2 8.82a15 15 0 0 1 20 0" />
          <path d="M5 12.86a10 10 0 0 1 14 0" />
          <path d="M8.5 16.9a5 5 0 0 1 7 0" />
          <line x1="2" y1="2" x2="22" y2="22" />
        </svg>
      )}
      <h2 className="font-display text-xl font-bold tracking-tight sm:text-2xl">{title}</h2>
      <p className="max-w-sm text-[14px] text-text-secondary">{message}</p>
      {onAction && (
        <PrimaryButton onClick={onAction} className="mt-2 px-7 py-3 text-sm">
          {actionLabel}
        </PrimaryButton>
      )}
    </div>
  )
}
