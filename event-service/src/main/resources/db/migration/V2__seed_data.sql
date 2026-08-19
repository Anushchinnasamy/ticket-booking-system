-- Reference/demo catalog data: a handful of movies, one concert, one cricket
-- match, one comedy show — spanning small and large venues so later phases
-- (concurrency + load testing) have real shows to target. IDs are fixed so
-- they can be referenced directly from tests and docs.

INSERT INTO venues (id, name, city, address) VALUES
    ('11111111-1111-1111-1111-111111111101', 'PVR Forum Mall', 'Bengaluru', 'Forum Mall, Hosur Road, Koramangala'),
    ('11111111-1111-1111-1111-111111111102', 'INOX Garuda Mall', 'Bengaluru', 'Garuda Mall, Magrath Road'),
    ('11111111-1111-1111-1111-111111111103', 'Jawaharlal Nehru Indoor Stadium', 'Bengaluru', 'Kanteerava Sports Complex'),
    ('11111111-1111-1111-1111-111111111104', 'M. Chinnaswamy Stadium', 'Bengaluru', 'MG Road'),
    ('11111111-1111-1111-1111-111111111105', 'Canvas Laugh Club', 'Bengaluru', 'UB City Mall, Vittal Mallya Road');

INSERT INTO events (id, title, category, description) VALUES
    ('22222222-2222-2222-2222-222222222201', 'The Great Adventure', 'MOVIE', 'An action-packed journey across three continents.'),
    ('22222222-2222-2222-2222-222222222202', 'Neon Skyline', 'MOVIE', 'A neo-noir thriller set in a near-future megacity.'),
    ('22222222-2222-2222-2222-222222222203', 'Space Odyssey 2077', 'MOVIE', 'Humanity''s first contact, told in real time.'),
    ('22222222-2222-2222-2222-222222222204', 'Coldplay Live in Bengaluru', 'CONCERT', 'World tour stop featuring a full live band and stage production.'),
    ('22222222-2222-2222-2222-222222222205', 'India vs Australia - T20', 'SPORTS', 'Bilateral T20 series decider.'),
    ('22222222-2222-2222-2222-222222222206', 'Live Laugh Roast', 'COMEDY', 'An evening of stand-up and crowd work.');

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('33333333-3333-3333-3333-333333333301', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111101', '2026-09-01 10:00:00', 250.00),
    ('33333333-3333-3333-3333-333333333302', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111101', '2026-09-01 18:00:00', 250.00),
    ('33333333-3333-3333-3333-333333333303', '22222222-2222-2222-2222-222222222202', '11111111-1111-1111-1111-111111111102', '2026-09-02 19:00:00', 220.00),
    ('33333333-3333-3333-3333-333333333304', '22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111101', '2026-09-03 21:00:00', 280.00),
    ('33333333-3333-3333-3333-333333333305', '22222222-2222-2222-2222-222222222204', '11111111-1111-1111-1111-111111111103', '2026-09-15 19:30:00', 2500.00),
    ('33333333-3333-3333-3333-333333333306', '22222222-2222-2222-2222-222222222205', '11111111-1111-1111-1111-111111111104', '2026-09-20 14:00:00', 500.00),
    ('33333333-3333-3333-3333-333333333307', '22222222-2222-2222-2222-222222222206', '11111111-1111-1111-1111-111111111105', '2026-09-05 20:00:00', 400.00);

INSERT INTO seat_maps (id, show_id) VALUES
    ('44444444-4444-4444-4444-444444444401', '33333333-3333-3333-3333-333333333301'),
    ('44444444-4444-4444-4444-444444444402', '33333333-3333-3333-3333-333333333302'),
    ('44444444-4444-4444-4444-444444444403', '33333333-3333-3333-3333-333333333303'),
    ('44444444-4444-4444-4444-444444444404', '33333333-3333-3333-3333-333333333304'),
    ('44444444-4444-4444-4444-444444444405', '33333333-3333-3333-3333-333333333305'),
    ('44444444-4444-4444-4444-444444444406', '33333333-3333-3333-3333-333333333306'),
    ('44444444-4444-4444-4444-444444444407', '33333333-3333-3333-3333-333333333307');

-- The Great Adventure, 10:00 — 5 rows x 10 seats = 50 seats (deliberately
-- sized to match the 50-seat concurrency scenarios in Phases 2/3/12).
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444401', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;

-- The Great Adventure, 18:00 — same 5x10 layout, independent availability.
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444402', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;

-- Neon Skyline — 8 rows x 12 seats = 96 seats.
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444403', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 8) AS row_num, generate_series(1, 12) AS seat_num;

-- Space Odyssey 2077 — 6 rows x 10 seats = 60 seats.
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444404', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

-- Coldplay Live — 20 rows x 20 seats = 400 seats (mid-size venue).
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444405', row_num::text, seat_num,
       CASE WHEN row_num <= 3 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 3 THEN 2500.00 * 1.5 ELSE 2500.00 END,
       'AVAILABLE'
FROM generate_series(1, 20) AS row_num, generate_series(1, 20) AS seat_num;

-- India vs Australia T20 — 30 rows x 40 seats = 1200 seats (large venue,
-- for stress-testing at scale).
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444406', row_num::text, seat_num,
       CASE WHEN row_num <= 3 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 3 THEN 500.00 * 1.5 ELSE 500.00 END,
       'AVAILABLE'
FROM generate_series(1, 30) AS row_num, generate_series(1, 40) AS seat_num;

-- Live Laugh Roast — 10 rows x 10 seats = 100 seats (intimate club venue).
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '44444444-4444-4444-4444-444444444407', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 400.00 * 1.5 ELSE 400.00 END,
       'AVAILABLE'
FROM generate_series(1, 10) AS row_num, generate_series(1, 10) AS seat_num;
