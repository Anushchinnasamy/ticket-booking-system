# Ticket Booking System --- Complete Cinematic Gold Awwwards Frontend Master Plan

## Master instruction for Claude Code

Transform the **complete existing Ticket Booking System frontend** into
a premium, cinematic, Awwwards-inspired ticketing experience.

The repository is the source of truth. **Audit the actual code before
changing anything.**

Preserve the existing backend, microservices, APIs, authentication,
event/show logic, seat availability, seat locking, booking, payment,
ticket generation, sharing, booking history and all existing business
rules.

Do not invent APIs. Do not replace real application behavior with mock
implementations.

------------------------------------------------------------------------

## 1. Approved visual direction --- Cinematic Gold

The approved direction is a premium cinema/editorial experience:

**luxury cinema + modern product design + editorial typography +
cinematic photography + subtle motion**

Do not make it look like a generic ticket-booking clone.

The design should feel closer to a premium digital cinema brand than a
conventional booking portal.

### Color language

Primary:

``` text
Obsidian       #080808
Cinema Black   #111111
Gold           #F5A623
Warm Gold      #FFC857
Cream          #F5EBDD
Purple Ambient #6D3CFF
Muted Gray     #777777
```

Use purple mainly for the immersive auditorium/seat environment.

Gold is the main interaction/accent color.

Cream is useful for editorial detail/payment surfaces.

------------------------------------------------------------------------

## 2. AI-generated realistic imagery --- approved

**Realistic AI-generated imagery is explicitly allowed and encouraged.**

Use original AI-generated visuals where the repository lacks suitable
assets.

Suitable imagery:

-   cinematic movie hero artwork
-   realistic cinema interiors
-   theatre architecture
-   realistic event photography
-   realistic play/theatre photography
-   sports/event atmosphere
-   atmospheric audience scenes
-   editorial promotional artwork
-   category hero images
-   cinematic ticket/confirmation visuals

The target is **professional photography / film-poster quality**, not
obvious AI art.

### Image quality requirements

Prefer:

-   photorealistic lighting
-   realistic faces and anatomy
-   believable environments
-   natural textures
-   cinematic depth of field
-   dramatic but believable lighting
-   coherent color grading
-   high-resolution editorial composition

Avoid:

-   distorted faces/hands
-   impossible objects
-   AI artifacts
-   random text inside images
-   fake logos
-   copyrighted franchise branding unless the project has the legal
    rights/assets
-   misleading real-world brand marks

If the repository already contains real poster/event assets, prefer
those where appropriate.

If AI generation is available, create original imagery and store it
under a structured asset directory such as:

``` text
frontend/public/images/ai/
  hero/
  movies/
  events/
  theatres/
  plays/
  sports/
  categories/
```

If image generation is not available during coding, use clean
placeholders and keep image references centralized so generated assets
can be added later.

Do not block functional development on image generation.

------------------------------------------------------------------------

## 3. Repository audit --- mandatory

The uploaded project already has a meaningful architecture. Before
coding, inspect the actual repository and verify everything.

Map:

### Frontend

-   React version
-   TypeScript
-   Vite
-   Tailwind
-   React Router
-   Framer Motion
-   Three.js
-   React Three Fiber
-   Drei
-   state management
-   API clients
-   hooks
-   routes
-   reusable components
-   current frontend design files

### Backend

Inspect the actual microservices/controllers/services/DTOs.

Map at minimum:

``` text
API Gateway
Event Service
Booking Service
Payment Service
User Service
Notification Service
```

Verify the actual implementation rather than assuming it.

### Important business flows

Inspect:

-   event discovery
-   city selection
-   event details
-   shows
-   seat availability
-   seat locking/holding
-   booking creation
-   booking confirmation
-   payment
-   payment verification
-   ticket generation
-   ticket download
-   ticket sharing
-   combined tickets
-   authentication
-   OTP
-   password reset
-   booking history

------------------------------------------------------------------------

## 4. Existing routes

Audit and preserve every existing route.

Known customer-facing areas include routes around:

``` text
/
 /search
 /events/:eventId
 /events/:eventId/seats
 /checkout/payment
 /bookings/:bookingId/confirmation
 /my-bookings

 /login
 /verify-otp
 /forgot-password
 /reset-password

 /plays
 /live
```

Verify the repository for the complete current route map and include any
additional routes.

If admin/management routes exist, redesign them too.

------------------------------------------------------------------------

## 5. Existing 3D seat-selection foundation

The project already contains 3D seat-selection infrastructure using:

-   React Three Fiber
-   Drei
-   seat auditorium components
-   seat instances
-   camera rig
-   seat cells

**Do not throw this away.**

Turn it into the signature visual feature of the application.

The seat experience should remain usable even if 3D is disabled.

Provide a responsive/2D fallback if necessary.

------------------------------------------------------------------------

## 6. Home / discovery

Home should be cinematic.

Concept:

``` text
NAV

Experience Cinema
Like Never Before

Book tickets.
Watch trailers.
Live the movie magic.

[ Browse Movies ]

Cinematic hero artwork

NOW SHOWING

movie cards

TOP CATEGORIES

Movies / Events / Plays / Sports / Live

TRENDING

CTA
```

Use real event data.

Do not fabricate statistics.

### Hero animation

GSAP:

`navbar → eyebrow → headline → copy → CTA → image → cards`

Use:

-   clip-path reveal
-   scale
-   translate
-   opacity
-   subtle parallax
-   stagger

------------------------------------------------------------------------

## 7. Search

Create an immersive search experience.

Initial state:

``` text
SEARCH

What are you in the mood for?

[ Search movies, events, plays... ]

Popular searches
```

Results:

-   poster/event image
-   title
-   category
-   rating
-   metadata supplied by backend

Use actual search functionality.

Do not replace backend filtering/search with fake client-side data.

------------------------------------------------------------------------

## 8. Event/movie detail

This should be an editorial page.

Hero:

-   large realistic poster/banner
-   title
-   rating
-   genres
-   duration
-   description
-   supported formats/features
-   dates
-   theatres
-   showtimes

Suggested typography:

**Elegant serif display + clean sans-serif UI.**

Recommended fonts:

-   Display: DM Serif Display / Playfair Display / equivalent
-   UI: Inter / DM Sans / equivalent

------------------------------------------------------------------------

## 9. Date selection

Create premium date cards:

``` text
FRI 24
MAY

SAT 25
MAY

SUN 26
MAY
```

Selected date:

-   gold background
-   black text
-   subtle scale

Dates should animate horizontally on mobile.

Use real show availability.

------------------------------------------------------------------------

## 10. Theatre selection

Display actual theatres.

Example structure:

``` text
PVR Orion Mall
Koramangala
4.5 km

IMAX · Dolby Atmos

[ showtimes ]
```

Selected theatre gets:

-   gold border
-   subtle glow
-   check state

Do not fabricate theatre metadata.

------------------------------------------------------------------------

## 11. Showtimes

Showtimes should be highly interactive:

``` text
09:30 AM
12:30 PM
03:45 PM
07:00 PM
10:15 PM
```

Selected time:

**gold / black**

Hover/tap animation should be short and tactile.

------------------------------------------------------------------------

## 12. Seat selection --- signature experience

This is the standout page.

Use the existing 3D auditorium.

Concept:

``` text
cinema screen
      ↓
immersive auditorium
      ↓
real seat map
```

The user should feel like they are entering the cinema.

### Camera

Use a controlled camera rig.

Possible sequence:

``` text
page enters
↓
camera settles into auditorium
↓
screen becomes visible
↓
seat availability appears
```

Keep movement subtle.

No motion sickness.

------------------------------------------------------------------------

## 13. Seat states

Use clear visual states:

``` text
Available → subtle white/purple
Selected  → glowing gold
Booked    → muted gray
Premium   → warm amber/gold
```

Only use states supported by the actual backend.

Never fake availability.

------------------------------------------------------------------------

## 14. Seat selection interaction

When a user selects a seat:

``` text
seat selected
↓
visual glow
↓
small scale animation
↓
real backend hold/booking state
↓
summary updates
↓
total animates
```

When removed:

``` text
seat de-select
↓
state updates
↓
total animates
```

------------------------------------------------------------------------

## 15. Seat locking / hold timer

The backend already supports temporary seat holds.

Reflect the real state.

Example:

``` text
SEATS HELD FOR
04:52
```

Use an animated progress ring.

As expiry approaches:

-   subtle warning
-   restrained pulse

If the hold expires:

``` text
Your seat hold expired.

[ Select Seats Again ]
```

Do not implement a fake timer disconnected from backend behavior.

------------------------------------------------------------------------

## 16. Booking summary

Desktop: persistent side/bottom panel.

Mobile: sticky bottom summary.

Show actual:

``` text
Event
Theatre
Date
Time
Seats
Ticket price
Fees
Discount
Total
```

Example:

``` text
Dune: Part Two
PVR Orion Mall
24 May · 12:30 PM

E4 · E5 · E6

TOTAL
₹1,050

[ Proceed to Payment → ]
```

Prices must come from actual booking/pricing logic.

------------------------------------------------------------------------

## 17. Payment

Keep the existing payment integration.

The UI should be calmer than the seat-selection page.

Suggested:

``` text
PAYMENT

Booking summary

Seats
Ticket price
Fees
Discount
Total

[ Pay Securely ]
```

States:

`idle → processing → verified → success/error`

Never fake successful payment.

Preserve idempotency and backend verification behavior.

------------------------------------------------------------------------

## 18. Confirmation

Make confirmation memorable.

Example:

``` text
✓

YOU'RE GOING.

Dune: Part Two

PVR Orion Mall
12:30 PM

E4 · E5 · E6
```

Then reveal the digital ticket.

Use a subtle celebratory animation.

------------------------------------------------------------------------

## 19. Digital ticket

Design a premium digital ticket.

Include actual:

-   event/movie
-   theatre
-   date
-   time
-   seats
-   booking ID
-   QR/ticket information

Actions:

-   download
-   share
-   view booking

Preserve existing ticket PDF/share APIs and native share functionality.

Do not fabricate ticket data.

------------------------------------------------------------------------

## 20. My Bookings

Create an elegant booking archive.

Upcoming:

``` text
Dune: Part Two
24 May · 12:30 PM
PVR Orion Mall

[ View Ticket ]
```

Past:

``` text
Oppenheimer
...
```

Use event imagery as the visual anchor.

------------------------------------------------------------------------

## 21. Booking details

Show:

-   event
-   theatre
-   screen
-   date
-   time
-   seats
-   payment
-   booking ID
-   ticket
-   status

Where backend status supports it, use a visual timeline.

------------------------------------------------------------------------

## 22. Authentication

Redesign:

-   Login
-   Register
-   OTP
-   Forgot password
-   Reset password

Desktop:

`cinematic AI artwork | clean form`

Mobile:

`brand → form → cinematic accent`

Do not change authentication APIs or token/session behavior.

------------------------------------------------------------------------

## 23. Plays / Live / Events

Treat different content types appropriately.

### Movies

Poster-driven cinematic presentation.

### Live

Photography-heavy energetic cards.

### Plays

Editorial theatre aesthetic.

### Sports

More energetic imagery and metadata.

All remain within the Cinematic Gold system.

------------------------------------------------------------------------

## 24. Category pages

Create category-specific hero treatments.

Examples:

``` text
MOVIES
The stories everyone's talking about.

LIVE
Feel it. Don't stream it.

PLAYS
Stories beyond the screen.

SPORTS
Be there when it happens.
```

Only use routes/content supported by the application.

------------------------------------------------------------------------

## 25. Page transitions

Use visual continuity.

Example:

Movie poster on Home:

`poster → expands → becomes detail hero`

Event selection:

`detail → showtime → seat environment`

Booking:

`seat summary → payment → ticket`

Use 300--700ms transitions.

Do not block navigation.

------------------------------------------------------------------------

## 26. Poster hover

Desktop:

-   scale \~1.03--1.05
-   reveal CTA
-   subtle gold underline
-   metadata movement

Avoid excessive 3D rotation.

------------------------------------------------------------------------

## 27. Scroll

Use Lenis + GSAP ScrollTrigger where appropriate.

Effects:

-   section reveal
-   image parallax
-   clip-path
-   scale
-   stagger
-   pinned editorial moments

Keep scrolling intuitive.

------------------------------------------------------------------------

## 28. Custom cursor

Desktop only.

States:

`VIEW / EXPLORE / CLICK`

Use a small gold visual.

Disable on touch devices.

------------------------------------------------------------------------

## 29. Mobile

Design mobile intentionally.

Test:

-   390px
-   430px
-   768px
-   1024px
-   1280px
-   1440px

Seat selection must remain usable.

If 3D is too heavy on small devices:

-   reduce geometry
-   reduce effects
-   reduce camera motion
-   offer a clean 2D fallback

------------------------------------------------------------------------

## 30. Loading/error/empty states

Create polished states for:

-   events
-   search
-   showtimes
-   seats
-   booking
-   payment
-   confirmation
-   bookings
-   authentication

Examples:

``` text
WE LOST THE SIGNAL.

We couldn't load the showtimes.

[ Try Again ]
```

and:

``` text
NO SHOWS TONIGHT

Try another date or theatre.

[ Change Date ]
```

------------------------------------------------------------------------

## 31. Admin / management

If present, use a premium SaaS interface.

Potential areas:

-   dashboard
-   events
-   theatres
-   shows
-   seats
-   bookings
-   users
-   payments
-   analytics
-   notifications
-   settings

Prioritize clarity and data density over cinematic effects.

------------------------------------------------------------------------

## 32. Animation architecture

### Framer Motion

Use for:

-   cards
-   modals
-   drawers
-   tabs
-   lists
-   layout transitions
-   micro-interactions

### GSAP + ScrollTrigger

Use for:

-   hero
-   page choreography
-   scroll effects
-   parallax
-   complex transitions

### Lenis

Smooth desktop scrolling.

### React Three Fiber

Primarily for:

**3D auditorium / seat selection.**

Do not add Three.js to pages where it does not provide meaningful value.

------------------------------------------------------------------------

## 33. Performance

The 3D seat page must be optimized.

Use:

-   instancing where appropriate
-   compressed assets
-   lazy loading
-   code splitting
-   limited WebGL effects
-   proper cleanup
-   reduced effects on mobile
-   transform/opacity animations
-   no unnecessary re-renders

The site should remain responsive.

------------------------------------------------------------------------

## 34. Accessibility

Preserve:

-   keyboard navigation
-   focus states
-   semantic HTML
-   accessible buttons
-   ARIA labels
-   contrast
-   reduced motion

Respect:

`prefers-reduced-motion`

Disable heavy camera/parallax/cursor effects when requested.

------------------------------------------------------------------------

## 35. Implementation phases

### Phase 0 --- Repository audit

Map architecture, services, routes, APIs, state, assets and business
rules.

### Phase 1 --- Cinematic Gold design system

Fonts, colors, tokens, primitives.

### Phase 2 --- Global shell

Navbar, footer, transitions, loading/error patterns.

### Phase 3 --- Home/discovery

Hero, now showing, categories, trending.

### Phase 4 --- Search

### Phase 5 --- Event/movie detail

Details, dates, theatres, showtimes.

### Phase 6 --- 3D seat selection

Auditorium, seat states, backend locking, timer, summary.

### Phase 7 --- Payment

Real payment integration.

### Phase 8 --- Confirmation/tickets

QR, PDF, sharing.

### Phase 9 --- My bookings/details

### Phase 10 --- Authentication

### Phase 11 --- Plays/live/other content

### Phase 12 --- Admin/management if present

### Phase 13 --- Motion polish

### Phase 14 --- Mobile

### Phase 15 --- Performance/accessibility

### Phase 16 --- Full end-to-end QA

------------------------------------------------------------------------

## 36. Absolute rules

Do NOT:

-   rebuild backend services
-   change API contracts unnecessarily
-   invent endpoints
-   fake seat availability
-   fake seat locking
-   fake payment success
-   fake booking confirmation
-   fake ticket data
-   break authentication
-   remove existing routes
-   remove working business rules
-   delete unrelated work
-   add Three.js outside meaningful use cases
-   make every page equally flashy
-   sacrifice performance
-   sacrifice accessibility

### Final principle

`Real backend → real data → real booking logic → premium design → motion → performance`

The final result should feel like a **premium cinematic ticketing
product**, with the 3D seat-selection experience as its signature
interaction.
