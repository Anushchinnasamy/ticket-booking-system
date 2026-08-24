# CineTick --- Cinematic Gold Movie/Event Detail Page

## Master instruction

Build the Movie/Event Detail Page using the exact approved cinematic
composition. It must dynamically support movies, concerts, plays and
live events. The reference is visual direction only. All content comes
from the existing backend.

Never fabricate titles, ratings, booking counts, dates, venues,
showtimes, prices, availability, reviews or gallery assets.

## Structure

``` text
Global Navbar
↓
Cinematic Hero
↓
ABOUT | SHOWTIMES | REVIEWS | GALLERY
↓
Main Content
 ├─ Showtimes (~70%)
 └─ Information (~30%)
      ├─ About
      ├─ Highlights
      └─ Gallery
↓
Mobile Sticky Booking CTA
```

## Hero

Use a full cinematic backdrop with a dark left gradient, strong bottom
fade and subtle vignette.

Desktop:

``` text
[POSTER]   STATUS / RATING
           TITLE
           CATEGORY
           DATE · TIME · LOCATION
           DESCRIPTION
           [BOOK TICKETS] [WATCHLIST]        [RATING PANEL]
```

Poster: about 205--230px desktop, 2:3 ratio, 12--18px radius. If a real
trailer exists, show a `Watch Trailer` overlay.

Title uses large editorial serif. Category is gold uppercase. Metadata
adapts to actual fields: date, time, location, duration, language, age
rating.

Rating example: `★ 7.7 (15.1K booked)` only if those values exist.
Optional glass rating panel: rating, booking count, short sentiment text
only when supported.

Primary CTA: `BOOK TICKETS →`. Secondary: `♡ Add to Watchlist`. Hover
uses lift, restrained gold glow and arrow movement.

## Hero animation

``` text
black
→ backdrop fade/scale
→ poster
→ badge
→ title
→ metadata
→ description
→ CTA
→ rating panel
```

Use GSAP/Framer Motion where appropriate. Disable parallax on
mobile/reduced motion.

## Tabs

`ABOUT · SHOWTIMES · REVIEWS · GALLERY` Active tab: white text + gold
underline. Clicking scrolls to the corresponding section.

## Showtimes

Desktop 70/30 layout. Mobile one column.

Format filters must only show real supported formats,
e.g. `ALL FORMATS · 2D · 3D · IMAX`.

Date selector uses large cards:

``` text
MON 24 AUG
TUE 25 AUG
WED 26 AUG
```

Dates come from actual availability.

Venue card:

``` text
Logo
Venue name
City
Distance if available
Venue type if available
12:30 PM  2D
03:30 PM  2D
07:30 PM  2D
10:45 PM  2D
Details →
```

Showtime states: available, selected, sold out, unavailable, few seats.
Clicking an available show enters the real booking/seat-selection flow.

## Information panel

Show: - About - Duration - Language - Age Group - Highlights

Only render fields actually supported.

## Gallery

Three-thumbnail preview with `View All`. Clicking opens an accessible
full-screen lightbox with previous/next, ESC, keyboard navigation and
mobile swipe. No fabricated images.

## Reviews

If supported, show rating, count, review cards and rating distribution.
Otherwise hide or show an honest unavailable state.

## Mobile

Order:
`backdrop → poster → title → metadata → description → CTA → tabs → showtimes → information → gallery`

Use a sticky bottom `BOOK TICKETS` bar. Show price only when returned by
the backend.

## Loading/error

Use hero and venue skeletons. Error message:
`WE LOST THE SIGNAL. We couldn't load this event. [TRY AGAIN]` Never
expose raw API errors.

## Accessibility

Semantic headings, keyboard tabs/date/showtime controls, focus
management, alt text, modal focus trap, ESC close, contrast and reduced
motion.

## Final principle

``` text
real event → real venue → real date → real showtime → real availability → real seats → real booking
```

The frontend is a cinematic presentation layer around the real booking
system.
