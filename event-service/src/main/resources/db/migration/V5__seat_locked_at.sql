-- Tracks when a seat was locked so the seat map can show an approximate
-- unlock time for seats held by someone else (the actual 5-minute hold TTL
-- lives in booking-service's Redis lock, out of this service's reach — this
-- is a best-effort mirror of that same moment, set alongside the LOCKED
-- transition, for display purposes only).
ALTER TABLE seats ADD COLUMN locked_at TIMESTAMP;
