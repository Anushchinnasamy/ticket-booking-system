# Ticket Booking System — Frontend Plan (District-Inspired UI)

Visual direction is deliberately borrowed from District (by Zomato) — dark theme, single bold red accent, poster-forward cards, pill category tabs. This is a design *inspired by* District's language for a portfolio project, not a literal clone of their brand assets — use your own app name/logo, not theirs.

---

## 1. Design Tokens

### Color
| Token | Hex | Use |
|---|---|---|
| `bg` | `#0E0E10` | App background — near-black, not pure black |
| `surface` | `#1A1A1D` | Cards, sheets, modals |
| `surface-raised` | `#232326` | Elevated cards (e.g. selected seat tier) |
| `accent` | `#E23744` | CTAs, active tab, price, "Book Now" |
| `accent-dim` | `#5A1218` | Accent at low opacity for subtle backgrounds/badges |
| `gold` | `#F5C518` | Ratings only — don't dilute this by overusing it |
| `text-primary` | `#F5F5F7` | Headings, titles |
| `text-secondary` | `#9A9AA2` | Metadata — showtimes, genre, runtime |
| `success` | `#2ECC71` | Seat available, booking confirmed |
| `danger` | `#FF4D4D` | Seat locked/unavailable, errors |

These are close approximations of the known District/Zomato identity, not sampled hex values — grab real screenshots from your own phone if you want pixel-exact colors for a side-by-side comparison shot in your portfolio.

### Typography
| Role | Face | Notes |
|---|---|---|
| Display (movie titles, headings) | Manrope or General Sans, 600-700 weight | Tight letter-spacing, used with restraint |
| Body / UI text | Inter, 400-500 weight | Card metadata, buttons, form fields |
| Numeric (showtimes, prices, countdown, seat numbers) | Inter with `font-variant-numeric: tabular-nums` | Prevents digit jitter on the seat-lock countdown |

### Layout Concept
- **Home:** header (city selector left, search icon right) → horizontal pill category tabs → hero carousel (large cards, auto-scroll) → stacked horizontal-scroll sections ("Recommended," "This Weekend," "Live Events")
- **Cards:** poster image dominant (2:3 ratio), title + rating badge overlaid bottom-left, price/genre as secondary line below
- **Seat map:** centered grid, screen indicator as a curved line at top, legend row (Available/Selected/Booked) pinned above the grid, price-tier color coding, sticky bottom bar showing selected count + total + countdown

### Signature Element
The seat-lock countdown badge — pulses subtly under 60 seconds remaining, tied to your actual Redis TTL, not just a decorative timer. This is the one place worth spending visual boldness; keep everything else disciplined and quiet around it.

---

## 2. Screen Inventory

| Screen | Purpose | Key components |
|---|---|---|
| Landing / Home | Browse by category, discover trending | City selector, search bar, category tabs, hero carousel, horizontal scroll sections, movie/event card |
| Search | Find by name, filter by category/city | Search input with debounce, filter chips, result grid |
| Event Detail | Show synopsis, cast, showtimes | Poster banner, tab switcher (About/Showtimes/Reviews), cinema list grouped by showtime, format filter (2D/3D/IMAX) |
| Seat Selection | Pick seats, see the lock countdown live | Seat grid, screen indicator, legend, price-tier chips, sticky summary bar with countdown |
| Payment | Complete checkout | Order summary, payment method selector, coupon input, idempotency-safe submit button (disable on click, show spinner, don't allow double-tap) |
| Confirmation / Ticket | Show QR, allow sharing | QR code, event/seat details, share button (native OS share sheet), add-to-wallet stretch goal |
| Auth (Login/OTP/Forgot Password) | Get the user in | Email/password form, OTP entry (6 boxes, auto-advance), forgot-password flow |
| My Bookings | Past and upcoming tickets | Tabbed list (Upcoming/Past), ticket card linking to Confirmation screen |

---

## 3. Component Library

Build these once, reuse everywhere — don't let each screen invent its own card or button:

- `MovieCard` / `EventCard` — poster, title, rating badge, price
- `CategoryTab` — pill-shaped, active state uses `accent`
- `CitySelector` — dropdown/sheet
- `SearchBar` — with debounce, clears on category change
- `SeatCell` — states: available, selected, locked-by-you, booked, unavailable
- `CountdownBadge` — the signature element, pulses under 60s
- `RatingBadge` — gold star + number, small footprint
- `PrimaryButton` — accent-filled, used for every CTA, disabled state clearly distinct (not just lower opacity — actually gray out)
- `BottomNav` — Home / Search / My Bookings / Profile

---

## 4. Motion & 3D System

Two techniques doing two different jobs. Don't reach for Three.js everywhere just because "3D" was the brief — that's how an app ends up slow and gimmicky instead of premium. The 3D budget gets spent in exactly one place where the subject actually earns it.

| Purpose | Library |
|---|---|
| Page transitions, shared-element morphing, micro-interactions | Framer Motion |
| The one true 3D piece — the seat map | React Three Fiber + drei |
| Scroll feel (optional polish pass) | Lenis |

**Page transitions:**
- Route changes fade+slide via `AnimatePresence`, 200-250ms — longer than that starts feeling sluggish on repeat navigation, not premium
- Shared-element transition (`layoutId`) from the movie poster on the home grid to the hero image on Event Detail — the same image element grows and repositions across the route change instead of the next page popping in fresh. This one technique is the biggest contributor to "doesn't feel like a simple clone" — it's what Linear, Vercel, and most premium product sites actually do for this exact reason

**Micro-interactions:**
- Card tilt on hover/touch-drag: `MovieCard`/`EventCard` respond to pointer position with a subtle `rotateX`/`rotateY` (max ~6-8°) plus a shadow that shifts with the tilt — a CSS 3D transform, not a Three.js scene, cheap and instant
- Staggered entrance: cards in a horizontal-scroll row fade+rise in with a small stagger (40-60ms between siblings) the first time they scroll into view, not on every re-render
- Button press: scale down slightly on press, not just a color swap on hover — makes taps feel physical

**The signature 3D piece — a real 3D auditorium seat map (Phase F3):**
- Seats as instanced boxes on a raked (tilted) floor like an actual auditorium, viewed from a fixed elevated angle with subtle orbit-drag to look around
- Status colors (`success`/`accent`/`danger` from the token table) drive material color, not texture swaps
- Selecting a seat can trigger a small camera move toward a "your view of the screen" preview — a real feature actual cinema apps (AMC, Cinemark) ship, and the clearest justification for going 3D at all: you're picking a physical seat in a physical room
- **Performance matters more here than anywhere else in the app:** your Phase 1 seed data already includes a large stadium show — hundreds of seats means `InstancedMesh`, not one mesh per seat, or this tanks frame rate on exactly the flash-sale scenario the backend is built to prove works. Profile this screen at a 500-seat venue in the browser's performance tab before calling it done — same discipline as load-testing the backend

**Ticket reveal (Phase F5):**
- The confirmed ticket flips into view with a real 3D `rotateY` card-flip (`perspective` + `backface-visibility`), landing on the ticket face with the QR code scaling in once the flip settles — one earned flourish for the payoff moment of the whole flow

**Guardrails:**
- `prefers-reduced-motion` disables all of the above (transitions go instant, tilt/flip become simple fades) — not optional, it's an accessibility requirement, not a nice-to-have
- The seat map is the only screen running a WebGL canvas — don't mount Three.js on every page, it wrecks load time and battery on mobile
- Any animation over ~300ms on something the user does repeatedly (paging through search results) gets cut — delight on the first visit becomes friction by the fifth

---

## 5. Phase-by-Phase Frontend Build Plan

### Phase F0 — Setup
- React + Vite, Tailwind configured with the token table above as custom colors, not inline hex scattered through components
- Install Framer Motion (transitions, micro-interactions) and React Three Fiber + drei (the seat map) — see Section 4 below for how each is used
- Component library scaffold: build `PrimaryButton`, `MovieCard`, `CategoryTab` first as a mini Storybook-style page even before real API data exists

### Phase F1 — Landing & Browse
- Home screen wired to `GET /events` from Phase 1 of the backend plan
- Category tabs filter the request, not just the client-side list — respect the real API contract
- Skeleton loading states for cards (not a spinner — content-shaped placeholders match the District/BMS pattern)
- Card tilt micro-interaction and staggered entrance on scroll — see Section 4

### Phase F2 — Search & Event Detail
- Debounced search hitting the backend search endpoint
- Event detail page pulling show/venue data, format filter, cinema grouping
- Shared-element (`layoutId`) transition from the poster card tapped on Home into this page's hero image — see Section 4

### Phase F3 — Seat Selection (the important one)
- Seat map rendering from `GET /shows/{id}/seats`
- Real-time updates: start with polling every 3-4s (matches what we discussed for the client layer earlier), upgrade to WebSocket once this works
- Wire the actual lock call — `POST /bookings/lock` — and the countdown badge to the real TTL returned from the backend, not a hardcoded 5 minutes on the client. If the client and server timers drift, that's the exact bug that makes users think they got scammed when a seat releases "early."
- Build the 3D auditorium seat map here (React Three Fiber, `InstancedMesh`) — this is the biggest single chunk of frontend work in the whole plan, budget accordingly. Get it working flat/2D first against mock data, then layer in the 3D scene once seat-status wiring is solid — debugging lock-state bugs is much easier without a camera and instancing in the way

### Phase F4 — Payment
- Idempotency key generated client-side (UUID) before the first charge attempt, reused on retry — matches Phase 4 of the backend plan exactly
- Disable the pay button immediately on click, not just visually — prevent a second network call, not just a second visual click

### Phase F5 — Confirmation & Ticket
- QR display from `GET /bookings/{id}/ticket`, revealed with the 3D flip-card animation — see Section 4
- Share button using the native Web Share API (`navigator.share`) where available, falling back to a copy-link button — this is what actually lets someone forward the ticket to WhatsApp, matching the share-link backend work from Phase 7

### Phase F6 — Auth Screens
- Login, OTP entry (auto-advancing 6-box input, paste support), forgot-password flow — all wired to Phase 5 of the backend plan

### Phase F7 — My Bookings & Polish
- Past/upcoming tabs, empty states (an empty "My Bookings" screen should invite action — "No bookings yet — explore what's playing," not just blank space)
- Responsive pass down to mobile width (this is a mobile-first design already, but verify on an actual small viewport, not just a resized browser window)
- Accessibility pass: visible keyboard focus states, reduced-motion respected for the countdown pulse

---

## Next steps

Once the backend's Phase 0-3 are running, Phase F0-F3 here can start in parallel — the seat map UI can be built against mock data before the real WebSocket/polling endpoint exists, then wired in once Phase 3 (Redis locking) is live on the backend. Ask when you're ready to start either side.
