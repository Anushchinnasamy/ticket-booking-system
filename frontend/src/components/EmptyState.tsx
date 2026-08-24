import type { ReactNode } from 'react'
import { PrimaryButton } from './PrimaryButton'

interface EmptyStateProps {
  title: string
  message: string
  actionLabel?: string
  onAction?: () => void
  icon?: ReactNode
}

export function EmptyState({ title, message, actionLabel, onAction, icon }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center gap-4 px-6 py-20 text-center">
      {icon ?? (
        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="var(--color-text-muted)" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" className="opacity-70">
          <circle cx="11" cy="11" r="7" />
          <path d="M21 21l-4.3-4.3" />
        </svg>
      )}
      <h2 className="font-display text-xl font-bold tracking-tight sm:text-2xl">{title}</h2>
      <p className="max-w-sm text-[14px] text-text-secondary">{message}</p>
      {onAction && actionLabel && (
        <PrimaryButton onClick={onAction} className="mt-2 px-7 py-3 text-sm">
          {actionLabel}
        </PrimaryButton>
      )}
    </div>
  )
}
