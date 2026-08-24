import { useNavigate } from 'react-router-dom'
import type { EventCategory } from '../types/event'
import imgMovies from '../assets/topcategories/movies.png'
import imgEvents from '../assets/topcategories/events.png'
import imgPlays from '../assets/topcategories/plays.png'
import imgSports from '../assets/topcategories/sports.png'
import imgLive from '../assets/topcategories/live.png'

interface CategoryDef {
  label: string
  tagline: string
  to: string
  category?: EventCategory
  image: string
}

// Each image already has the category name + tagline designed into it (see
// images/top categories/) — no separate HTML text overlay, to avoid
// duplicating the same copy twice in two different typefaces on top of
// itself (the lesson from the Home hero image earlier in this pass).
// `tagline` is kept only to build accurate alt text for screen readers.
const CATEGORIES: CategoryDef[] = [
  { label: 'Movies', tagline: 'Blockbuster hits & timeless classics', to: '/search', category: 'MOVIE', image: imgMovies },
  { label: 'Events', tagline: "Nights you won't forget.", to: '/search', category: 'CONCERT', image: imgEvents },
  { label: 'Plays', tagline: 'Stories beyond the screen.', to: '/plays', image: imgPlays },
  { label: 'Sports', tagline: 'Be there when it happens.', to: '/sports', image: imgSports },
  { label: 'Live', tagline: "Feel it. Don't stream it.", to: '/live', image: imgLive },
]

export function TopCategories() {
  const navigate = useNavigate()

  return (
    <section className="flex flex-col gap-4.5">
      <div className="px-4 sm:px-6 lg:px-[90px]">
        <h2 className="font-display text-[22px] font-bold tracking-tight">Top Categories</h2>
      </div>

      <div className="flex gap-4 overflow-x-auto px-4 pb-2.5 sm:px-6 lg:px-[90px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
        {CATEGORIES.map((c) => (
          <button
            key={c.label}
            onClick={() => navigate(c.to, c.category ? { state: { category: c.category } } : undefined)}
            className="group relative h-[170px] w-[270px] flex-shrink-0 overflow-hidden rounded-2xl border border-border cursor-pointer transition-transform duration-300 hover:-translate-y-1"
          >
            <img
              src={c.image}
              alt={`${c.label} — ${c.tagline}`}
              className="absolute inset-0 h-full w-full object-cover transition-transform duration-[420ms] ease-out group-hover:scale-105"
            />
            <span className="absolute inset-0 rounded-2xl ring-1 ring-inset ring-white/5 transition-colors duration-300 group-hover:ring-gold/40" />
            <span className="absolute bottom-0 left-5 h-[2px] w-0 bg-gold transition-all duration-300 group-hover:w-10" />
          </button>
        ))}
      </div>
    </section>
  )
}
