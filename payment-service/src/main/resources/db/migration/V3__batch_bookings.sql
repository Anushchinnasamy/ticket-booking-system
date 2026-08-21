-- A single checkout now pays for N seats (N separate PENDING bookings) in one
-- Razorpay order — the frontend used to fire one charge per seat, which is
-- not what a real checkout should do. booking_id (singular) becomes
-- booking_ids (array): existing rows are migrated 1:1 into a one-element
-- array so no data is lost.

ALTER TABLE payments ADD COLUMN booking_ids UUID[];

UPDATE payments SET booking_ids = ARRAY[booking_id];

ALTER TABLE payments ALTER COLUMN booking_ids SET NOT NULL;

DROP INDEX IF EXISTS idx_payments_booking_id;
ALTER TABLE payments DROP COLUMN booking_id;

-- GIN index for the "= ANY(booking_ids)" containment lookups
-- (getPaymentForBooking / refundForBooking).
CREATE INDEX idx_payments_booking_ids ON payments USING GIN (booking_ids);
