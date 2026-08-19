CREATE TABLE waitlist (
    id UUID PRIMARY KEY,
    show_id UUID NOT NULL,
    user_id UUID NOT NULL,
    position BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'WAITING',
    created_at TIMESTAMPTZ NOT NULL,
    notified_at TIMESTAMPTZ
);

CREATE INDEX idx_waitlist_show_status_created ON waitlist (show_id, status, created_at);
CREATE INDEX idx_waitlist_show_user ON waitlist (show_id, user_id);
