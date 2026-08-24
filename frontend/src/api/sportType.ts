// event-service has no sport-subtype field — EventSummaryResponse only carries
// the coarse EventCategory ('SPORTS' covers every sport). The addendum's
// category pills (Cricket/Football/Tennis/Badminton/Other) are derived here by
// scanning each real event's own title+description for sport keywords — this
// classifies real fetched events, it does not invent events or data for them.
// Anything that doesn't match a known sport honestly falls into "Other"
// rather than being guessed at.
export type SportType = 'Cricket' | 'Football' | 'Tennis' | 'Badminton' | 'Other'

const KEYWORDS: [SportType, RegExp][] = [
  ['Cricket', /\b(cricket|t20|t-20|odi|ipl|test match|wicket|innings|bilateral series)\b/i],
  ['Football', /\b(football|soccer|premier league|fifa|isl|derby|\bfc\b)\b/i],
  ['Tennis', /\b(tennis|grand slam|wimbledon|\batp\b|\bwta\b)\b/i],
  ['Badminton', /\b(badminton|shuttlecock|\bbwf\b)\b/i],
]

export function inferSportType(title: string, description: string): SportType {
  const text = `${title} ${description}`
  for (const [sport, pattern] of KEYWORDS) {
    if (pattern.test(text)) return sport
  }
  return 'Other'
}
