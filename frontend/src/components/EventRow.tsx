import { motion } from 'framer-motion'
import { useNavigate } from 'react-router-dom'
import { MovieCard } from './MovieCard'
import { CardSkeleton } from './CardSkeleton'
import type { EnrichedEvent, EventCategory } from '../types/event'

interface EventRowProps {
  title: string
  events: EnrichedEvent[]
  loading: boolean
  // "See all" goes to Search preset to this category — undefined shows every category.
  seeAllCategory?: EventCategory
}

const listVariants = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.05 } },
}

const itemVariants = {
  hidden: { opacity: 0, y: 24 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.4, ease: 'easeOut' } },
} as const

export function EventRow({ title, events, loading, seeAllCategory }: EventRowProps) {
  const navigate = useNavigate()

  return (
    <section className="flex flex-col gap-4.5">
      <div className="flex items-center justify-between px-4 sm:px-6 lg:px-[90px]">
        <h2 className="font-display text-[22px] font-bold tracking-tight">{title}</h2>
        <button
          onClick={() => navigate('/search', seeAllCategory ? { state: { category: seeAllCategory } } : undefined)}
          className="cursor-pointer text-[13px] font-medium text-text-secondary hover:text-text-primary"
        >
          See all
        </button>
      </div>

      <motion.div
        variants={listVariants}
        initial="hidden"
        whileInView="visible"
        viewport={{ once: true, amount: 0.2 }}
        className="flex gap-5 overflow-x-auto px-4 sm:px-6 lg:px-[90px] pb-2.5 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
      >
        {loading
          ? Array.from({ length: 5 }).map((_, i) => <CardSkeleton key={i} />)
          : events.map((event) => (
              <motion.div key={event.id} variants={itemVariants}>
                <MovieCard
                  id={event.id}
                  title={event.title}
                  genre={event.category}
                  price={event.price}
                  rating={event.rating}
                  bookedCount={event.bookedCount}
                  status={event.status}
                  posterUrl={event.posterUrl}
                  onClick={() => navigate(`/events/${event.id}`)}
                />
              </motion.div>
            ))}
        <div className="w-[70px] flex-shrink-0" />
      </motion.div>
    </section>
  )
}
