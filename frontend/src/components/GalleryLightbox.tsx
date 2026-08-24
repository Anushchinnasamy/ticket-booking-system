import { useEffect, useRef } from 'react'

interface GalleryImage {
  src: string
  alt: string
}

interface GalleryLightboxProps {
  images: GalleryImage[]
  index: number
  onClose: () => void
  onNavigate: (index: number) => void
}

// Accessible modal: focus trap, ESC to close, arrow-key + swipe navigation.
// Built generically for N images even though most events today only have a
// single real asset (the poster) — nav controls simply hide when there's
// nothing to navigate to.
export function GalleryLightbox({ images, index, onClose, onNavigate }: GalleryLightboxProps) {
  const closeRef = useRef<HTMLButtonElement>(null)
  const touchStartX = useRef<number | null>(null)
  const hasMultiple = images.length > 1

  useEffect(() => {
    closeRef.current?.focus()

    function onKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') {
        onClose()
      } else if (e.key === 'ArrowRight' && hasMultiple) {
        onNavigate((index + 1) % images.length)
      } else if (e.key === 'ArrowLeft' && hasMultiple) {
        onNavigate((index - 1 + images.length) % images.length)
      } else if (e.key === 'Tab') {
        // Single focusable control (close button) — keep focus trapped on it.
        e.preventDefault()
        closeRef.current?.focus()
      }
    }

    document.addEventListener('keydown', onKeyDown)
    return () => document.removeEventListener('keydown', onKeyDown)
  }, [index, images.length, hasMultiple, onClose, onNavigate])

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-label="Gallery"
      className="fixed inset-0 z-50 flex flex-col items-center justify-center bg-obsidian/95 backdrop-blur-sm px-4"
      onClick={onClose}
      onTouchStart={(e) => {
        touchStartX.current = e.touches[0]?.clientX ?? null
      }}
      onTouchEnd={(e) => {
        if (touchStartX.current === null || !hasMultiple) return
        const delta = e.changedTouches[0].clientX - touchStartX.current
        if (delta > 50) onNavigate((index - 1 + images.length) % images.length)
        else if (delta < -50) onNavigate((index + 1) % images.length)
        touchStartX.current = null
      }}
    >
      <button
        ref={closeRef}
        onClick={onClose}
        aria-label="Close gallery"
        className="absolute right-4 top-4 flex h-10 w-10 cursor-pointer items-center justify-center rounded-full border border-border bg-surface/80 text-text-primary sm:right-6 sm:top-6"
      >
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round"><line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" /></svg>
      </button>

      {hasMultiple && (
        <button
          onClick={(e) => {
            e.stopPropagation()
            onNavigate((index - 1 + images.length) % images.length)
          }}
          aria-label="Previous image"
          className="absolute left-2 top-1/2 flex h-11 w-11 -translate-y-1/2 cursor-pointer items-center justify-center rounded-full border border-border bg-surface/80 text-text-primary sm:left-6"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
        </button>
      )}

      <img
        src={images[index].src}
        alt={images[index].alt}
        className="max-h-[80vh] max-w-full rounded-lg object-contain shadow-[0_30px_80px_rgba(0,0,0,0.6)]"
        onClick={(e) => e.stopPropagation()}
      />

      {hasMultiple && (
        <button
          onClick={(e) => {
            e.stopPropagation()
            onNavigate((index + 1) % images.length)
          }}
          aria-label="Next image"
          className="absolute right-2 top-1/2 flex h-11 w-11 -translate-y-1/2 cursor-pointer items-center justify-center rounded-full border border-border bg-surface/80 text-text-primary sm:right-6"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>
        </button>
      )}

      {hasMultiple && (
        <div className="mt-4 text-xs font-semibold text-text-muted">{index + 1} / {images.length}</div>
      )}
    </div>
  )
}
