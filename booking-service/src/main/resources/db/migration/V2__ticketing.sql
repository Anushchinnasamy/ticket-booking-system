CREATE TABLE tickets (
    id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    qr_payload TEXT NOT NULL,
    pdf_object_key VARCHAR(255) NOT NULL,
    share_token VARCHAR(64),
    share_token_expires_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    CONSTRAINT uq_tickets_booking_id UNIQUE (booking_id),
    CONSTRAINT uq_tickets_share_token UNIQUE (share_token)
);

CREATE INDEX idx_tickets_booking_id ON tickets(booking_id);
CREATE INDEX idx_tickets_share_token ON tickets(share_token);
