CREATE TABLE payments (
    id UUID PRIMARY KEY,
    idempotency_key VARCHAR(255) NOT NULL,
    booking_id UUID NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'INR',
    status VARCHAR(20) NOT NULL DEFAULT 'INITIATED',
    razorpay_order_id VARCHAR(64),
    razorpay_payment_id VARCHAR(64),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT uq_payments_idempotency_key UNIQUE (idempotency_key)
);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);
