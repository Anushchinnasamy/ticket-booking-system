# CineTick --- Sports Arena / Cinematic Gold Addendum

## Purpose

This is an **additional module**, not a replacement for the Cinematic
Gold master plan.

``` text
CINEMATIC GOLD
├─ Movies
├─ Events / Plays
└─ Sports Arena
```

Sports gets a more energetic personality while retaining the same global
navigation, palette, typography, booking architecture and backend-first
rules.

## Sports Home

Approved composition:

``` text
Cinematic stadium hero
↓
LIVE SPORTS ARENA badge
↓
Feel the GAME LIVE
↓
Description
↓
BOOK SPORTS TICKETS →
↓
Sport category pills
↓
UPCOMING SPORTS EVENTS
↓
Event carousel
↓
Feature strip
```

## Hero

Use a full-width cinematic sports image. Preferred AI imagery is
photorealistic: cricket stadiums, football floodlights, tennis courts,
badminton arenas, racing tracks, athletes and crowds. No fake text/logos
or obvious AI artifacts.

Headline treatment: `Feel the` in cream/white and `GAME LIVE` in gold.

Badge: `🏆 LIVE SPORTS ARENA`

CTA: `BOOK SPORTS TICKETS →`

## Categories

Horizontal pills: `Cricket · Football · Tennis · Badminton · Other` but
map them to actual backend-supported categories.

Selected state: gold border + restrained glow.

## Upcoming Sports Events

Heading: `UPCOMING SPORTS EVENTS` with `View All →`.

Cards include only backend-supported: - sport - event name - date -
venue - city - availability - price - Book Now

Hover: image scale \~1.04, slight card lift, gold border transition and
CTA glow.

Availability states may include `BOOK NOW`, `FILLING FAST`,
`FEW TICKETS`, `SOLD OUT`, `COMING SOON` only when supported by real
data.

## Sports detail

Clicking an event enters the shared Cinematic Gold detail architecture.

Sports-specific hero:

``` text
CRICKET · FINAL
EVENT TITLE
DATE · TIME
VENUE
CITY
[BOOK TICKETS] [WATCHLIST]
```

Instead of cinema formats, use actual ticket categories such as:
`STANDARD · PREMIUM · VIP · HOSPITALITY` only when returned by the
backend.

## Match information

When supported:

``` text
Competition
Sport
Match
Date
Venue
City
```

## Team matchup

If backend provides teams:

``` text
TEAM A
  VS
TEAM B
```

Use actual team logos/assets. Never fabricate them.

## Sports booking

``` text
Sports Event
→ Date
→ Venue
→ Ticket Category
→ Seat Map
→ Seat Lock
→ Checkout
→ Payment
→ Digital Ticket
```

Backend remains authoritative for seat state and locking.

## Signature sports animation

Hero load:

``` text
dark stadium
→ stadium light sweep
→ hero reveal
→ badge
→ headline
→ CTA
```

Use restrained stadium bloom, haze, lens flare, particles and parallax.
Do not overdo effects.

## Feature strip

Potential visual strip:
`Live Matches | Premium Seats | Instant Booking | Sports Highlights`
Only include claims/features that are actually applicable.

## Responsive

Desktop: hero → category pills → 4-card carousel. Tablet: hero →
horizontal category scroll → 2-card layout. Mobile: hero → horizontal
categories → single-card carousel → vertical event list.

Mobile hero should be rebuilt for portrait rather than squeezed from
desktop.

## Image library

``` text
/public/images/ai/sports/
├─ hero/
├─ cricket/
├─ football/
├─ tennis/
├─ badminton/
├─ racing/
├─ stadiums/
└─ generic/
```

Use high-resolution realistic imagery.

## Shared design system

Sports retains:
`Obsidian · Cinema Black · Gold · Warm Gold · Cream · White · Muted Gray`

Its personality comes from sports photography, stadium lighting, match
information and energetic motion---not a completely different brand.

## Backend integrity

Never fabricate teams, matches, dates, venues, ticket categories,
prices, availability or seats.

## Final architecture

``` text
CINETICK
↓
CINEMATIC GOLD
├─ MOVIES
├─ EVENTS / PLAYS
└─ SPORTS ARENA
      ↓
Shared Event Detail
      ↓
Seat Selection
      ↓
Checkout
      ↓
Payment
      ↓
Confirmation
```
