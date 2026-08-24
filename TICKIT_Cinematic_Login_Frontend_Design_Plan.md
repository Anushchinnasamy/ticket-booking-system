# TICKIT Cinematic Login Page --- Frontend Design & Asset Plan

## 1. Design Vision

Transform the TICKIT login page from a standard authentication screen
into a premium cinematic entry experience.

### Core design language

-   **Theme:** Cinematic / Premium / Editorial / Event-ticketing
-   **Mood:** "You're about to enter an experience."
-   **Primary colors:** Black, charcoal, warm gold, cinematic blue
-   **Typography:** Elegant serif for hero headings + modern sans-serif
    for UI
-   **Visual style:** Dark glassmorphism, subtle gradients, atmospheric
    imagery, restrained motion
-   **Design goal:** The login page should feel like part of the same
    product as the event detail, showtimes, booking, and payment
    experiences.

------------------------------------------------------------------------

# 2. Desktop Layout

Use a split-screen composition.

``` text
┌──────────────────────────────────────────────────────────────┐
│  TICKIT                                      Theme Toggle     │
│                                                              │
│  ┌──────────────────────────────┐   ┌─────────────────────┐ │
│  │                              │   │                     │ │
│  │ LIVE MOMENTS.                │   │   Welcome Back      │ │
│  │ LASTING MEMORIES.            │   │                     │ │
│  │                              │   │   Email             │ │
│  │ Your Stage is                │   │   [_____________]   │ │
│  │ WAITING.                     │   │                     │ │
│  │                              │   │   Password          │ │
│  │ Description                  │   │   [_____________]   │ │
│  │                              │   │                     │ │
│  │ Exclusive Events             │   │   Forgot Password?  │ │
│  │ Secure Booking               │   │                     │ │
│  │ 24/7 Support                 │   │   [    LOGIN → ]    │ │
│  │                              │   │                     │ │
│  │      CINEMATIC IMAGE         │   │   or continue with  │ │
│  │                              │   │                     │ │
│  │                              │   │ [Google][Apple][FB]  │ │
│  └──────────────────────────────┘   └─────────────────────┘ │
│                                                              │
│  © TICKIT                    ● ○ ○ ○                        │
└──────────────────────────────────────────────────────────────┘
```

### Desktop proportions

-   Left cinematic panel: **52--55%**
-   Right authentication panel: **45--48%**
-   Login card width: **500--560px**
-   Card radius: **20--24px**
-   Card padding: **48--56px**
-   Full viewport height: `100vh`
-   Avoid unnecessary page scrolling.

------------------------------------------------------------------------

# 3. Left Cinematic Hero

The left side should feel like a movie opening sequence.

## Background

Use a full-height cinematic concert image.

Layer it like this:

``` text
Concert image
      ↓
Dark gradient
      ↓
Blue/black atmospheric overlay
      ↓
Subtle gold ambient glow
      ↓
Typography + feature content
```

The background must remain dark enough for readable text.

### Recommended visual characteristics

-   Night-time concert
-   Large stage
-   Atmospheric haze
-   Strong but controlled spotlights
-   Audience silhouettes
-   Cinematic depth
-   No visible brand logos
-   No distracting performer faces
-   No text embedded in the image

------------------------------------------------------------------------

# 4. Hero Typography

### Eyebrow

``` text
★ LIVE MOMENTS. LASTING MEMORIES.
```

Style:

-   Uppercase
-   Gold
-   Letter spacing: `0.15em–0.20em`
-   Small but visually strong

### Main heading

``` text
Your Stage is
WAITING.
```

Use a premium serif font such as:

-   Cormorant Garamond
-   Playfair Display
-   DM Serif Display

Make `WAITING.` gold.

### Supporting copy

Example:

``` text
Book tickets to the best concerts, events and
experiences around you.
```

Use muted white/gray.

------------------------------------------------------------------------

# 5. Feature Highlights

Create three compact cinematic feature rows.

## Exclusive Events

**Title:** Exclusive Events

**Description:** Access the hottest events before anyone else.

## Secure Booking

**Title:** Secure Booking

**Description:** 100% secure payments and instant confirmation.

## 24/7 Support

**Title:** 24/7 Support

**Description:** We're here to help you anytime, anywhere.

### Feature styling

Use subtle translucent surfaces:

``` css
background: rgba(255,255,255,0.035);
border: 1px solid rgba(255,255,255,0.06);
backdrop-filter: blur(12px);
```

Keep these elements understated.

------------------------------------------------------------------------

# 6. Right Login Card

The authentication card should use premium dark glassmorphism.

### Recommended styling

``` css
background: rgba(15, 15, 15, 0.72);
backdrop-filter: blur(24px);
border: 1px solid rgba(255,255,255,0.08);
border-radius: 24px;
```

Avoid an overly opaque black rectangle.

The cinematic background should subtly remain visible around the card.

------------------------------------------------------------------------

# 7. Login Hierarchy

## Heading

``` text
Welcome Back
```

Large serif heading.

## Subtitle

``` text
Login to continue to your account
```

Muted gray.

------------------------------------------------------------------------

# 8. Email Input

``` text
Email Address

┌──────────────────────────────────────┐
│ ✉  Enter your email                  │
└──────────────────────────────────────┘
```

### Default

``` css
background: rgba(255,255,255,0.035);
border: 1px solid rgba(255,255,255,0.10);
```

### Focus

``` css
border-color: #F5A623;
box-shadow: 0 0 0 3px rgba(245,166,35,0.10);
```

Use smooth transitions around `200–250ms`.

------------------------------------------------------------------------

# 9. Password Input

``` text
Password

┌──────────────────────────────────────┐
│ 🔒  Enter your password           ◉  │
└──────────────────────────────────────┘
```

Requirements:

-   Password visibility toggle
-   Clear focus state
-   Accessible label
-   Keyboard navigation
-   Password autocomplete
-   Error state

------------------------------------------------------------------------

# 10. Forgot Password

Place it below the password field and align it right.

``` text
Forgot Password?
```

Use the TICKIT gold accent.

Hover:

-   Slight brightness increase
-   No aggressive animation

------------------------------------------------------------------------

# 11. Login CTA

Primary button:

``` text
┌───────────────────────────────────────┐
│              Login                 → │
└───────────────────────────────────────┘
```

### Colors

``` text
Gold:
#F5A623

Light gold:
#FFB52E
```

### Effects

``` css
box-shadow: 0 8px 30px rgba(245,166,35,0.20);
```

### Hover

-   `translateY(-2px)`
-   Slight brightness increase
-   Arrow moves a few pixels right
-   Glow becomes slightly stronger

### Loading

Replace the label with:

``` text
◌ Signing you in...
```

Disable repeated submissions.

------------------------------------------------------------------------

# 12. Social Authentication

Create three premium secondary buttons:

``` text
[ Google ] [ Apple ] [ Facebook ]
```

Use:

-   Dark transparent surface
-   Subtle border
-   Official platform icon
-   Hover elevation
-   Keyboard focus state

On mobile, stack or use a responsive two-column arrangement.

------------------------------------------------------------------------

# 13. Sign-Up Prompt

Bottom of login card:

``` text
Don't have an account? Sign Up
```

Use gold for `Sign Up`.

------------------------------------------------------------------------

# 14. Theme Toggle

Place a small theme toggle in the top-right corner.

Recommended states:

-   Light mode icon
-   Dark mode icon

The dark mode should be the default.

The transition should be subtle rather than flashy.

------------------------------------------------------------------------

# 15. Cinematic Page Entrance

Use staggered entrance animation.

Recommended sequence:

``` text
0ms       Background image
300ms     TICKIT logo
500ms     Hero eyebrow
650ms     Main heading
850ms     Description
1000ms    Feature highlights
400ms     Login card
650ms     Form elements
```

### Background animation

Use a very slow scale effect:

``` css
transform: scale(1.00) → scale(1.04);
```

Duration:

``` text
20–30 seconds
```

The animation should be almost imperceptible.

------------------------------------------------------------------------

# 16. Hero Carousel

The bottom-left carousel indicator can become functional.

Example:

``` text
● ○ ○ ○
```

Suggested slides:

### Slide 1 --- Concerts

``` text
LIVE MOMENTS.
LASTING MEMORIES.

Your Stage is
WAITING.
```

### Slide 2 --- Sports

``` text
FEEL EVERY MOMENT.

The Game is
CALLING.
```

### Slide 3 --- Movies

``` text
EVERY STORY.
ONE EXPERIENCE.

Your Next
Movie Awaits.
```

### Slide 4 --- Experiences

``` text
MAKE IT
UNFORGETTABLE.

Your Next
Adventure Awaits.
```

Carousel transitions should use slow crossfades and subtle image
scaling.

------------------------------------------------------------------------

# 17. Responsive Design

## Desktop

``` text
55% cinematic hero
45% login
```

## Tablet

``` text
40% cinematic hero
60% login
```

## Mobile

Do not squeeze the desktop layout into a phone.

Use:

``` text
┌─────────────────────────┐
│ TICKIT                  │
│                         │
│ Cinematic hero          │
│      220–280px          │
│                         │
├─────────────────────────┤
│ Welcome Back            │
│                         │
│ Email                   │
│ [____________________]  │
│                         │
│ Password                │
│ [____________________]  │
│                         │
│ [       LOGIN       ]   │
│                         │
│ Google / Apple / FB      │
│                         │
│ Sign Up                 │
└─────────────────────────┘
```

Create a dedicated mobile image crop rather than relying entirely on
`object-fit: cover`.

------------------------------------------------------------------------

# 18. Required Login States

The frontend should support all of these states.

## Default

-   Empty form
-   Login enabled/disabled according to validation

## Focus

-   Gold input border
-   Accessible focus ring

## Validation error

``` text
Invalid email address
```

## Authentication error

``` text
Invalid email or password
```

## Network error

``` text
Connection failed.
Please try again.
```

## Loading

``` text
Signing you in...
```

## Success

``` text
✓ Welcome back
Taking you to TICKIT...
```

------------------------------------------------------------------------

# 19. Recommended Authentication Components

``` text
src/
│
├── pages/
│   └── Login.jsx
│
├── components/
│   └── auth/
│       ├── LoginHero.jsx
│       ├── LoginForm.jsx
│       ├── SocialLogin.jsx
│       ├── FeatureHighlights.jsx
│       ├── HeroCarousel.jsx
│       └── ThemeToggle.jsx
│
├── assets/
│   └── login/
│       ├── login-hero-concert.webp
│       ├── login-hero-mobile.webp
│       ├── login-event-slide-01.webp
│       └── login-event-slide-02.webp
│
├── hooks/
│   └── useAuth.js
│
└── styles/
    └── login.css
```

------------------------------------------------------------------------

# 20. Recommended Animation Stack

If the project already uses React:

### Framer Motion

Use for:

-   Page entrance
-   Staggered text
-   Card animation
-   Button interactions
-   Carousel transitions
-   Validation states
-   Authentication success transition

### Optional: Lenis

Use for the wider TICKIT website if smooth scrolling is required.

The login page itself should remain mostly viewport-based.

------------------------------------------------------------------------

# 21. Image Asset Plan

Only four primary raster assets are required.

  -----------------------------------------------------------------------------------
  \#                Filename                      Purpose           Recommended Size
  ----------------- ----------------------------- ----------------- -----------------
  01                `login-hero-concert.webp`     Desktop cinematic 1920×2160
                                                  background        

  02                `login-hero-mobile.webp`      Mobile cinematic  1080×900
                                                  background        

  03                `login-event-slide-01.webp`   Hero carousel     1200×1600
                                                  alternate         

  04                `login-event-slide-02.webp`   Hero carousel     1200×1600
                                                  alternate         
  -----------------------------------------------------------------------------------

Icons should preferably be SVG/icon-library assets rather than raster
images.

------------------------------------------------------------------------

# 22. Image 01 --- Main Concert Background

## Filename

``` text
login-hero-concert.webp
```

## Purpose

Primary desktop login hero background.

## Visual direction

A massive live concert at night with:

-   Large stage
-   Atmospheric haze
-   Cinematic blue-black environment
-   Warm stage lighting
-   Audience silhouettes
-   Strong depth
-   Subtle film-grain feel
-   No logos
-   No embedded text
-   No distracting recognizable performers

## Composition

Keep the left-center dark enough for:

``` text
LIVE MOMENTS.
LASTING MEMORIES.

Your Stage is
WAITING.
```

The brightest lights should generally sit toward the lower-middle/right
portion of the image.

------------------------------------------------------------------------

# 23. Image 02 --- Mobile Background

## Filename

``` text
login-hero-mobile.webp
```

## Purpose

Dedicated mobile hero crop.

## Composition

``` text
Dark sky
   ↓
Light beams
   ↓
Concert stage
   ↓
Audience silhouettes
```

Make the center visually strong while leaving enough dark negative space
for the TICKIT logo and hero text.

------------------------------------------------------------------------

# 24. Image 03 --- Carousel Concert Image

## Filename

``` text
login-event-slide-01.webp
```

## Visual

Premium live music event.

Use:

-   Deep blue shadows
-   Warm gold stage lighting
-   Haze
-   Audience silhouettes
-   Strong cinematic contrast

This should feel different enough from the primary background to justify
a carousel transition.

------------------------------------------------------------------------

# 25. Image 04 --- Alternate Experience Image

## Filename

``` text
login-event-slide-02.webp
```

## Visual

A premium event/experience scene.

Possible direction:

-   Large stadium under dramatic lighting
-   Crowd
-   Atmospheric environment
-   Cinematic composition
-   Dark editorial color treatment

Keep the same TICKIT visual identity.

------------------------------------------------------------------------

# 26. Image Generation Prompt --- Main Asset

Use this as the generation brief:

``` text
Ultra-premium cinematic photograph of a massive live concert at night,
huge stage in the distance, dramatic volumetric light beams, atmospheric
haze, deep midnight blue and black environment, warm amber stage lights,
large audience represented mostly as elegant silhouettes, cinematic depth,
subtle film grain, sophisticated editorial photography, luxury event
branding aesthetic, realistic photography, high dynamic range.

Composition must leave significant dark negative space in the left-center
for white and gold typography. The brightest stage lights should be
concentrated around the lower-middle and right side. No logos, no text,
no watermarks, no recognizable celebrity faces, no UI elements.

Premium Awwwards-style website hero image, dramatic but tasteful,
immersive, sophisticated, photorealistic.
```

------------------------------------------------------------------------

# 27. Image Generation Prompt --- Mobile Asset

``` text
Vertical cinematic photograph of a premium live concert at night,
dramatic concert stage, atmospheric haze, blue-black environment,
warm amber stage lighting, powerful but tasteful volumetric light beams,
audience silhouettes, sophisticated editorial photography,
photorealistic, luxury event aesthetic.

Composition optimized for a mobile website hero. Leave dark negative
space around the upper area for branding and typography. Strong visual
focus in the center and lower portion. No logos, no text, no watermarks,
no recognizable celebrity faces.

Premium cinematic Awwwards-style website imagery.
```

------------------------------------------------------------------------

# 28. Image Optimization

Use WebP.

Recommended targets:

-   Desktop hero: ideally `< 500 KB`
-   Mobile hero: ideally `< 300 KB`
-   Carousel images: ideally `< 350 KB`

Use responsive image loading.

Example:

``` jsx
<picture>
  <source
    media="(max-width: 768px)"
    srcSet="/assets/login/login-hero-mobile.webp"
  />

  <img
    src="/assets/login/login-hero-concert.webp"
    alt=""
  />
</picture>
```

Because the image is decorative, use an empty alt attribute when the
text conveys the meaningful content.

------------------------------------------------------------------------

# 29. Design Tokens

``` text
BACKGROUND
#050505

SURFACE
#0D0D0D

SURFACE 2
#151515

GOLD
#F5A623

GOLD LIGHT
#FFB52E

PRIMARY TEXT
#F5F3EF

SECONDARY TEXT
#A7A29A

BORDER
rgba(255,255,255,0.08)
```

### Typography

``` text
Display:
Cormorant Garamond / Playfair Display / DM Serif Display

UI:
Inter / Manrope
```

### Radius

``` text
Cards: 20–24px
Buttons: 12–14px
Inputs: 10–12px
```

------------------------------------------------------------------------

# 30. Authentication Transition

After successful authentication, avoid an instant route change.

Use a short cinematic transition:

``` text
LOGIN
  ↓
✓ AUTHENTICATED
  ↓
"Welcome back."
  ↓
background expands/fades
  ↓
TICKIT HOME
```

Target duration:

``` text
600–900ms
```

This can become a recognizable TICKIT interaction pattern across the
application.

------------------------------------------------------------------------

# 31. Accessibility

The premium visual design should not compromise usability.

Implement:

-   Proper `<label>` elements
-   Keyboard navigation
-   Visible focus states
-   Accessible password visibility button
-   `aria-label` for icon-only controls
-   Correct form semantics
-   Error messages associated with inputs
-   Sufficient text contrast
-   Reduced-motion support

Respect:

``` css
@media (prefers-reduced-motion: reduce)
```

and disable large entrance/scale animations when requested.

------------------------------------------------------------------------

# 32. Final Implementation Checklist

-   [ ] Build responsive split-screen layout
-   [ ] Add cinematic hero background
-   [ ] Add dark atmospheric overlays
-   [ ] Add TICKIT branding
-   [ ] Add serif editorial typography
-   [ ] Build feature highlights
-   [ ] Build glassmorphic login card
-   [ ] Build email input
-   [ ] Build password input
-   [ ] Add password visibility toggle
-   [ ] Add forgot-password interaction
-   [ ] Build gold login CTA
-   [ ] Add loading state
-   [ ] Add authentication error state
-   [ ] Add social login buttons
-   [ ] Add sign-up link
-   [ ] Add theme toggle
-   [ ] Add cinematic page entrance
-   [ ] Add hero carousel
-   [ ] Add responsive mobile layout
-   [ ] Add dedicated mobile hero image
-   [ ] Optimize WebP assets
-   [ ] Add accessibility
-   [ ] Add reduced-motion support
-   [ ] Add successful-login cinematic transition
-   [ ] Test desktop/tablet/mobile
-   [ ] Test keyboard navigation
-   [ ] Test authentication failure/loading/success states

------------------------------------------------------------------------

# 33. Target Result

The finished login page should feel closer to:

**Netflix × Apple × Awwwards × premium cinema/event booking**

rather than a conventional login form.

The visual priority should be:

``` text
1. Cinematic atmosphere
2. TICKIT brand
3. "Your Stage is WAITING."
4. Welcome Back
5. Login interaction
6. Supporting features
```

The authentication functionality should remain simple underneath the
visual layer. The cinematic design is there to make entering TICKIT feel
like the beginning of an event.
