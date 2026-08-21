-- Full catalog reset: real movies across Tamil/Hindi/English cinema,
-- spread across six Indian cities/states, replacing the single-city
-- three-movie demo dataset. Descriptions are original one-line blurbs,
-- not studio marketing copy. Deletes are ordered for FK safety.

DELETE FROM seats;
DELETE FROM seat_maps;
DELETE FROM shows;
DELETE FROM events;
DELETE FROM venues;

INSERT INTO venues (id, name, city, address) VALUES
    ('cd6a6882-cb7e-45b1-9d8e-7badd94c4a89', 'PVR Forum Mall', 'Bengaluru', 'Forum Mall, Hosur Road, Koramangala'),
    ('ace43b0f-7cad-4566-abfb-193ec525aca2', 'INOX Garuda Mall', 'Bengaluru', 'Garuda Mall, Magrath Road'),
    ('cb1499df-8aa5-4272-a81f-0eac2f16db6e', 'Sathyam Cinemas', 'Chennai', 'Thiru Vi Ka Road, Royapettah'),
    ('c0e29077-730f-48ea-b799-bc18b3194d8a', 'PVR Ampa Skywalk', 'Chennai', 'Aminjikarai'),
    ('977d0122-3a94-4c68-89d9-731b13482338', 'PVR Phoenix Palladium', 'Mumbai', 'Lower Parel'),
    ('7ae08e3e-7f61-4b6e-ae48-530e35a030ab', 'INOX R-City', 'Mumbai', 'Ghatkopar West'),
    ('65414607-374a-4b2d-bab0-b284a163f166', 'PVR Select Citywalk', 'Delhi', 'Saket'),
    ('b3fbdf48-ce8e-4d3c-a6e7-3970e4e0d8e5', 'INOX Nehru Place', 'Delhi', 'Nehru Place'),
    ('2db2f80b-ff3c-4a41-b8ec-8701e9cba12e', 'AMB Cinemas', 'Hyderabad', 'Gachibowli'),
    ('20f17447-a185-4b28-85fd-b9d6e7843d04', 'PVR Forum Sujana', 'Hyderabad', 'Kukatpally'),
    ('a98a0250-a92f-4c45-8ffb-1de4928aa778', 'INOX South City', 'Kolkata', 'Prince Anwar Shah Road'),
    ('19931e18-65d4-4b13-856e-30f2098f555d', 'PVR Avani', 'Kolkata', 'Salt Lake'),
    ('994f1dd4-b60f-4b23-81b8-88408b8d5bc4', 'Jawaharlal Nehru Indoor Stadium', 'Bengaluru', 'Kanteerava Sports Complex'),
    ('5eb97dfd-44ba-45e3-b9cd-d0a3c71413e8', 'M. Chinnaswamy Stadium', 'Bengaluru', 'MG Road'),
    ('6d69188c-e944-4e4f-ac0c-8706b41fead0', 'Canvas Laugh Club', 'Mumbai', 'Lower Parel');

INSERT INTO events (id, title, category, description) VALUES
    ('6e5c2896-5a0b-44d6-a077-31fe768c985c', 'Vikram', 'MOVIE', 'A special agent tracks a masked crew tied to an old case he thought was closed.'),
    ('9e28b331-8178-405e-a668-2a70bbaea547', 'Master', 'MOVIE', 'A hard-drinking professor clashes with a juvenile facility’s ruthless caretaker.'),
    ('4522289e-b321-4d77-8b31-8293921ad342', '96', 'MOVIE', 'Two former classmates spend one night retracing a love they never finished.'),
    ('3e0e6915-68e8-4b79-aa8b-de1a4a41891d', 'Jailer', 'MOVIE', 'A retired jailer returns to the underworld to find his son’s stolen idol.'),
    ('754fcef5-ec67-4fa7-841e-0c0eaf9aa12f', 'Leo', 'MOVIE', 'A quiet cafe owner’s buried past resurfaces when old enemies come looking.'),
    ('79f6432b-d29c-4afe-938a-3248c98c8e6a', 'Dangal', 'MOVIE', 'A former wrestler trains his daughters for a sport that never wanted them.'),
    ('126ce6e0-72d2-417e-857a-8b12d52d7f34', '3 Idiots', 'MOVIE', 'Two friends search for a college roommate who vanished after graduation.'),
    ('d566ff21-c7f9-47ea-8bb8-21579522672b', 'Gully Boy', 'MOVIE', 'A Mumbai street rapper finds his voice against the odds of where he’s from.'),
    ('95b5192f-85ef-41dd-a10d-ddaa3a3d84c2', 'Zindagi Na Milegi Dobara', 'MOVIE', 'Three friends confront old fears on one last road trip before a wedding.'),
    ('c4bccbca-b31c-46b4-b823-9ce7a189ed4d', 'Andhadhun', 'MOVIE', 'A blind pianist witnesses a murder he was never supposed to see.'),
    ('d755256f-ec76-46ab-84c6-549cdb1c8b01', 'Jurassic Park', 'MOVIE', 'A theme park of cloned dinosaurs goes wrong on opening weekend.'),
    ('d4dfebab-01a6-415a-8d4a-3725916a1f85', 'Blade Runner 2049', 'MOVIE', 'A neo-noir hunt through a rain-soaked megacity three decades on.'),
    ('eb7d5405-aa43-4da9-85ca-cbfa7504e9b2', 'Arrival', 'MOVIE', 'A linguist races to decode an alien language before the world panics.'),
    ('6e7130d4-7031-4274-867b-d781c838b0dd', 'Inception', 'MOVIE', 'A thief who steals secrets from dreams is offered one impossible job back.'),
    ('e8d1af82-3d20-41d2-bc89-bf468e407273', 'The Dark Knight', 'MOVIE', 'A vigilante and a district attorney take on a city’s newest, worst idea of chaos.'),
    ('551c0f0d-b8e2-4054-9c84-d64b85288671', 'Coldplay Live in Mumbai', 'CONCERT', 'World tour stop featuring a full live band and stage production.'),
    ('73fd9a65-1091-46d8-baa1-dc10e097a5d7', 'India vs Australia - T20', 'SPORTS', 'Bilateral T20 series decider.'),
    ('65af7874-98f6-4917-a601-a76070781544', 'Live Laugh Roast', 'COMEDY', 'An evening of stand-up and crowd work.');

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('0c86f39d-b7b8-4ade-ad4a-b47d6c90555b', '6e5c2896-5a0b-44d6-a077-31fe768c985c', 'cd6a6882-cb7e-45b1-9d8e-7badd94c4a89', '2026-09-04 13:30:00', 220.00),
    ('3aaf7af2-3028-4bf7-a5fb-56458e14471a', '6e5c2896-5a0b-44d6-a077-31fe768c985c', 'cb1499df-8aa5-4272-a81f-0eac2f16db6e', '2026-09-04 19:00:00', 240.00),
    ('e24e88d4-cdd1-46a8-9c87-0f80a350a82a', '9e28b331-8178-405e-a668-2a70bbaea547', 'ace43b0f-7cad-4566-abfb-193ec525aca2', '2026-09-05 13:30:00', 220.00),
    ('b040c31a-a34a-42ef-bdf7-9422f27da562', '9e28b331-8178-405e-a668-2a70bbaea547', 'c0e29077-730f-48ea-b799-bc18b3194d8a', '2026-09-05 19:00:00', 240.00),
    ('0514bc54-7b60-4772-a16c-047d9b8c50c2', '4522289e-b321-4d77-8b31-8293921ad342', 'cb1499df-8aa5-4272-a81f-0eac2f16db6e', '2026-09-06 13:30:00', 220.00),
    ('5b4a9c15-3daa-4aad-934f-04462df9f678', '4522289e-b321-4d77-8b31-8293921ad342', '977d0122-3a94-4c68-89d9-731b13482338', '2026-09-06 19:00:00', 240.00),
    ('16738ab6-7264-4f83-8b4e-73cab9eb5372', '3e0e6915-68e8-4b79-aa8b-de1a4a41891d', 'c0e29077-730f-48ea-b799-bc18b3194d8a', '2026-09-07 13:30:00', 220.00),
    ('512d4039-6269-490b-a393-5e0558f1c0de', '3e0e6915-68e8-4b79-aa8b-de1a4a41891d', '7ae08e3e-7f61-4b6e-ae48-530e35a030ab', '2026-09-07 19:00:00', 240.00),
    ('4dcf0584-5ae1-4b75-86e8-b40fa0b7ff8b', '754fcef5-ec67-4fa7-841e-0c0eaf9aa12f', '977d0122-3a94-4c68-89d9-731b13482338', '2026-09-08 13:30:00', 220.00),
    ('c12b32a9-eb92-480c-89c3-fb96343660f8', '754fcef5-ec67-4fa7-841e-0c0eaf9aa12f', '65414607-374a-4b2d-bab0-b284a163f166', '2026-09-08 19:00:00', 240.00),
    ('4b77174c-32b9-4ac7-8f84-88b51924a8b9', '79f6432b-d29c-4afe-938a-3248c98c8e6a', '7ae08e3e-7f61-4b6e-ae48-530e35a030ab', '2026-09-09 13:30:00', 240.00),
    ('4e32d70e-0ae4-4206-b9fc-630036f955d8', '79f6432b-d29c-4afe-938a-3248c98c8e6a', 'b3fbdf48-ce8e-4d3c-a6e7-3970e4e0d8e5', '2026-09-09 19:00:00', 260.00),
    ('c5ac2e9e-aaaa-46b2-b4f7-006ea1e91819', '126ce6e0-72d2-417e-857a-8b12d52d7f34', '65414607-374a-4b2d-bab0-b284a163f166', '2026-09-10 13:30:00', 240.00),
    ('108bfd66-9578-411c-b342-2f2eafdca047', '126ce6e0-72d2-417e-857a-8b12d52d7f34', '2db2f80b-ff3c-4a41-b8ec-8701e9cba12e', '2026-09-10 19:00:00', 260.00),
    ('5a19486f-f722-4f48-a356-60bca52f74a3', 'd566ff21-c7f9-47ea-8bb8-21579522672b', 'b3fbdf48-ce8e-4d3c-a6e7-3970e4e0d8e5', '2026-09-11 13:30:00', 240.00),
    ('164412fe-6122-4734-b4c0-1b5d37634977', 'd566ff21-c7f9-47ea-8bb8-21579522672b', '20f17447-a185-4b28-85fd-b9d6e7843d04', '2026-09-11 19:00:00', 260.00),
    ('f3591265-96ea-4ced-9941-ab80dbdf3d27', '95b5192f-85ef-41dd-a10d-ddaa3a3d84c2', '2db2f80b-ff3c-4a41-b8ec-8701e9cba12e', '2026-09-12 13:30:00', 240.00),
    ('56100f6a-4037-4698-8916-0cc121950821', '95b5192f-85ef-41dd-a10d-ddaa3a3d84c2', 'a98a0250-a92f-4c45-8ffb-1de4928aa778', '2026-09-12 19:00:00', 260.00),
    ('a01befba-4ff8-4590-94d0-8531d1226b85', 'c4bccbca-b31c-46b4-b823-9ce7a189ed4d', '20f17447-a185-4b28-85fd-b9d6e7843d04', '2026-09-13 13:30:00', 240.00),
    ('86fc75d0-7453-4a74-9d8d-aa72202415ee', 'c4bccbca-b31c-46b4-b823-9ce7a189ed4d', '19931e18-65d4-4b13-856e-30f2098f555d', '2026-09-13 19:00:00', 260.00),
    ('3560ba5f-a414-4dd9-aa70-83239ac5d5e2', 'd755256f-ec76-46ab-84c6-549cdb1c8b01', 'a98a0250-a92f-4c45-8ffb-1de4928aa778', '2026-09-14 13:30:00', 280.00),
    ('121484c3-213a-4c6b-ac97-74e3339e8b79', 'd755256f-ec76-46ab-84c6-549cdb1c8b01', 'cd6a6882-cb7e-45b1-9d8e-7badd94c4a89', '2026-09-14 19:00:00', 300.00),
    ('f43ff7a3-eeb9-4f64-8275-c6a72b49a39c', 'd4dfebab-01a6-415a-8d4a-3725916a1f85', '19931e18-65d4-4b13-856e-30f2098f555d', '2026-09-15 13:30:00', 280.00),
    ('4d8fe3f2-b9f7-4656-9198-7d63d22621ff', 'd4dfebab-01a6-415a-8d4a-3725916a1f85', 'ace43b0f-7cad-4566-abfb-193ec525aca2', '2026-09-15 19:00:00', 300.00),
    ('ecc7686b-28e5-461e-8b6c-1bae13b2f679', 'eb7d5405-aa43-4da9-85ca-cbfa7504e9b2', 'cd6a6882-cb7e-45b1-9d8e-7badd94c4a89', '2026-09-16 13:30:00', 280.00),
    ('3ec8fcc1-a1df-40cc-a4e8-17dbf1d0bdee', 'eb7d5405-aa43-4da9-85ca-cbfa7504e9b2', '977d0122-3a94-4c68-89d9-731b13482338', '2026-09-16 19:00:00', 300.00),
    ('7fc814ff-0988-40b3-a863-dae5134f5bb6', '6e7130d4-7031-4274-867b-d781c838b0dd', 'cb1499df-8aa5-4272-a81f-0eac2f16db6e', '2026-09-17 13:30:00', 280.00),
    ('2bd4df5e-d7e3-4b92-bd80-07a47b1f00b7', '6e7130d4-7031-4274-867b-d781c838b0dd', '65414607-374a-4b2d-bab0-b284a163f166', '2026-09-17 19:00:00', 300.00),
    ('d6d24a87-cc6e-45e2-89ea-2c92e68490b4', 'e8d1af82-3d20-41d2-bc89-bf468e407273', '7ae08e3e-7f61-4b6e-ae48-530e35a030ab', '2026-09-18 13:30:00', 280.00),
    ('245b82a9-8586-4b06-8239-90745b545fb5', 'e8d1af82-3d20-41d2-bc89-bf468e407273', '2db2f80b-ff3c-4a41-b8ec-8701e9cba12e', '2026-09-18 19:00:00', 300.00),
    ('144fb1d3-3167-4de1-a77e-34ebb8fdd755', '551c0f0d-b8e2-4054-9c84-d64b85288671', '994f1dd4-b60f-4b23-81b8-88408b8d5bc4', '2026-09-15 19:30:00', 2500.00),
    ('55665064-bf85-40e0-a37e-213e88b5fbec', '73fd9a65-1091-46d8-baa1-dc10e097a5d7', '5eb97dfd-44ba-45e3-b9cd-d0a3c71413e8', '2026-09-20 14:00:00', 500.00),
    ('1874d18c-a2e5-444e-92f2-1eaa5b762f27', '65af7874-98f6-4917-a601-a76070781544', '6d69188c-e944-4e4f-ac0c-8706b41fead0', '2026-09-05 20:00:00', 400.00);

INSERT INTO seat_maps (id, show_id) VALUES
    ('2f0f122b-4167-49b1-bab0-180cd3c8d844', '0c86f39d-b7b8-4ade-ad4a-b47d6c90555b'),
    ('af1dd85a-ab14-4e5a-9fb1-ad13b83036aa', '3aaf7af2-3028-4bf7-a5fb-56458e14471a'),
    ('ad8cda6e-fae5-49cf-b57e-d8fb8cbc3b6e', 'e24e88d4-cdd1-46a8-9c87-0f80a350a82a'),
    ('dde21159-eb26-496d-89f4-614d8673b605', 'b040c31a-a34a-42ef-bdf7-9422f27da562'),
    ('471be42c-5daf-419a-94ca-4fe4bc77106b', '0514bc54-7b60-4772-a16c-047d9b8c50c2'),
    ('1ef23d87-9672-478a-9685-bc7ebcbb26a0', '5b4a9c15-3daa-4aad-934f-04462df9f678'),
    ('f8bf7795-f0fe-4442-8dfd-41db0b52c5f3', '16738ab6-7264-4f83-8b4e-73cab9eb5372'),
    ('a2548ca4-6204-4fb6-9563-dfc54a4269e6', '512d4039-6269-490b-a393-5e0558f1c0de'),
    ('92d7e3ad-d973-4c90-968f-b0662d76dc16', '4dcf0584-5ae1-4b75-86e8-b40fa0b7ff8b'),
    ('e3fa203b-2b90-4994-9709-f744a740d8ad', 'c12b32a9-eb92-480c-89c3-fb96343660f8'),
    ('6feabee6-e80b-4f53-9618-efa737254bf6', '4b77174c-32b9-4ac7-8f84-88b51924a8b9'),
    ('8b336bac-582b-491e-a466-90da303b7d87', '4e32d70e-0ae4-4206-b9fc-630036f955d8'),
    ('76f90654-10d2-41f0-95bf-d18086871246', 'c5ac2e9e-aaaa-46b2-b4f7-006ea1e91819'),
    ('f5e59259-61df-4a90-8cdb-83fb956f21c9', '108bfd66-9578-411c-b342-2f2eafdca047'),
    ('9152216d-8aa6-42bb-afca-a4a219d44139', '5a19486f-f722-4f48-a356-60bca52f74a3'),
    ('0b702c0c-d3b5-4f89-a877-08b56f79a08c', '164412fe-6122-4734-b4c0-1b5d37634977'),
    ('d53670c1-ad5f-4e4b-8505-2ce076602534', 'f3591265-96ea-4ced-9941-ab80dbdf3d27'),
    ('1c69f2ec-f003-4ca9-9e0f-b3adceb81b66', '56100f6a-4037-4698-8916-0cc121950821'),
    ('362f7655-e883-40da-bddf-7d11ec234dbc', 'a01befba-4ff8-4590-94d0-8531d1226b85'),
    ('4f62ed61-08aa-4c77-9cf4-f8a6e3d0a7a1', '86fc75d0-7453-4a74-9d8d-aa72202415ee'),
    ('a321e17c-10de-4694-9ccb-25b1ada318f4', '3560ba5f-a414-4dd9-aa70-83239ac5d5e2'),
    ('55f2b523-eaaf-4280-8197-f8e1299bcb96', '121484c3-213a-4c6b-ac97-74e3339e8b79'),
    ('9e7d4c96-d3c7-4022-8faf-a5d78f5075f0', 'f43ff7a3-eeb9-4f64-8275-c6a72b49a39c'),
    ('904eb5f3-a634-48c7-92d0-31b8bb48ee31', '4d8fe3f2-b9f7-4656-9198-7d63d22621ff'),
    ('0c3a0c77-e034-4072-9687-167d507e0079', 'ecc7686b-28e5-461e-8b6c-1bae13b2f679'),
    ('3de8c58a-11f2-451a-820f-197bea9a37dc', '3ec8fcc1-a1df-40cc-a4e8-17dbf1d0bdee'),
    ('063402ba-2084-4322-bf80-5698b72b137d', '7fc814ff-0988-40b3-a863-dae5134f5bb6'),
    ('fa7a3032-5c2d-4f94-8918-3f00c49d613e', '2bd4df5e-d7e3-4b92-bd80-07a47b1f00b7'),
    ('395b152f-4bb3-44f5-adca-d8415354d607', 'd6d24a87-cc6e-45e2-89ea-2c92e68490b4'),
    ('10f1c7c1-71a7-42f1-9e3e-00405496ced9', '245b82a9-8586-4b06-8239-90745b545fb5'),
    ('389b7a17-beb8-4078-8239-cd308c2781d4', '144fb1d3-3167-4de1-a77e-34ebb8fdd755'),
    ('76fac22a-7e96-4f5e-86e1-c9e4905a903f', '55665064-bf85-40e0-a37e-213e88b5fbec'),
    ('47815479-66ef-47fc-8688-ad0b3f12031f', '1874d18c-a2e5-444e-92f2-1eaa5b762f27');

-- Seats: 2 premium rows (front, 1.5x) + the rest regular, per seat map.
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2f0f122b-4167-49b1-bab0-180cd3c8d844', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'af1dd85a-ab14-4e5a-9fb1-ad13b83036aa', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ad8cda6e-fae5-49cf-b57e-d8fb8cbc3b6e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dde21159-eb26-496d-89f4-614d8673b605', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '471be42c-5daf-419a-94ca-4fe4bc77106b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1ef23d87-9672-478a-9685-bc7ebcbb26a0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f8bf7795-f0fe-4442-8dfd-41db0b52c5f3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a2548ca4-6204-4fb6-9563-dfc54a4269e6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '92d7e3ad-d973-4c90-968f-b0662d76dc16', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e3fa203b-2b90-4994-9709-f744a740d8ad', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6feabee6-e80b-4f53-9618-efa737254bf6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8b336bac-582b-491e-a466-90da303b7d87', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '76f90654-10d2-41f0-95bf-d18086871246', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f5e59259-61df-4a90-8cdb-83fb956f21c9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9152216d-8aa6-42bb-afca-a4a219d44139', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0b702c0c-d3b5-4f89-a877-08b56f79a08c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd53670c1-ad5f-4e4b-8505-2ce076602534', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1c69f2ec-f003-4ca9-9e0f-b3adceb81b66', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '362f7655-e883-40da-bddf-7d11ec234dbc', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4f62ed61-08aa-4c77-9cf4-f8a6e3d0a7a1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a321e17c-10de-4694-9ccb-25b1ada318f4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '55f2b523-eaaf-4280-8197-f8e1299bcb96', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9e7d4c96-d3c7-4022-8faf-a5d78f5075f0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '904eb5f3-a634-48c7-92d0-31b8bb48ee31', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0c3a0c77-e034-4072-9687-167d507e0079', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3de8c58a-11f2-451a-820f-197bea9a37dc', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '063402ba-2084-4322-bf80-5698b72b137d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'fa7a3032-5c2d-4f94-8918-3f00c49d613e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '395b152f-4bb3-44f5-adca-d8415354d607', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '10f1c7c1-71a7-42f1-9e3e-00405496ced9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 6) AS row_num, generate_series(1, 10) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '389b7a17-beb8-4078-8239-cd308c2781d4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 2500.00 * 1.5 ELSE 2500.00 END,
       'AVAILABLE'
FROM generate_series(1, 20) AS row_num, generate_series(1, 20) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '76fac22a-7e96-4f5e-86e1-c9e4905a903f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 500.00 * 1.5 ELSE 500.00 END,
       'AVAILABLE'
FROM generate_series(1, 30) AS row_num, generate_series(1, 40) AS seat_num;

INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '47815479-66ef-47fc-8688-ad0b3f12031f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 400.00 * 1.5 ELSE 400.00 END,
       'AVAILABLE'
FROM generate_series(1, 10) AS row_num, generate_series(1, 10) AS seat_num;

