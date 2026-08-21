interface CategoryTabProps {
  label: string
  active?: boolean
  onClick?: () => void
}

export function CategoryTab({ label, active, onClick }: CategoryTabProps) {
  return (
    <button
      onClick={onClick}
      className={[
        'flex-shrink-0 whitespace-nowrap rounded-full px-5 py-2.5 text-[13px] font-medium transition-colors duration-150 cursor-pointer',
        active
          ? 'bg-accent font-semibold text-text-primary'
          : 'border border-surface-raised bg-surface text-text-secondary hover:bg-surface-raised hover:text-text-primary',
      ].join(' ')}
    >
      {label}
    </button>
  )
}
