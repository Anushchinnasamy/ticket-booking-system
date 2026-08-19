CREATE TABLE venues (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(120) NOT NULL,
    address VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE events (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE shows (
    id UUID PRIMARY KEY,
    event_id UUID NOT NULL REFERENCES events(id),
    venue_id UUID NOT NULL REFERENCES venues(id),
    start_time TIMESTAMP NOT NULL,
    base_price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_shows_event_id ON shows(event_id);
CREATE INDEX idx_shows_venue_id ON shows(venue_id);

CREATE TABLE seat_maps (
    id UUID PRIMARY KEY,
    show_id UUID NOT NULL UNIQUE REFERENCES shows(id),
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE seats (
    id UUID PRIMARY KEY,
    seat_map_id UUID NOT NULL REFERENCES seat_maps(id),
    row_label VARCHAR(5) NOT NULL,
    seat_number INT NOT NULL,
    seat_type VARCHAR(20) NOT NULL DEFAULT 'REGULAR',
    price NUMERIC(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    CONSTRAINT uq_seat_position UNIQUE (seat_map_id, row_label, seat_number)
);

CREATE INDEX idx_seats_seat_map_id ON seats(seat_map_id);
