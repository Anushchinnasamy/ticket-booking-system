import { motion } from 'framer-motion'

type BookingStatus = 'available' | 'filling-fast' | 'housefull'

interface MovieCardProps {
  id: string
  title: string
  genre: string
  price: number
  rating: number
  bookedCount: string
  status: BookingStatus
  posterUrl?: string
  onClick?: () => void
}

const STATUS_STYLES: Record<BookingStatus, { label: string; className: string }> = {
  available: { label: 'AVAILABLE', className: 'bg-success/15 text-success' },
  'filling-fast': { label: 'FILLING FAST', className: 'bg-accent-dim text-gold' },
  housefull: { label: 'HOUSEFULL', className: 'bg-danger/15 text-danger' },
}

export function MovieCard({ id, title, genre, price, rating, bookedCount, status, posterUrl, onClick }: MovieCardProps) {
  const statusStyle = STATUS_STYLES[status]

  return (
    <button
      onClick={onClick}
      className="group flex w-[196px] flex-col gap-2.5 text-left cursor-pointer"
    >
      <div className="relative h-[294px] w-[196px] overflow-hidden rounded-2xl shadow-[0_8px_24px_-8px_rgba(0,0,0,0.5)] transition-shadow duration-300 group-hover:-translate-y-1.5 group-hover:shadow-[0_28px_48px_-12px_rgba(0,0,0,0.7)]">
        {posterUrl ? (
          <motion.img
            layoutId={`poster-${id}`}
            src={posterUrl}
            alt={title}
            className="absolute inset-0 h-full w-full object-cover transition-transform duration-[420ms] ease-out group-hover:scale-[1.12]"
          />
        ) : (
          <div className="absolute inset-0 bg-gradient-to-br from-surface-raised to-bg transition-transform duration-[420ms] ease-out group-hover:scale-[1.12]" />
        )}

        <div className="absolute inset-0 bg-gradient-to-b from-transparent from-45% to-black/80" />

        <div className="absolute inset-0 flex items-center justify-center bg-black/45 opacity-0 backdrop-blur-[1px] transition-opacity duration-300 group-hover:opacity-100">
          <span className="translate-y-2 rounded-full bg-accent px-4.5 py-2 text-xs font-semibold text-text-primary transition-transform duration-300 group-hover:translate-y-0">
            View Showtimes
          </span>
        </div>

        <div className="absolute left-2.5 top-2.5 flex items-center gap-1 rounded-lg bg-bg/75 px-2 py-1">
          <svg width="11" height="11" viewBox="0 0 24 24" fill="#F5C518"><path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.6 7-6.2-3.9-6.2 3.9 1.6-7L2 9.2l7.1-.6z" /></svg>
          <span className="font-variant-numeric-tabular text-[11.5px] font-semibold">{rating.toFixed(1)}</span>
        </div>

        <div className="absolute bottom-2.5 left-2.5">
          <span className={`rounded-full px-2.5 py-1 text-[10.5px] font-bold tracking-wide ${statusStyle.className}`}>
            {statusStyle.label}
          </span>
        </div>
      </div>

      <div className="font-display text-sm font-semibold leading-tight text-text-primary">{title}</div>
      <div className="flex items-center justify-between">
        <span className="text-xs text-text-secondary">{genre} · ₹{price}</span>
        <span className="font-variant-numeric-tabular text-[11px] text-text-secondary">{bookedCount} booked</span>
      </div>
    </button>
  )
}
