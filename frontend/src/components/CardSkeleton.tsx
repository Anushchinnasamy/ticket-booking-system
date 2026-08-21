export function CardSkeleton() {
  return (
    <div className="flex w-[196px] flex-shrink-0 flex-col gap-2.5">
      <div className="h-[294px] w-[196px] animate-pulse rounded-2xl bg-surface" />
      <div className="h-3.5 w-3/4 animate-pulse rounded bg-surface" />
      <div className="h-3 w-1/2 animate-pulse rounded bg-surface" />
    </div>
  )
}
