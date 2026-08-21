import type { ButtonHTMLAttributes, ReactNode } from 'react'

interface PrimaryButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode
  loading?: boolean
}

export function PrimaryButton({ children, loading, disabled, className = '', ...rest }: PrimaryButtonProps) {
  const isDisabled = disabled || loading

  return (
    <button
      disabled={isDisabled}
      className={[
        'inline-flex items-center justify-center gap-2 rounded-xl px-8 py-3.5',
        'font-body font-semibold text-[15px] transition-transform duration-150 active:scale-[0.96]',
        isDisabled
          ? 'bg-border-muted text-text-muted cursor-not-allowed'
          : 'bg-accent text-text-primary shadow-[0_4px_16px_rgba(226,55,68,0.35)] cursor-pointer hover:brightness-110',
        className,
      ].join(' ')}
      {...rest}
    >
      {loading && (
        <span className="h-4 w-4 rounded-full border-2 border-white/35 border-t-white animate-spin" />
      )}
      {children}
    </button>
  )
}
