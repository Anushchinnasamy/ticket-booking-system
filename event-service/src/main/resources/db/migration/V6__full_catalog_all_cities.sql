-- Full catalog reset: 60 real movies (20 Tamil / 20 Hindi / 20 English),
-- each now playing in every one of six cities (not just two), plus the
-- existing concert/sports/comedy events. Replaces the V4 dataset.
-- Descriptions are original one-line blurbs, not studio marketing copy.

DELETE FROM seats;
DELETE FROM seat_maps;
DELETE FROM shows;
DELETE FROM events;
DELETE FROM venues;

INSERT INTO venues (id, name, city, address) VALUES
    ('8cdd338b-270e-48a6-b253-6f8fd3cd4207', 'PVR Forum Mall', 'Bengaluru', 'Forum Mall, Hosur Road, Koramangala'),
    ('dcc2f03b-0a69-4294-ac87-8de01ed92e4f', 'INOX Garuda Mall', 'Bengaluru', 'Garuda Mall, Magrath Road'),
    ('10a255e9-a08c-4f90-adaa-be28479e6277', 'Sathyam Cinemas', 'Chennai', 'Thiru Vi Ka Road, Royapettah'),
    ('181a0300-e532-46c5-a3f1-3639d28b0e65', 'PVR Ampa Skywalk', 'Chennai', 'Aminjikarai'),
    ('2482ef76-79e8-41c9-a2ab-100966e154a0', 'PVR Phoenix Palladium', 'Mumbai', 'Lower Parel'),
    ('7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', 'INOX R-City', 'Mumbai', 'Ghatkopar West'),
    ('647e1262-2396-4f57-bdc3-20038ed0d2de', 'PVR Select Citywalk', 'Delhi', 'Saket'),
    ('262daf03-b524-44bc-b66b-41b2b795dab7', 'INOX Nehru Place', 'Delhi', 'Nehru Place'),
    ('3d9862b5-7cc4-4468-8234-42139d3070c1', 'AMB Cinemas', 'Hyderabad', 'Gachibowli'),
    ('2b34010a-95a0-43d1-83a1-d153c8576f5e', 'PVR Forum Sujana', 'Hyderabad', 'Kukatpally'),
    ('36c0faf5-0acf-4cda-a02c-9e2556d837cc', 'INOX South City', 'Kolkata', 'Prince Anwar Shah Road'),
    ('7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', 'PVR Avani', 'Kolkata', 'Salt Lake'),
    ('46ef7472-8e28-4d57-b501-46a152a466e3', 'Jawaharlal Nehru Indoor Stadium', 'Bengaluru', 'Kanteerava Sports Complex'),
    ('0d4b3530-f934-4a8f-8831-ed5068bc7323', 'M. Chinnaswamy Stadium', 'Bengaluru', 'MG Road'),
    ('78e74a8c-f5f9-4a75-9fd2-f4b32d1aaa94', 'Canvas Laugh Club', 'Mumbai', 'Lower Parel');

INSERT INTO events (id, title, category, description) VALUES
    ('e7a7e3a0-7c14-4d5d-86c4-39907946edab', 'Vikram', 'MOVIE', 'A special agent tracks a masked crew tied to an old case he thought was closed.'),
    ('48d7214c-7da9-4f71-a659-c1ee84451654', 'Master', 'MOVIE', 'A hard-drinking professor clashes with a juvenile facility’s ruthless caretaker.'),
    ('f4bfec47-f17c-4184-95d8-f79dbd7c0621', '96', 'MOVIE', 'Two former classmates spend one night retracing a love they never finished.'),
    ('c2d36940-744f-4a8b-8648-91946f7fe9a0', 'Jailer', 'MOVIE', 'A retired jailer returns to the underworld to find his son’s stolen idol.'),
    ('cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', 'Leo', 'MOVIE', 'A quiet cafe owner’s buried past resurfaces when old enemies come looking.'),
    ('f665f571-996c-4a93-b70a-5c0e6334113d', 'Asuran', 'MOVIE', 'A farmer’s past violence catches up with his family across two timelines.'),
    ('f1b84483-37a3-4689-a10f-2600b68f45f7', 'Vikram Vedha', 'MOVIE', 'A cop hunting a gangster keeps hearing the same folk tale from him, retold.'),
    ('cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', 'Kaithi', 'MOVIE', 'A parolee is pulled into one impossible night moving a police unit under siege.'),
    ('e56a49ce-1a51-4480-b4d7-742beadc8c44', 'Soorarai Pottru', 'MOVIE', 'A small-town man fights entrenched interests to build a low-cost airline.'),
    ('faf015fa-3ea2-485c-92f8-ba64d3e05da7', 'Super Deluxe', 'MOVIE', 'Four intersecting stories collide across one very strange day.'),
    ('897a3aac-85b9-4eaa-9f95-c92c435e0cca', 'Pariyerum Perumal', 'MOVIE', 'A law student’s friendship crosses a line his town refuses to allow.'),
    ('61106637-39b7-4263-990d-c276e3da0052', 'Karnan', 'MOVIE', 'A village denied a bus stop finally pushes back against decades of neglect.'),
    ('7f62115c-e982-401f-81ff-df5b0f09ac43', 'Ponniyin Selvan: I', 'MOVIE', 'A young prince rides through a kingdom already quietly at war with itself.'),
    ('7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', 'Thunivu', 'MOVIE', 'A bank heist crew finds the vault hiding something far bigger than cash.'),
    ('73f0db77-b560-46d7-afd5-26865bdfb7cc', 'Viduthalai Part 1', 'MOVIE', 'A young constable posted to hunt an insurgent starts questioning the hunt.'),
    ('0b9d75e2-4dda-4441-be67-aa7e77c4a32c', 'Maanagaram', 'MOVIE', 'Strangers new to the city collide in one chain reaction gone very wrong.'),
    ('afb987b7-6a9e-42df-86bc-8e3d1f111395', 'Jigarthanda', 'MOVIE', 'A filmmaker researching a gangster for a script gets far too close to him.'),
    ('06043443-9121-4cfb-b4bc-8f9fdb60b114', 'Sarpatta Parambarai', 'MOVIE', 'A boxer chases a rival clan’s title against his family’s wishes.'),
    ('2debbb67-afc2-433b-abbb-2ac9c4b0b50f', 'Aadukalam', 'MOVIE', 'A rooster-fight handler’s rivalry with his mentor turns genuinely dangerous.'),
    ('f68e559e-1f24-4672-b46e-c772a7a20080', 'Anbe Sivam', 'MOVIE', 'Two mismatched travelers stranded together slowly wear down each other’s certainty.'),
    ('f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', 'Dangal', 'MOVIE', 'A former wrestler trains his daughters for a sport that never wanted them.'),
    ('02a698b4-9652-4d54-9808-60c405e829c6', '3 Idiots', 'MOVIE', 'Two friends search for a college roommate who vanished after graduation.'),
    ('e957699f-f6a3-445a-b28e-f8a3e799a38e', 'Gully Boy', 'MOVIE', 'A Mumbai street rapper finds his voice against the odds of where he’s from.'),
    ('963a80ac-8b0d-4077-aa5a-963d42ee19ab', 'Zindagi Na Milegi Dobara', 'MOVIE', 'Three friends confront old fears on one last road trip before a wedding.'),
    ('4879cdcf-20ad-4857-a353-39dc2612ff34', 'Andhadhun', 'MOVIE', 'A blind pianist witnesses a murder he was never supposed to see.'),
    ('18a7a273-a033-4718-8340-0054cdfb0150', 'Queen', 'MOVIE', 'Dumped days before her wedding, a woman takes the honeymoon alone.'),
    ('9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', 'Pink', 'MOVIE', 'Three women fight a case built entirely on what people assume about them.'),
    ('55b67cb3-f802-4321-878d-2858eb97ed10', 'Article 15', 'MOVIE', 'A transferred officer investigates a crime his new town wants buried.'),
    ('a7d69b75-a887-42b2-af0c-f410df30d3e6', 'Barfi!', 'MOVIE', 'A mute, deaf young man’s love story unfolds mostly without a word.'),
    ('0101c2d9-4989-4874-ae8c-93e76d400798', 'Rang De Basanti', 'MOVIE', 'A documentary shoot pulls a group of friends toward a real act of protest.'),
    ('d1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', 'Lagaan', 'MOVIE', 'Villagers wager their tax burden on a cricket match against their rulers.'),
    ('001d895f-0867-45e4-92c1-92f8d8a84985', 'Swades', 'MOVIE', 'A NASA engineer returns for his caretaker and finds a reason to stay.'),
    ('2831f48a-55c6-4942-8c6d-4019eed2db09', 'Taare Zameen Par', 'MOVIE', 'A struggling boy finally meets a teacher who asks what’s actually wrong.'),
    ('83d30ae3-9867-4f0a-9003-0869e9f4f09e', 'Gangs of Wasseypur', 'MOVIE', 'A coal-town feud between two families spans three generations of payback.'),
    ('c3f19534-af53-47fd-a52e-f573e12b4dda', 'Uri: The Surgical Strike', 'MOVIE', 'An army major plans a retaliatory strike across a hostile border.'),
    ('846233bb-e34f-4fca-a13b-a937fd09a003', 'Kabir Singh', 'MOVIE', 'A brilliant, self-destructive surgeon can’t let go of the one relationship that grounded him.'),
    ('4c312c36-1d24-417f-923a-53abcd042f27', 'Bajrangi Bhaijaan', 'MOVIE', 'A devout man tries to reunite a lost mute girl with her family across the border.'),
    ('869de4a3-c49b-4441-af57-e16d1d02a502', 'PK', 'MOVIE', 'A stranded alien’s blunt questions about faith unsettle everyone he meets.'),
    ('77f92a5b-774b-42c6-93d2-5898c09a5aeb', 'Drishyam', 'MOVIE', 'A father improvises to keep his family’s worst night from ever being proven.'),
    ('cf5b13dd-6311-4d05-9512-7085fd69121c', 'Piku', 'MOVIE', 'A daughter drives her impossible, hypochondriac father cross-country.'),
    ('47420d85-d25e-4750-8a37-20799ccd282e', 'Jurassic Park', 'MOVIE', 'A theme park of cloned dinosaurs goes wrong on opening weekend.'),
    ('2b26af3c-67b5-4992-811e-0c082ffcc244', 'Blade Runner 2049', 'MOVIE', 'A neo-noir hunt through a rain-soaked megacity three decades on.'),
    ('2efe4ca0-8186-4b74-b217-b33d708b3dc7', 'Arrival', 'MOVIE', 'A linguist races to decode an alien language before the world panics.'),
    ('208d58bc-e935-4e56-9a8b-15753775f52d', 'Inception', 'MOVIE', 'A thief who steals secrets from dreams is offered one impossible job back.'),
    ('ac847cbd-8c09-4d46-9d1f-12bbffec72d0', 'The Dark Knight', 'MOVIE', 'A vigilante and a district attorney take on a city’s newest, worst idea of chaos.'),
    ('6b49bd93-5693-42ab-990c-337e3364afe4', 'Interstellar', 'MOVIE', 'A pilot leaves his kids behind to find humanity a new home among the stars.'),
    ('422a4c83-0536-4540-993f-79dd4d7ff3ed', 'The Shawshank Redemption', 'MOVIE', 'A wrongly convicted banker plays a very long game inside a brutal prison.'),
    ('c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', 'Pulp Fiction', 'MOVIE', 'A handful of crooked lives in Los Angeles keep crossing at the worst moments.'),
    ('cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', 'Fight Club', 'MOVIE', 'An insomniac office worker’s underground club stops staying underground.'),
    ('6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', 'The Matrix', 'MOVIE', 'A hacker is offered a choice that ends everything he thought was real.'),
    ('a9f6b0af-162f-408e-85ac-a05edffb430c', 'Gladiator', 'MOVIE', 'A betrayed Roman general fights his way back from the arena floor.'),
    ('7dec8900-d4dd-4687-b4b9-352e2bb2a24a', 'Whiplash', 'MOVIE', 'A young drummer’s conservatory instructor pushes him past reasonable limits.'),
    ('5559423a-77ba-4850-b0cb-3ef28f73c91a', 'Parasite', 'MOVIE', 'A struggling family quietly, then not so quietly, infiltrates a wealthy household.'),
    ('fb501538-ba3d-40aa-b358-5d4c4eec5be2', 'Mad Max: Fury Road', 'MOVIE', 'A war-rig escape across the wasteland outruns an entire warlord’s army.'),
    ('4e29fa7d-edaa-4db4-862c-ea305dc7f99b', 'La La Land', 'MOVIE', 'An actress and a jazz pianist fall for each other while chasing different dreams.'),
    ('ddcb0971-df5f-4340-8f22-6552c13047f8', 'The Grand Budapest Hotel', 'MOVIE', 'A concierge and his lobby boy get tangled in a stolen painting and a will.'),
    ('d4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', 'Dunkirk', 'MOVIE', 'Stranded soldiers wait on an open beach for a rescue that may not come.'),
    ('ee1e185b-0345-42de-82b3-bc75b4784883', 'Oppenheimer', 'MOVIE', 'The physicist behind the bomb spends the rest of his life answering for it.'),
    ('e0ebad76-b916-419c-b8be-33037e6ad964', 'Dune', 'MOVIE', 'A duke’s heir is thrown into a desert planet’s war over its one resource.'),
    ('75d10a69-a03e-4045-acae-dc4e36109938', 'No Country for Old Men', 'MOVIE', 'A stray drug-deal payday puts one man ahead of an unstoppable killer.'),
    ('c5cf7263-8540-4ed7-a31e-0119e945ce9c', 'Coldplay Live in Mumbai', 'CONCERT', 'World tour stop featuring a full live band and stage production.'),
    ('6c9f2004-258b-4d35-a47e-55d8c9572b93', 'India vs Australia - T20', 'SPORTS', 'Bilateral T20 series decider.'),
    ('bd6b2043-56f7-40b2-a9e1-7d942d14326f', 'Live Laugh Roast', 'COMEDY', 'An evening of stand-up and crowd work.');

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('53b52784-1a87-4773-927d-4a5dd0ffd60e', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-03 13:30:00', 220.00),
    ('406d639b-f354-44b3-b85c-923020acbc3b', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-03 16:30:00', 225.00),
    ('f96a7560-ba77-4612-9fdf-6981a33d4c56', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-03 19:00:00', 230.00),
    ('5c48464a-6dc1-4037-916e-5a73277210de', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-03 22:00:00', 235.00),
    ('72c8a10c-30e9-4862-8a0d-47fb091295e9', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-03 10:30:00', 240.00),
    ('1faff0ef-a61d-4303-b6bc-95e1ab8a3d04', 'e7a7e3a0-7c14-4d5d-86c4-39907946edab', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-03 13:30:00', 245.00),
    ('8a591325-c58a-4099-960f-87653a883d15', '48d7214c-7da9-4f71-a659-c1ee84451654', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-04 16:30:00', 220.00),
    ('bdb9dd65-cd8b-4e1b-9d60-420c5e8ca3e3', '48d7214c-7da9-4f71-a659-c1ee84451654', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-04 19:00:00', 225.00),
    ('d6a4d80c-39b9-45e9-946c-80da6d64c4e9', '48d7214c-7da9-4f71-a659-c1ee84451654', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-04 22:00:00', 230.00),
    ('563dc184-aed4-47ea-982f-e4a33bf0245c', '48d7214c-7da9-4f71-a659-c1ee84451654', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-04 10:30:00', 235.00),
    ('d2986895-96d9-409c-8d4b-8f3b3f8dc7a2', '48d7214c-7da9-4f71-a659-c1ee84451654', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-04 13:30:00', 240.00),
    ('71a80b3d-f649-4dcb-8750-f0e34142e3b4', '48d7214c-7da9-4f71-a659-c1ee84451654', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-04 16:30:00', 245.00),
    ('1852fc48-3e38-41cb-8397-dbd72c133f50', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-05 19:00:00', 220.00),
    ('39f3418f-a78d-484c-ae8f-52c7025bba94', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-05 22:00:00', 225.00),
    ('45578344-e20e-46ed-8889-3c2f2ce00930', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-05 10:30:00', 230.00),
    ('8eb4a080-55f1-47cf-adcd-cbeb235f2091', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-05 13:30:00', 235.00),
    ('6bbd8851-1cc2-4f73-8eb9-7c817dc04b39', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-05 16:30:00', 240.00),
    ('cc745e62-125d-4b7e-aeb8-10af213a9f48', 'f4bfec47-f17c-4184-95d8-f79dbd7c0621', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-05 19:00:00', 245.00),
    ('8b8c219f-f751-4071-849c-b9dd64166f1c', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-06 22:00:00', 220.00),
    ('89d2e529-9524-46ca-be88-cd22c16ee09a', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-06 10:30:00', 225.00),
    ('be8f4e2b-6e75-46ff-8e80-b56b42d22adb', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-06 13:30:00', 230.00),
    ('bcb62f8b-8975-481c-88ce-09153d9575d8', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-06 16:30:00', 235.00),
    ('65e76080-1538-4b1e-a964-770a279963cf', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-06 19:00:00', 240.00),
    ('e07aa305-02da-44ee-9188-e5f1f86b8234', 'c2d36940-744f-4a8b-8648-91946f7fe9a0', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-06 22:00:00', 245.00),
    ('73948939-9b9a-46ac-890b-3b2f2078472c', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-07 10:30:00', 220.00),
    ('892ee61c-61e4-4e44-9d55-57805aa1c476', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-07 13:30:00', 225.00),
    ('3d5c62fb-c05a-4293-a54c-89bd1719478e', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-07 16:30:00', 230.00),
    ('19893640-7172-4730-a1f8-a9802ded6e0c', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-07 19:00:00', 235.00),
    ('226f41cb-22e9-4538-97fb-986760f6506f', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-07 22:00:00', 240.00),
    ('349aae42-a723-4ef5-aae9-be364b1376bf', 'cb4e2123-4198-445e-bc0a-7f0b2e69c5d4', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-07 10:30:00', 245.00),
    ('cebe5a89-7c00-4ce8-bdf0-dda77a0305b2', 'f665f571-996c-4a93-b70a-5c0e6334113d', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-08 13:30:00', 220.00),
    ('ac9525cc-9dcd-4dde-ad6a-bc57f9d0bba8', 'f665f571-996c-4a93-b70a-5c0e6334113d', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-08 16:30:00', 225.00),
    ('205e1f7d-f499-455e-b56e-2ecb6d3b7efc', 'f665f571-996c-4a93-b70a-5c0e6334113d', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-08 19:00:00', 230.00),
    ('7f4aa19d-58d0-4dd0-b6c7-2bf9249d2580', 'f665f571-996c-4a93-b70a-5c0e6334113d', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-08 22:00:00', 235.00),
    ('5d36cb6b-f467-400f-936e-8e92b80313ed', 'f665f571-996c-4a93-b70a-5c0e6334113d', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-08 10:30:00', 240.00),
    ('de29c36d-544d-4c0d-b4c5-4c4f54033631', 'f665f571-996c-4a93-b70a-5c0e6334113d', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-08 13:30:00', 245.00),
    ('6b858d5a-f6f7-438d-b893-c92a76b28572', 'f1b84483-37a3-4689-a10f-2600b68f45f7', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-09 16:30:00', 220.00),
    ('c8628894-663e-4087-947e-59d448675546', 'f1b84483-37a3-4689-a10f-2600b68f45f7', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-09 19:00:00', 225.00),
    ('582ba24e-6f4f-48d4-b460-0b6d6cdbbdf3', 'f1b84483-37a3-4689-a10f-2600b68f45f7', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-09 22:00:00', 230.00),
    ('772e8ef5-c253-41e6-9f21-d5203f8b9ce4', 'f1b84483-37a3-4689-a10f-2600b68f45f7', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-09 10:30:00', 235.00),
    ('34f28bd2-e8ea-42d2-a6dc-d95f410e5522', 'f1b84483-37a3-4689-a10f-2600b68f45f7', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-09 13:30:00', 240.00),
    ('fd6d0616-f251-4920-8774-90251303afea', 'f1b84483-37a3-4689-a10f-2600b68f45f7', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-09 16:30:00', 245.00),
    ('16b6c765-891c-4cef-9651-c924394f9137', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-10 19:00:00', 220.00),
    ('bb16873c-e29c-4f27-862c-ab91d4243f19', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-10 22:00:00', 225.00),
    ('162647af-02e4-4237-83dd-b6d01f4e2be2', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-10 10:30:00', 230.00),
    ('6da31a02-6d68-4d41-a598-00ead20f837c', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-10 13:30:00', 235.00),
    ('496a887e-ad6d-4282-8899-7023e799e85f', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-10 16:30:00', 240.00),
    ('ac5b3960-fa60-450b-bf2e-eeb1473cd0e5', 'cf03fcc2-a6bd-404a-86e3-86a4f93c9d19', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-10 19:00:00', 245.00),
    ('db811e94-20f9-4ec1-949f-13d22ab5c94d', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-11 22:00:00', 220.00),
    ('8c0ab2a0-8e90-4d04-92ae-f2492fc7ad63', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-11 10:30:00', 225.00),
    ('c345c931-7c66-4e73-ac28-adff3a52b119', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-11 13:30:00', 230.00),
    ('ebae542b-8fef-4e92-9f13-d849166241b8', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-11 16:30:00', 235.00),
    ('9815911f-18fb-4123-b7f9-f0e80b227df7', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-11 19:00:00', 240.00),
    ('0dea5b55-20b7-42be-a5a0-4b1b90f4a9a6', 'e56a49ce-1a51-4480-b4d7-742beadc8c44', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-11 22:00:00', 245.00),
    ('e871d157-2ff9-4e3e-a421-ba4599f2a8c1', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-12 10:30:00', 220.00),
    ('34001b5f-0972-448e-bb21-afb5790751e1', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-12 13:30:00', 225.00),
    ('b2ca5533-0077-4384-ad97-69c6740b0a84', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-12 16:30:00', 230.00),
    ('85c48aec-9339-4a5d-8a70-4b04fdeedeaa', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-12 19:00:00', 235.00),
    ('4c03f794-7121-47e2-8b57-fda7f4c9c3bb', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-12 22:00:00', 240.00),
    ('4b701d5e-10eb-4570-95ce-8ac30433d018', 'faf015fa-3ea2-485c-92f8-ba64d3e05da7', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-12 10:30:00', 245.00),
    ('ee9c8e0b-56f7-467d-9689-cf0098fca142', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-13 13:30:00', 220.00),
    ('10eda002-c1da-410f-ac8d-b772c8cd0284', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-13 16:30:00', 225.00),
    ('c7a7d106-1878-4aa0-b205-4335648da888', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-13 19:00:00', 230.00),
    ('64bbfe44-9698-4bc6-b2c3-c3b0ad26f0f0', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-13 22:00:00', 235.00),
    ('46700c09-b589-4344-83f5-0d56c9ab66a9', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-13 10:30:00', 240.00),
    ('75a9cf19-8167-4735-8fee-eeb85b19bfe8', '897a3aac-85b9-4eaa-9f95-c92c435e0cca', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-13 13:30:00', 245.00),
    ('6508ce58-8403-4807-9d06-16a0e3b8fc9f', '61106637-39b7-4263-990d-c276e3da0052', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-14 16:30:00', 220.00),
    ('fea6afb6-8ea5-40c6-84ed-9908bd1f0a8f', '61106637-39b7-4263-990d-c276e3da0052', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-14 19:00:00', 225.00),
    ('dad5e37f-8231-4a49-ab3c-0f8504d70354', '61106637-39b7-4263-990d-c276e3da0052', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-14 22:00:00', 230.00),
    ('6dcaf0bf-f2af-4f04-ac8e-1fe1ccde7c30', '61106637-39b7-4263-990d-c276e3da0052', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-14 10:30:00', 235.00),
    ('6de0d48f-b5a8-4965-bfaa-eb1c7a1793a6', '61106637-39b7-4263-990d-c276e3da0052', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-14 13:30:00', 240.00),
    ('c958141e-5472-4754-93ff-66cbcf179b7f', '61106637-39b7-4263-990d-c276e3da0052', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-14 16:30:00', 245.00),
    ('44f85778-f95b-40ce-b176-ccc5cd69ea9b', '7f62115c-e982-401f-81ff-df5b0f09ac43', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-15 19:00:00', 220.00),
    ('f22f364c-bf5b-46dd-81e2-ddabdc8f7630', '7f62115c-e982-401f-81ff-df5b0f09ac43', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-15 22:00:00', 225.00),
    ('7c7775ff-d4ec-4eb6-8eba-6ab571ac243d', '7f62115c-e982-401f-81ff-df5b0f09ac43', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-15 10:30:00', 230.00),
    ('dfddac62-d3c6-4c34-8af0-0037f0cfee4e', '7f62115c-e982-401f-81ff-df5b0f09ac43', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-15 13:30:00', 235.00),
    ('8f095789-0790-4d0d-ae8f-6bdc6b2e0179', '7f62115c-e982-401f-81ff-df5b0f09ac43', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-15 16:30:00', 240.00),
    ('fb5654f7-4b1d-4f8a-8bab-d767e98ae73c', '7f62115c-e982-401f-81ff-df5b0f09ac43', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-15 19:00:00', 245.00),
    ('583c5b10-8f7c-455f-91f5-90f0ee61195f', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-16 22:00:00', 220.00),
    ('c2f821ad-6a8e-487d-a6bc-16ecb495a544', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-16 10:30:00', 225.00),
    ('d87445d2-5e35-4459-8acf-8a13be2addd2', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-16 13:30:00', 230.00),
    ('cca75300-a442-4b65-a5b9-66c52af64067', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-16 16:30:00', 235.00),
    ('81eeb511-c221-4f77-a941-d49a547b784d', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-16 19:00:00', 240.00),
    ('16d4c3f1-1c42-41bc-ace2-48874d8b15e4', '7fafb100-fa54-4ab4-b2d7-98dad1fa89f5', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-16 22:00:00', 245.00),
    ('e4e11dd1-a31b-44c2-944b-9a46f1d43e3d', '73f0db77-b560-46d7-afd5-26865bdfb7cc', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-17 10:30:00', 220.00),
    ('45800de2-40dd-4bc0-937b-b8ecd970ec0f', '73f0db77-b560-46d7-afd5-26865bdfb7cc', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-17 13:30:00', 225.00),
    ('e186d50d-d9f6-4886-b636-a4dd1f26f450', '73f0db77-b560-46d7-afd5-26865bdfb7cc', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-17 16:30:00', 230.00),
    ('021e291b-ecec-4294-8604-fda4cf438c99', '73f0db77-b560-46d7-afd5-26865bdfb7cc', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-17 19:00:00', 235.00),
    ('896bc8d8-ed87-404e-aaa5-4d50e8b07fde', '73f0db77-b560-46d7-afd5-26865bdfb7cc', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-17 22:00:00', 240.00),
    ('b66d9880-04e9-44b4-ab41-456bcf62c7f0', '73f0db77-b560-46d7-afd5-26865bdfb7cc', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-17 10:30:00', 245.00),
    ('6edc74c8-7da7-4cb9-a8e4-63bff9cd0e02', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-18 13:30:00', 220.00),
    ('920ac48c-f4d2-4486-a14d-ec8b8b643e54', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-18 16:30:00', 225.00),
    ('b2579a46-8992-47aa-9324-03043fd452cd', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-18 19:00:00', 230.00),
    ('2648a5ee-ef3a-48cf-ab20-5ce3789c62ae', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-18 22:00:00', 235.00),
    ('1e958571-7c2c-4174-8176-6376ecaf9e3a', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-18 10:30:00', 240.00),
    ('057fb121-8450-4ae0-be04-fa6466d51e76', '0b9d75e2-4dda-4441-be67-aa7e77c4a32c', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-18 13:30:00', 245.00),
    ('0353f981-179b-4665-a398-2f13145c18ef', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-19 16:30:00', 220.00),
    ('d330b55c-6f4e-4183-a1bd-d2d28abdbc52', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-19 19:00:00', 225.00),
    ('7a55a192-54af-4612-9ccd-e3cf1e85584d', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-19 22:00:00', 230.00),
    ('6723f131-bff9-4eea-a5ed-72071aeee54c', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-19 10:30:00', 235.00);

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('578f6f0c-1573-42aa-810b-eeb5d59cbc79', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-19 13:30:00', 240.00),
    ('8a6d94b0-57cd-499b-b194-ddfff0c55f8f', 'afb987b7-6a9e-42df-86bc-8e3d1f111395', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-19 16:30:00', 245.00),
    ('da2b679e-da7e-453c-a52a-0f2fcc9440c2', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-20 19:00:00', 220.00),
    ('508e88c5-c9aa-4b7a-aa26-70072a9656a8', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-20 22:00:00', 225.00),
    ('1240b6a5-bf88-4903-baec-68871d0e05a9', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-20 10:30:00', 230.00),
    ('9a85d610-0829-4427-85cf-64a6ea7dc21a', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-20 13:30:00', 235.00),
    ('5c26e4fd-ecc0-4b64-8f52-ba9ee531a921', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-20 16:30:00', 240.00),
    ('e600954b-0c20-46c8-8793-c73aa079576a', '06043443-9121-4cfb-b4bc-8f9fdb60b114', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-20 19:00:00', 245.00),
    ('745b325a-ac90-4058-a61e-a425afdbdf1f', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-21 22:00:00', 220.00),
    ('1b5c361a-6cb8-4ba0-a5cc-99a9f84d921d', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-21 10:30:00', 225.00),
    ('b4898429-6691-4a7a-9a27-a2857d9dc3c5', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-21 13:30:00', 230.00),
    ('1f1e16b8-4ec6-41f7-890d-7d6e11cf9809', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-21 16:30:00', 235.00),
    ('0a03a905-6002-4699-9a8b-1923fea8a9d3', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-21 19:00:00', 240.00),
    ('3d3b81b5-e5c8-4f07-8dd3-1334090f492c', '2debbb67-afc2-433b-abbb-2ac9c4b0b50f', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-21 22:00:00', 245.00),
    ('7399ef02-c84b-4103-a01d-327180ec5e73', 'f68e559e-1f24-4672-b46e-c772a7a20080', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-02 10:30:00', 220.00),
    ('1f5acdc5-e9b1-4f23-b68a-77773bd62aff', 'f68e559e-1f24-4672-b46e-c772a7a20080', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-02 13:30:00', 225.00),
    ('1c74adf9-b118-4374-92c5-5c10301d7994', 'f68e559e-1f24-4672-b46e-c772a7a20080', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-02 16:30:00', 230.00),
    ('738b710b-1811-4bab-b932-ca8b036000f4', 'f68e559e-1f24-4672-b46e-c772a7a20080', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-02 19:00:00', 235.00),
    ('08e503b9-a09d-4686-b609-3b684ff72541', 'f68e559e-1f24-4672-b46e-c772a7a20080', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-02 22:00:00', 240.00),
    ('78321d41-b1e5-424e-9263-3abc55664b0c', 'f68e559e-1f24-4672-b46e-c772a7a20080', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-02 10:30:00', 245.00),
    ('b5e6f946-f85a-4a79-acba-5bdbaaec5d03', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-03 13:30:00', 240.00),
    ('2bc36edf-436d-47ac-a67f-a336c1307d28', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-03 16:30:00', 245.00),
    ('b546dff5-cbfa-4055-97e5-75d4d85a4264', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-03 19:00:00', 250.00),
    ('1d47e3af-c5ec-4f59-8f20-4b16296b709f', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-03 22:00:00', 255.00),
    ('394a077e-8a5d-471b-a47c-24183b25f407', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-03 10:30:00', 260.00),
    ('8280fb54-306a-4683-bf68-f6f1401fa967', 'f9ed55e9-465c-4e35-88cd-9d5dc5d650ed', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-03 13:30:00', 265.00),
    ('a2c6259f-6506-4fa9-b4e8-f99bec6ebeb5', '02a698b4-9652-4d54-9808-60c405e829c6', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-04 16:30:00', 240.00),
    ('63695a92-7ad3-42bd-bca1-594920fbd177', '02a698b4-9652-4d54-9808-60c405e829c6', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-04 19:00:00', 245.00),
    ('67415565-1a0b-4fd1-a005-91d20fa99e9b', '02a698b4-9652-4d54-9808-60c405e829c6', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-04 22:00:00', 250.00),
    ('84864256-9103-4369-9cd7-09e1073e5477', '02a698b4-9652-4d54-9808-60c405e829c6', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-04 10:30:00', 255.00),
    ('94318b2a-0b41-4523-925c-1752b9dd653c', '02a698b4-9652-4d54-9808-60c405e829c6', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-04 13:30:00', 260.00),
    ('3a092c71-206b-4f92-ae49-0a469b63b973', '02a698b4-9652-4d54-9808-60c405e829c6', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-04 16:30:00', 265.00),
    ('13fd43d3-6886-447a-a4a5-ba4f30150a10', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-05 19:00:00', 240.00),
    ('754b0008-8e9b-4aa7-9e21-8043f6180940', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-05 22:00:00', 245.00),
    ('d049a8e4-bab9-4bf6-ac62-33f4bd5d7e22', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-05 10:30:00', 250.00),
    ('e9fd7d45-b240-4dfb-90aa-d5bd0810a2f3', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-05 13:30:00', 255.00),
    ('41c2c993-059c-49c6-965b-68f4311f39c5', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-05 16:30:00', 260.00),
    ('8806bccd-ece7-4755-8fbc-93119a719bf1', 'e957699f-f6a3-445a-b28e-f8a3e799a38e', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-05 19:00:00', 265.00),
    ('44526225-087d-4f8e-b637-d1ea9c7159a0', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-06 22:00:00', 240.00),
    ('6c4d1b12-fe2e-4724-b113-7b271687b859', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-06 10:30:00', 245.00),
    ('4cdb5585-b4d2-4c9a-92cd-a033295b13cb', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-06 13:30:00', 250.00),
    ('d58b44f3-b949-473d-8640-ab2621a2f238', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-06 16:30:00', 255.00),
    ('68dbb420-737c-4d5b-95e8-f2f5ffab9cb6', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-06 19:00:00', 260.00),
    ('a5e78a81-b24d-4e2d-9728-6f7437a9b502', '963a80ac-8b0d-4077-aa5a-963d42ee19ab', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-06 22:00:00', 265.00),
    ('c196c000-5e42-4056-84dd-d85337bc4207', '4879cdcf-20ad-4857-a353-39dc2612ff34', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-07 10:30:00', 240.00),
    ('aab09a3a-3546-4879-bf96-56b6c1bc97d5', '4879cdcf-20ad-4857-a353-39dc2612ff34', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-07 13:30:00', 245.00),
    ('3fa47fc3-63ea-4d3f-9555-f2233e118c82', '4879cdcf-20ad-4857-a353-39dc2612ff34', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-07 16:30:00', 250.00),
    ('784b2f4b-5c75-4e3b-ac20-08306aca7418', '4879cdcf-20ad-4857-a353-39dc2612ff34', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-07 19:00:00', 255.00),
    ('42ab0bed-d76f-449b-80f2-986653a69713', '4879cdcf-20ad-4857-a353-39dc2612ff34', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-07 22:00:00', 260.00),
    ('b7b71d81-0654-4692-95fc-7ca53aa9b85b', '4879cdcf-20ad-4857-a353-39dc2612ff34', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-07 10:30:00', 265.00),
    ('ec01b65e-e1f7-48f3-81c3-d9f0618b22b1', '18a7a273-a033-4718-8340-0054cdfb0150', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-08 13:30:00', 240.00),
    ('70700615-46e7-4fa9-a977-8722e06aac04', '18a7a273-a033-4718-8340-0054cdfb0150', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-08 16:30:00', 245.00),
    ('23a05690-003b-4f50-b6dc-59df1afdf490', '18a7a273-a033-4718-8340-0054cdfb0150', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-08 19:00:00', 250.00),
    ('05864fbe-6d0d-4b0a-99c7-426382d2efae', '18a7a273-a033-4718-8340-0054cdfb0150', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-08 22:00:00', 255.00),
    ('a9ac3b49-a0c7-4a71-9a1e-752729487caf', '18a7a273-a033-4718-8340-0054cdfb0150', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-08 10:30:00', 260.00),
    ('d1d4fe7f-38bc-4969-8af3-b5153d5af35d', '18a7a273-a033-4718-8340-0054cdfb0150', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-08 13:30:00', 265.00),
    ('8f776643-7277-4221-a8d8-bfb2a6b42b2b', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-09 16:30:00', 240.00),
    ('2b213698-3887-4b0f-b865-0bf769b34dc4', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-09 19:00:00', 245.00),
    ('b03bd4fc-eb98-4658-8df0-7b2ae0daf22c', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-09 22:00:00', 250.00),
    ('f3755a76-439d-427b-8937-b676b7d3f5a7', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-09 10:30:00', 255.00),
    ('71d2aa93-3510-419d-9e68-4609542f7158', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-09 13:30:00', 260.00),
    ('8340d648-594f-48b2-8a99-a748fc563ae4', '9cb8aa85-0b85-47fd-bee2-8b3fa594ec85', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-09 16:30:00', 265.00),
    ('7c9e1a8b-87c7-4640-8fe0-f17923b5ad91', '55b67cb3-f802-4321-878d-2858eb97ed10', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-10 19:00:00', 240.00),
    ('ddd7ba61-66ec-489a-8fb6-112b3a223040', '55b67cb3-f802-4321-878d-2858eb97ed10', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-10 22:00:00', 245.00),
    ('931617f8-1d6d-4266-8957-b50c6e85078e', '55b67cb3-f802-4321-878d-2858eb97ed10', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-10 10:30:00', 250.00),
    ('aaf96e74-7daa-4e7f-9e6b-b80aa138e066', '55b67cb3-f802-4321-878d-2858eb97ed10', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-10 13:30:00', 255.00),
    ('8935c4b8-4e29-45ae-bfa0-9a60aa4d9aed', '55b67cb3-f802-4321-878d-2858eb97ed10', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-10 16:30:00', 260.00),
    ('37dfb8c4-35a0-4807-8b9b-b92e975d8ca3', '55b67cb3-f802-4321-878d-2858eb97ed10', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-10 19:00:00', 265.00),
    ('54f31026-f5fc-4b0f-a9cd-09bb245297bf', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-11 22:00:00', 240.00),
    ('a54a332d-315d-4fa7-ba09-bc29fc0adb5e', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-11 10:30:00', 245.00),
    ('90f6a519-6dc6-41a8-9aa0-fb4bac4e5047', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-11 13:30:00', 250.00),
    ('bd772d04-f107-4f05-89a7-8025d33febac', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-11 16:30:00', 255.00),
    ('0772b269-e49e-4758-8eae-bcfd740e1225', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-11 19:00:00', 260.00),
    ('4439c5b3-b643-4330-ae2a-c7624c18a8fb', 'a7d69b75-a887-42b2-af0c-f410df30d3e6', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-11 22:00:00', 265.00),
    ('1270ccb7-ad60-4d88-a056-5b379e51d3c2', '0101c2d9-4989-4874-ae8c-93e76d400798', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-12 10:30:00', 240.00),
    ('2eb61a26-9247-47ab-938c-8cc59012a4ba', '0101c2d9-4989-4874-ae8c-93e76d400798', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-12 13:30:00', 245.00),
    ('33432701-32f8-4df9-b1a1-3996ea5438ee', '0101c2d9-4989-4874-ae8c-93e76d400798', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-12 16:30:00', 250.00),
    ('cb743fdb-5301-466c-ab65-97e2633c1fcd', '0101c2d9-4989-4874-ae8c-93e76d400798', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-12 19:00:00', 255.00),
    ('5a7cf8bd-617a-4f01-8ea2-b91d1f03d3ca', '0101c2d9-4989-4874-ae8c-93e76d400798', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-12 22:00:00', 260.00),
    ('7d990b28-6415-4b92-9e7d-599e8964619d', '0101c2d9-4989-4874-ae8c-93e76d400798', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-12 10:30:00', 265.00),
    ('b3fc9403-d78f-4835-831c-756e4464538f', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-13 13:30:00', 240.00),
    ('7e8d9e80-017e-4c05-9a92-2a3e1326d3f5', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-13 16:30:00', 245.00),
    ('9dcfe9c5-57c9-4996-9c6b-603d61317182', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-13 19:00:00', 250.00),
    ('43373f1a-969a-428d-bf5e-5ff6d97a7591', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-13 22:00:00', 255.00),
    ('4acd9910-5440-4131-a463-e8867f1d3bf1', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-13 10:30:00', 260.00),
    ('be099808-a45b-43d8-a24a-4b76306e7cf0', 'd1c7ddce-4a4e-4f35-9b0c-4b3d055cc447', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-13 13:30:00', 265.00),
    ('25ce0755-d0a3-482b-8fe4-0aa6e7392e8b', '001d895f-0867-45e4-92c1-92f8d8a84985', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-14 16:30:00', 240.00),
    ('0a744181-c29a-406d-a3df-31ca311eab3c', '001d895f-0867-45e4-92c1-92f8d8a84985', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-14 19:00:00', 245.00),
    ('93139ba2-aaa0-47d1-8db1-e317448252c7', '001d895f-0867-45e4-92c1-92f8d8a84985', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-14 22:00:00', 250.00),
    ('36f921ba-d604-445b-9e20-55ca64dc6330', '001d895f-0867-45e4-92c1-92f8d8a84985', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-14 10:30:00', 255.00),
    ('d3ef3199-f187-4673-99f5-7f9ef311ee1d', '001d895f-0867-45e4-92c1-92f8d8a84985', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-14 13:30:00', 260.00),
    ('c467446a-5341-48a3-bdd7-e2c7569ffde1', '001d895f-0867-45e4-92c1-92f8d8a84985', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-14 16:30:00', 265.00),
    ('422dd618-b8f9-4f85-a0d9-f032bc6cb87c', '2831f48a-55c6-4942-8c6d-4019eed2db09', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-15 19:00:00', 240.00),
    ('92b4b990-979a-442e-8a81-058fecb3fcf7', '2831f48a-55c6-4942-8c6d-4019eed2db09', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-15 22:00:00', 245.00),
    ('dd97e191-e802-4535-9d72-c3dbabb57d33', '2831f48a-55c6-4942-8c6d-4019eed2db09', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-15 10:30:00', 250.00),
    ('bb277756-8e01-4fef-9beb-f1c2d0b39427', '2831f48a-55c6-4942-8c6d-4019eed2db09', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-15 13:30:00', 255.00),
    ('1ddedb07-2455-4ab4-bde8-38ee26e1a65a', '2831f48a-55c6-4942-8c6d-4019eed2db09', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-15 16:30:00', 260.00),
    ('89cf0f7e-e7e9-4887-b871-f9a65fc79ec8', '2831f48a-55c6-4942-8c6d-4019eed2db09', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-15 19:00:00', 265.00),
    ('8f8ad9df-5a3d-4950-b89c-439b0d52ac92', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-16 22:00:00', 240.00),
    ('3e29a6f3-e1ae-4ac1-8605-8210fe2b1834', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-16 10:30:00', 245.00);

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('bcdb8094-b163-40a1-9396-30c4cca03479', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-16 13:30:00', 250.00),
    ('30926db3-88b0-49e9-afdb-81d8ccc778e2', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-16 16:30:00', 255.00),
    ('e7108ce1-65b5-405b-87c4-40a1566e5caa', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-16 19:00:00', 260.00),
    ('c90b1db8-2132-41aa-bd08-6506fa1a333b', '83d30ae3-9867-4f0a-9003-0869e9f4f09e', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-16 22:00:00', 265.00),
    ('b51529ab-95b4-428f-aed1-3ed5500e1ae3', 'c3f19534-af53-47fd-a52e-f573e12b4dda', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-17 10:30:00', 240.00),
    ('7bb662a6-ba7b-4abd-9d89-af06a18bdf1b', 'c3f19534-af53-47fd-a52e-f573e12b4dda', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-17 13:30:00', 245.00),
    ('aeb2798e-06f8-4b92-b1cb-687da07f49b6', 'c3f19534-af53-47fd-a52e-f573e12b4dda', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-17 16:30:00', 250.00),
    ('fc622849-cb78-4daa-9312-5d668a21895b', 'c3f19534-af53-47fd-a52e-f573e12b4dda', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-17 19:00:00', 255.00),
    ('47414b85-2105-41c6-9414-55c4cd8e3fef', 'c3f19534-af53-47fd-a52e-f573e12b4dda', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-17 22:00:00', 260.00),
    ('b767fba2-2b53-4b6c-a6fd-473e93a5d0bd', 'c3f19534-af53-47fd-a52e-f573e12b4dda', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-17 10:30:00', 265.00),
    ('f049b318-55c6-43c5-a1e9-707196fe479a', '846233bb-e34f-4fca-a13b-a937fd09a003', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-18 13:30:00', 240.00),
    ('adba4bb3-a2cb-4b8d-a9ff-580dd9256f2d', '846233bb-e34f-4fca-a13b-a937fd09a003', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-18 16:30:00', 245.00),
    ('17ec66ba-c16b-45f4-830c-99bb7ba07f72', '846233bb-e34f-4fca-a13b-a937fd09a003', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-18 19:00:00', 250.00),
    ('692c01b9-70f0-4c58-9516-6090c89ecd52', '846233bb-e34f-4fca-a13b-a937fd09a003', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-18 22:00:00', 255.00),
    ('83d9d133-bc51-43a9-bf30-f80aee752fd1', '846233bb-e34f-4fca-a13b-a937fd09a003', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-18 10:30:00', 260.00),
    ('65ae6de8-8291-4b5e-9329-ad72ec3d5c84', '846233bb-e34f-4fca-a13b-a937fd09a003', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-18 13:30:00', 265.00),
    ('525bd4fa-2a36-479b-be3e-22989ccbdfcc', '4c312c36-1d24-417f-923a-53abcd042f27', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-19 16:30:00', 240.00),
    ('98d4c132-fd9c-4c77-a26d-8833c2fecd87', '4c312c36-1d24-417f-923a-53abcd042f27', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-19 19:00:00', 245.00),
    ('38011823-8e5c-47ac-b16c-d11d0a7dd222', '4c312c36-1d24-417f-923a-53abcd042f27', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-19 22:00:00', 250.00),
    ('f3380112-ae90-4af0-a579-1a4bf35184da', '4c312c36-1d24-417f-923a-53abcd042f27', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-19 10:30:00', 255.00),
    ('7ba06232-c1fd-4359-bbb9-ef497908ae74', '4c312c36-1d24-417f-923a-53abcd042f27', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-19 13:30:00', 260.00),
    ('054ee07a-f836-4c88-bec5-4b70b12c8921', '4c312c36-1d24-417f-923a-53abcd042f27', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-19 16:30:00', 265.00),
    ('5e27e7bd-ae97-4fec-88a7-ac824c9ca0f9', '869de4a3-c49b-4441-af57-e16d1d02a502', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-20 19:00:00', 240.00),
    ('1c01098f-3875-4613-ad58-af436046dd85', '869de4a3-c49b-4441-af57-e16d1d02a502', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-20 22:00:00', 245.00),
    ('f218e844-71f4-43ae-a58e-2dddb6eaa334', '869de4a3-c49b-4441-af57-e16d1d02a502', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-20 10:30:00', 250.00),
    ('02392a98-f5bc-4048-865c-970b2ca6a90c', '869de4a3-c49b-4441-af57-e16d1d02a502', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-20 13:30:00', 255.00),
    ('907cbf09-2f21-4b39-bccd-f6268c8cddda', '869de4a3-c49b-4441-af57-e16d1d02a502', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-20 16:30:00', 260.00),
    ('5ed8c6cc-850b-43a3-985f-940ba273acfc', '869de4a3-c49b-4441-af57-e16d1d02a502', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-20 19:00:00', 265.00),
    ('81fe731a-bb62-44fa-a1c4-3186892f81de', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-21 22:00:00', 240.00),
    ('31074eb9-42f6-45d3-9388-fb3e998b2819', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-21 10:30:00', 245.00),
    ('a5516fee-c114-47eb-9586-80b933ea7410', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-21 13:30:00', 250.00),
    ('5108b3c5-d3d1-4a1c-b410-1460dcee90af', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-21 16:30:00', 255.00),
    ('8bb3e23c-d2de-4594-95c5-1ba12161510d', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-21 19:00:00', 260.00),
    ('85529ec2-50ec-4b41-8323-25a0a7d998a3', '77f92a5b-774b-42c6-93d2-5898c09a5aeb', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-21 22:00:00', 265.00),
    ('5fdf7c87-cd42-48b5-99bf-6956e1e9437b', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-02 10:30:00', 240.00),
    ('8963b285-a357-4965-9ce8-471d39e3d6c7', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-02 13:30:00', 245.00),
    ('fe25dcac-0a6d-41b2-9a20-ce4eda08b1c1', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-02 16:30:00', 250.00),
    ('d7b956f1-9d59-4d58-8739-5b5064ff42c4', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-02 19:00:00', 255.00),
    ('cc74108e-a470-40b3-baea-97e6ff8df188', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-02 22:00:00', 260.00),
    ('05ae3deb-d5a7-440e-9189-4906eb9f3ce0', 'cf5b13dd-6311-4d05-9512-7085fd69121c', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-02 10:30:00', 265.00),
    ('01a37005-505a-4a8a-93d7-9d25626f701c', '47420d85-d25e-4750-8a37-20799ccd282e', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-03 13:30:00', 280.00),
    ('0b1cd35b-f1cb-447c-ae1b-bd732edc643f', '47420d85-d25e-4750-8a37-20799ccd282e', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-03 16:30:00', 285.00),
    ('45cc7907-14e7-4751-9118-ff98b60345d1', '47420d85-d25e-4750-8a37-20799ccd282e', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-03 19:00:00', 290.00),
    ('b0227c03-1196-40d2-bfe0-70830162748a', '47420d85-d25e-4750-8a37-20799ccd282e', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-03 22:00:00', 295.00),
    ('f702f47e-8c3d-4476-81c3-34e5bd538984', '47420d85-d25e-4750-8a37-20799ccd282e', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-03 10:30:00', 300.00),
    ('4b69742b-8778-48d1-bcfa-4888dda6ba62', '47420d85-d25e-4750-8a37-20799ccd282e', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-03 13:30:00', 305.00),
    ('9196184d-43a0-4bb0-83a1-abbead352470', '2b26af3c-67b5-4992-811e-0c082ffcc244', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-04 16:30:00', 280.00),
    ('33792da7-0873-4cd8-8074-cadd5d480d42', '2b26af3c-67b5-4992-811e-0c082ffcc244', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-04 19:00:00', 285.00),
    ('bf81a3d1-d7a2-47ae-b278-923e1b9eabcf', '2b26af3c-67b5-4992-811e-0c082ffcc244', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-04 22:00:00', 290.00),
    ('f6a87683-2a8c-402b-90b0-1144e55a7f2d', '2b26af3c-67b5-4992-811e-0c082ffcc244', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-04 10:30:00', 295.00),
    ('b6d1c4d8-27e3-49d6-91f3-e77e7512ec04', '2b26af3c-67b5-4992-811e-0c082ffcc244', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-04 13:30:00', 300.00),
    ('78616cd3-d736-444d-810d-c32b83343ad3', '2b26af3c-67b5-4992-811e-0c082ffcc244', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-04 16:30:00', 305.00),
    ('cd3b9b19-1480-433e-b543-13c440a5440a', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-05 19:00:00', 280.00),
    ('9585ef48-16b8-4302-91a8-3cd3a1fdc8f7', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-05 22:00:00', 285.00),
    ('189f074a-fe73-416c-9a2b-12809e785dcb', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-05 10:30:00', 290.00),
    ('18731704-3c49-4b8f-ab10-4cb493983255', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-05 13:30:00', 295.00),
    ('8557271b-b9cf-4b2a-90c4-f7f4efafadb5', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-05 16:30:00', 300.00),
    ('d7b3a66b-e2ca-49fc-8bc2-ae027efe9f76', '2efe4ca0-8186-4b74-b217-b33d708b3dc7', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-05 19:00:00', 305.00),
    ('0573e441-a680-48f2-b4d3-920ca4098559', '208d58bc-e935-4e56-9a8b-15753775f52d', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-06 22:00:00', 280.00),
    ('2a95d87e-c06f-4a2d-a5b0-7a112b095934', '208d58bc-e935-4e56-9a8b-15753775f52d', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-06 10:30:00', 285.00),
    ('b94b2808-4306-4bf9-9e9f-94555c1b5745', '208d58bc-e935-4e56-9a8b-15753775f52d', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-06 13:30:00', 290.00),
    ('bf3cf3ca-6114-404c-8ead-0bd6efd70445', '208d58bc-e935-4e56-9a8b-15753775f52d', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-06 16:30:00', 295.00),
    ('c54009e4-d3c1-4dcb-9e20-f52b1606d85a', '208d58bc-e935-4e56-9a8b-15753775f52d', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-06 19:00:00', 300.00),
    ('8645827c-c0c4-4dd3-a6cf-b5d49125e0f7', '208d58bc-e935-4e56-9a8b-15753775f52d', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-06 22:00:00', 305.00),
    ('c37fc906-aa21-424a-8611-f4124ca14a53', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-07 10:30:00', 280.00),
    ('584b423a-5016-4954-8c03-7981d62c3090', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-07 13:30:00', 285.00),
    ('2dcf5db7-0cb9-4286-ac4f-c16c375818ed', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-07 16:30:00', 290.00),
    ('20a664ad-a4da-4339-8775-b6cfd1801633', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-07 19:00:00', 295.00),
    ('604d3da1-08ee-493b-8fbc-bc890da3721d', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-07 22:00:00', 300.00),
    ('3c925e15-87e6-4b16-9a75-ab887eaa3398', 'ac847cbd-8c09-4d46-9d1f-12bbffec72d0', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-07 10:30:00', 305.00),
    ('33e08e6e-4506-47ae-8757-df9b0dd5d148', '6b49bd93-5693-42ab-990c-337e3364afe4', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-08 13:30:00', 280.00),
    ('d7fa4054-99a3-4453-85c0-1e05ee74c2c4', '6b49bd93-5693-42ab-990c-337e3364afe4', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-08 16:30:00', 285.00),
    ('a29ddc13-5971-4863-a517-dc8c4d45ff0d', '6b49bd93-5693-42ab-990c-337e3364afe4', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-08 19:00:00', 290.00),
    ('12e94338-c6d5-49dd-9b0d-2f4f5a5b4e6c', '6b49bd93-5693-42ab-990c-337e3364afe4', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-08 22:00:00', 295.00),
    ('7540836c-2255-4daa-bdf6-2b8b1a449f95', '6b49bd93-5693-42ab-990c-337e3364afe4', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-08 10:30:00', 300.00),
    ('6ee5ca8d-9a5d-4432-8eed-0804fd0e8419', '6b49bd93-5693-42ab-990c-337e3364afe4', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-08 13:30:00', 305.00),
    ('3b2b6be7-2754-4415-9718-84b1c70867cf', '422a4c83-0536-4540-993f-79dd4d7ff3ed', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-09 16:30:00', 280.00),
    ('5f831565-d558-423a-b7cf-1b167832df33', '422a4c83-0536-4540-993f-79dd4d7ff3ed', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-09 19:00:00', 285.00),
    ('0b4967c8-3e4c-4062-b4aa-a4c84c1abcdd', '422a4c83-0536-4540-993f-79dd4d7ff3ed', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-09 22:00:00', 290.00),
    ('57c69b42-33ea-418c-a765-5169b8128097', '422a4c83-0536-4540-993f-79dd4d7ff3ed', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-09 10:30:00', 295.00),
    ('4761d14f-6f4d-44d9-96a8-20547e377442', '422a4c83-0536-4540-993f-79dd4d7ff3ed', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-09 13:30:00', 300.00),
    ('9e6c4eed-ed75-45f9-a60d-d31737054980', '422a4c83-0536-4540-993f-79dd4d7ff3ed', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-09 16:30:00', 305.00),
    ('6c57b5bc-b31e-4663-851a-438a2b0185b7', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-10 19:00:00', 280.00),
    ('b87b5ec0-558a-464b-9925-ecb02a4b6344', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-10 22:00:00', 285.00),
    ('a36e1e5b-9ab3-4276-8f7f-acde04baed79', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-10 10:30:00', 290.00),
    ('836d1ded-3280-4f87-b8ee-2226a4747117', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-10 13:30:00', 295.00),
    ('41e74007-becf-4a3d-8125-5df8d4a3c664', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-10 16:30:00', 300.00),
    ('c4cac9d5-052f-4bd2-afdc-2948fcf6ee4c', 'c4eb543a-65e5-4d6b-b2b9-34e45c7bc02d', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-10 19:00:00', 305.00),
    ('3d38664c-8ca7-4061-814e-f498c71541e2', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-11 22:00:00', 280.00),
    ('0226f048-716a-46a9-9e24-7709cd929bb1', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-11 10:30:00', 285.00),
    ('2a08cbaa-5a28-4522-bef2-56178f7369be', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-11 13:30:00', 290.00),
    ('1a897387-73b0-44d6-aef1-ef670b6afd5e', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-11 16:30:00', 295.00),
    ('0a0a5ac1-0555-48e9-b38d-e892f5bff5e3', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-11 19:00:00', 300.00),
    ('bff081c5-4fd8-4d27-8f3d-772416a6d862', 'cf5e6a59-d2d7-42b7-9418-18b0d54e8b6f', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-11 22:00:00', 305.00),
    ('c8c1520c-b62a-4b0a-ae4c-35cee10475b1', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-12 10:30:00', 280.00),
    ('8540ebe3-af15-4652-8d72-e663bed3b98a', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-12 13:30:00', 285.00),
    ('2fd9b509-c59a-4c21-af4c-482a3087b76a', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-12 16:30:00', 290.00),
    ('b842be0d-e87c-40ac-8f0b-ea20318688c0', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-12 19:00:00', 295.00),
    ('27087ed1-100f-4cc0-b85f-b0ab2b6be361', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-12 22:00:00', 300.00),
    ('40deea6d-7aa2-455d-ad91-08df28c512b0', '6c0e6359-b588-40fc-a43e-e7b6b49b2a0c', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-12 10:30:00', 305.00);

INSERT INTO shows (id, event_id, venue_id, start_time, base_price) VALUES
    ('b9287047-c1bc-4854-b3b1-e16d5a1d541e', 'a9f6b0af-162f-408e-85ac-a05edffb430c', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-13 13:30:00', 280.00),
    ('1909d607-8c57-4198-ad2d-3874a23b8b8c', 'a9f6b0af-162f-408e-85ac-a05edffb430c', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-13 16:30:00', 285.00),
    ('5c0b8db5-22bb-4ae2-83b1-959138677c39', 'a9f6b0af-162f-408e-85ac-a05edffb430c', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-13 19:00:00', 290.00),
    ('b6e41097-9684-4521-90b0-84648cfb84b2', 'a9f6b0af-162f-408e-85ac-a05edffb430c', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-13 22:00:00', 295.00),
    ('da7dce16-3193-4748-a1e0-40e560e28b4c', 'a9f6b0af-162f-408e-85ac-a05edffb430c', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-13 10:30:00', 300.00),
    ('32b7d95d-0b67-4835-a7f9-faff4efb5b16', 'a9f6b0af-162f-408e-85ac-a05edffb430c', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-13 13:30:00', 305.00),
    ('5e35f5fb-6d5e-48f6-972b-2ed4e8a47b52', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-14 16:30:00', 280.00),
    ('cc1134ba-8d28-4f5b-8c31-0a21cecca792', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-14 19:00:00', 285.00),
    ('acdd9885-7807-4c6d-8035-f721af69ed98', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-14 22:00:00', 290.00),
    ('22d947b7-8df2-4eca-bc48-8bf974dd5099', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-14 10:30:00', 295.00),
    ('b9003bf4-f057-4768-bedc-c1fdf7b8fef2', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-14 13:30:00', 300.00),
    ('6b1c6704-be5e-45b1-be5a-ab9431809bbe', '7dec8900-d4dd-4687-b4b9-352e2bb2a24a', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-14 16:30:00', 305.00),
    ('67636bea-e66e-4024-a1e5-aaeb8a60bb9c', '5559423a-77ba-4850-b0cb-3ef28f73c91a', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-15 19:00:00', 280.00),
    ('fe0c384a-98b6-44e3-b27b-733c206407a5', '5559423a-77ba-4850-b0cb-3ef28f73c91a', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-15 22:00:00', 285.00),
    ('4eb958e0-a02e-40e3-a86e-273841d74f85', '5559423a-77ba-4850-b0cb-3ef28f73c91a', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-15 10:30:00', 290.00),
    ('b9ad65b2-f072-4420-ad81-c18884e06a84', '5559423a-77ba-4850-b0cb-3ef28f73c91a', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-15 13:30:00', 295.00),
    ('8952c76b-0d2f-4b7b-a2ea-e38552e3ccf6', '5559423a-77ba-4850-b0cb-3ef28f73c91a', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-15 16:30:00', 300.00),
    ('5ea004db-1247-44ac-9f70-269e9a2cfeb4', '5559423a-77ba-4850-b0cb-3ef28f73c91a', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-15 19:00:00', 305.00),
    ('7ebe499b-b41a-4389-8ec3-eff509097b05', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-16 22:00:00', 280.00),
    ('17a3935d-0e9d-4fc9-b9a2-224267e4cd20', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-16 10:30:00', 285.00),
    ('da15047d-8730-4041-a36b-0a86a93f0b65', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-16 13:30:00', 290.00),
    ('980acda2-35b7-4bde-97aa-56e2d8cac826', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-16 16:30:00', 295.00),
    ('33b5339a-dec2-4b73-8c61-706f3a16f4f6', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-16 19:00:00', 300.00),
    ('bc7ac73a-16ee-4bb5-85d2-41da33bf2269', 'fb501538-ba3d-40aa-b358-5d4c4eec5be2', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-16 22:00:00', 305.00),
    ('1eb21384-a536-4d45-97fb-fae722a0e7ee', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-17 10:30:00', 280.00),
    ('3a46c652-06ee-4704-bfa8-f211c2b7f19b', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-17 13:30:00', 285.00),
    ('5ee15d36-1492-4fc8-89c3-48328c5d27c0', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-17 16:30:00', 290.00),
    ('46f866d4-d875-456b-ab98-e73c5b325b28', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-17 19:00:00', 295.00),
    ('c05162ef-5aa5-49d2-8a55-0b606fca63de', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-17 22:00:00', 300.00),
    ('326f84f1-45f0-4fe6-84d7-b985eb2fd1b6', '4e29fa7d-edaa-4db4-862c-ea305dc7f99b', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-17 10:30:00', 305.00),
    ('7a78e6a0-a53c-4ed9-9d58-2f54c06f8284', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-18 13:30:00', 280.00),
    ('027e4692-2e3e-4004-9985-0c1d0c8a1bba', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-18 16:30:00', 285.00),
    ('0ea8ae03-509e-485a-a3ac-a2e7b6dcfa73', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-18 19:00:00', 290.00),
    ('8d310a7b-e87a-4104-82ba-47316fdbb9c9', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-18 22:00:00', 295.00),
    ('c0c79e7f-a5cf-4651-9179-da19669ddb4b', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-18 10:30:00', 300.00),
    ('1b5427d2-aab6-47c1-a053-600db145d0bf', 'ddcb0971-df5f-4340-8f22-6552c13047f8', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-18 13:30:00', 305.00),
    ('55c9b050-6ce2-4059-ab8b-5fe6788975c1', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-19 16:30:00', 280.00),
    ('cd3c83f1-be02-4432-a6ff-1ef0046bfd32', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-19 19:00:00', 285.00),
    ('e9dfcddd-4aca-4541-a273-da4d96041609', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-19 22:00:00', 290.00),
    ('8ad4dbcf-d0b4-4869-a97d-8417923b845a', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-19 10:30:00', 295.00),
    ('bdb1fbca-1da6-46ad-a1bb-ced30f9fa7fe', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-19 13:30:00', 300.00),
    ('f29f13d1-8bcb-4d18-bb4e-d92ee755d791', 'd4109d21-6e2e-46b0-9b33-be0d6f6cd6d6', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-19 16:30:00', 305.00),
    ('0ebefc91-fc6b-41ba-a707-8e4de3591261', 'ee1e185b-0345-42de-82b3-bc75b4784883', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-20 19:00:00', 280.00),
    ('1577f983-9161-4784-b7b4-29741dc78358', 'ee1e185b-0345-42de-82b3-bc75b4784883', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-20 22:00:00', 285.00),
    ('9cac64b5-16b3-4b2c-89bd-e5ae23361866', 'ee1e185b-0345-42de-82b3-bc75b4784883', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-20 10:30:00', 290.00),
    ('5992a677-9c07-412e-8fea-9382b67c72b5', 'ee1e185b-0345-42de-82b3-bc75b4784883', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-20 13:30:00', 295.00),
    ('8625e939-1696-4f3c-8132-34ceee53981c', 'ee1e185b-0345-42de-82b3-bc75b4784883', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-20 16:30:00', 300.00),
    ('b40d6bfd-df13-49c1-a0ce-00fd3592e35d', 'ee1e185b-0345-42de-82b3-bc75b4784883', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-20 19:00:00', 305.00),
    ('8bf9a73c-bd76-4260-b9a4-19b8d0e08bd3', 'e0ebad76-b916-419c-b8be-33037e6ad964', 'dcc2f03b-0a69-4294-ac87-8de01ed92e4f', '2026-09-21 22:00:00', 280.00),
    ('397f27bf-61b1-4619-ba24-d26069f1b7b1', 'e0ebad76-b916-419c-b8be-33037e6ad964', '10a255e9-a08c-4f90-adaa-be28479e6277', '2026-09-21 10:30:00', 285.00),
    ('15be0ce3-1926-4f46-9d7c-f6dc31dcd67d', 'e0ebad76-b916-419c-b8be-33037e6ad964', '7ec9de3d-1abb-4754-bf1f-4c76e6fac04a', '2026-09-21 13:30:00', 290.00),
    ('2b3c6b33-363f-4524-9986-70dcde0f0fd8', 'e0ebad76-b916-419c-b8be-33037e6ad964', '647e1262-2396-4f57-bdc3-20038ed0d2de', '2026-09-21 16:30:00', 295.00),
    ('6cec44a5-9177-4248-b3e9-9d5406537d60', 'e0ebad76-b916-419c-b8be-33037e6ad964', '2b34010a-95a0-43d1-83a1-d153c8576f5e', '2026-09-21 19:00:00', 300.00),
    ('72e42d14-ca06-4c2a-8a9e-f2445cc07ea8', 'e0ebad76-b916-419c-b8be-33037e6ad964', '36c0faf5-0acf-4cda-a02c-9e2556d837cc', '2026-09-21 22:00:00', 305.00),
    ('7402af40-abd3-4271-8396-620245dfb8b6', '75d10a69-a03e-4045-acae-dc4e36109938', '8cdd338b-270e-48a6-b253-6f8fd3cd4207', '2026-09-02 10:30:00', 280.00),
    ('843f724b-f549-485f-b816-1804af4a3d0a', '75d10a69-a03e-4045-acae-dc4e36109938', '181a0300-e532-46c5-a3f1-3639d28b0e65', '2026-09-02 13:30:00', 285.00),
    ('0a619c1d-dd2d-49b5-b2d7-2e5d57448fb7', '75d10a69-a03e-4045-acae-dc4e36109938', '2482ef76-79e8-41c9-a2ab-100966e154a0', '2026-09-02 16:30:00', 290.00),
    ('390adb02-7f9d-4d3d-b12c-e9fbfa77aa03', '75d10a69-a03e-4045-acae-dc4e36109938', '262daf03-b524-44bc-b66b-41b2b795dab7', '2026-09-02 19:00:00', 295.00),
    ('7cc3b864-db23-4360-8063-dd4181d1e66d', '75d10a69-a03e-4045-acae-dc4e36109938', '3d9862b5-7cc4-4468-8234-42139d3070c1', '2026-09-02 22:00:00', 300.00),
    ('8e64057a-65c7-4a0f-af71-0f886cee7621', '75d10a69-a03e-4045-acae-dc4e36109938', '7e3b573a-ce54-4bf2-bc71-7ee3d1d62fa3', '2026-09-02 10:30:00', 305.00),
    ('998fa256-739f-4a65-a08e-9d048137b6b8', 'c5cf7263-8540-4ed7-a31e-0119e945ce9c', '46ef7472-8e28-4d57-b501-46a152a466e3', '2026-09-15 19:30:00', 2500.00),
    ('f427d7b1-d5a2-40d0-a328-5bb9d37c8627', '6c9f2004-258b-4d35-a47e-55d8c9572b93', '0d4b3530-f934-4a8f-8831-ed5068bc7323', '2026-09-20 14:00:00', 500.00),
    ('a2f5adf1-d984-4f7d-94c7-c893fa5daaa2', 'bd6b2043-56f7-40b2-a9e1-7d942d14326f', '78e74a8c-f5f9-4a75-9fd2-f4b32d1aaa94', '2026-09-05 20:00:00', 400.00);

INSERT INTO seat_maps (id, show_id) VALUES
    ('68ba61f6-ca84-4958-962c-25fe044744a7', '53b52784-1a87-4773-927d-4a5dd0ffd60e'),
    ('038264f6-5e69-464a-920c-f8ec89e00e86', '406d639b-f354-44b3-b85c-923020acbc3b'),
    ('a05c0e28-e510-4bec-8c51-d8db9e387d76', 'f96a7560-ba77-4612-9fdf-6981a33d4c56'),
    ('07d173e2-2498-41af-8098-a4275d77a7a3', '5c48464a-6dc1-4037-916e-5a73277210de'),
    ('1a356d1b-275e-4fb2-a0ec-3dd47f259210', '72c8a10c-30e9-4862-8a0d-47fb091295e9'),
    ('1f655111-1821-455b-8586-634141d2fcb9', '1faff0ef-a61d-4303-b6bc-95e1ab8a3d04'),
    ('24b30a51-5b77-47d4-94df-999c934d4b0c', '8a591325-c58a-4099-960f-87653a883d15'),
    ('62064bc7-2c3a-42ec-bb03-4e5454e22693', 'bdb9dd65-cd8b-4e1b-9d60-420c5e8ca3e3'),
    ('02924672-69b2-4667-963e-84097700c7ab', 'd6a4d80c-39b9-45e9-946c-80da6d64c4e9'),
    ('3a9576d9-e906-4f07-a0b0-bac2f9054503', '563dc184-aed4-47ea-982f-e4a33bf0245c'),
    ('c5e8a3c8-ab22-47a1-9ff7-fe5e6cffc576', 'd2986895-96d9-409c-8d4b-8f3b3f8dc7a2'),
    ('1d395bba-8cd9-4daf-9d66-0b1c45c9fe46', '71a80b3d-f649-4dcb-8750-f0e34142e3b4'),
    ('81243e55-5554-4d6c-ac24-97a65f5187d9', '1852fc48-3e38-41cb-8397-dbd72c133f50'),
    ('7fa960cc-45c5-4418-a3bf-722a02576c03', '39f3418f-a78d-484c-ae8f-52c7025bba94'),
    ('37f004c3-8f4d-4f1e-9885-ffe35915e0ea', '45578344-e20e-46ed-8889-3c2f2ce00930'),
    ('ee6ccd8f-fb13-4062-b885-55c20d1ff663', '8eb4a080-55f1-47cf-adcd-cbeb235f2091'),
    ('b6a41cda-9b53-4ae2-8e3e-2440af84afde', '6bbd8851-1cc2-4f73-8eb9-7c817dc04b39'),
    ('ec0b9858-3dbc-4e38-9d52-2e3018a3cfa9', 'cc745e62-125d-4b7e-aeb8-10af213a9f48'),
    ('27b4834b-1a87-4b10-bd07-ec28997b9b26', '8b8c219f-f751-4071-849c-b9dd64166f1c'),
    ('022b06da-e5b6-489f-9825-cd61dc15eab7', '89d2e529-9524-46ca-be88-cd22c16ee09a'),
    ('dba4c135-0233-4f62-b786-6e8aa2c84475', 'be8f4e2b-6e75-46ff-8e80-b56b42d22adb'),
    ('f9b48c74-b800-43e0-9a34-c8336312a874', 'bcb62f8b-8975-481c-88ce-09153d9575d8'),
    ('d505077a-9426-4b92-86ef-e35f8d7d58e3', '65e76080-1538-4b1e-a964-770a279963cf'),
    ('15e8679a-21ba-491e-8b71-22c8fa37dfc2', 'e07aa305-02da-44ee-9188-e5f1f86b8234'),
    ('93854fec-042c-4e85-bd62-4f7888fed3a1', '73948939-9b9a-46ac-890b-3b2f2078472c'),
    ('8dc4e358-d59f-4743-937b-ce1af0cfd35e', '892ee61c-61e4-4e44-9d55-57805aa1c476'),
    ('2bdf1648-64e1-4e77-979e-288c04cea443', '3d5c62fb-c05a-4293-a54c-89bd1719478e'),
    ('9b2df2b5-ce4c-4d44-9efa-95c4cfde257b', '19893640-7172-4730-a1f8-a9802ded6e0c'),
    ('3414033d-de45-4318-9311-deb3e6a326d5', '226f41cb-22e9-4538-97fb-986760f6506f'),
    ('2d28b18a-0597-4189-9af4-8b95d7707d31', '349aae42-a723-4ef5-aae9-be364b1376bf'),
    ('84914a27-6354-461c-ba6d-150750967513', 'cebe5a89-7c00-4ce8-bdf0-dda77a0305b2'),
    ('5e4add6a-9e69-4aca-8913-e67dda7aff0b', 'ac9525cc-9dcd-4dde-ad6a-bc57f9d0bba8'),
    ('f3e48d3f-a7ba-4e37-9db3-18bfabda9c5c', '205e1f7d-f499-455e-b56e-2ecb6d3b7efc'),
    ('f729fe6c-2a3d-4e0a-ab3d-24edc28e03c4', '7f4aa19d-58d0-4dd0-b6c7-2bf9249d2580'),
    ('c91733cf-6a57-42ed-a381-acc0f715324c', '5d36cb6b-f467-400f-936e-8e92b80313ed'),
    ('f02c318e-807f-42fc-8cd3-ad9de764dfd7', 'de29c36d-544d-4c0d-b4c5-4c4f54033631'),
    ('dae701d2-3dda-40b0-9110-55dbea6b5489', '6b858d5a-f6f7-438d-b893-c92a76b28572'),
    ('1e75e9f3-a0e7-4c14-bf9b-e6cbc031d19f', 'c8628894-663e-4087-947e-59d448675546'),
    ('a743f2ea-95fd-4c2f-bd13-5378059700cc', '582ba24e-6f4f-48d4-b460-0b6d6cdbbdf3'),
    ('0c8945f4-f1bd-4631-8d6f-40281afc3d32', '772e8ef5-c253-41e6-9f21-d5203f8b9ce4'),
    ('48a074f5-cecc-4721-9157-be823ab25487', '34f28bd2-e8ea-42d2-a6dc-d95f410e5522'),
    ('1af4c639-120f-4fed-81a4-2397e4539566', 'fd6d0616-f251-4920-8774-90251303afea'),
    ('5c391abe-8693-40ec-89d4-291dee77e1d9', '16b6c765-891c-4cef-9651-c924394f9137'),
    ('9c2ae654-3c99-4f1f-b0f3-4944baae1e0e', 'bb16873c-e29c-4f27-862c-ab91d4243f19'),
    ('c0d63afa-b8a4-486e-a515-91e1fb559391', '162647af-02e4-4237-83dd-b6d01f4e2be2'),
    ('8ac809f7-e4ee-4455-bc3c-8f99ee3049d5', '6da31a02-6d68-4d41-a598-00ead20f837c'),
    ('2316a1a9-3a78-40fa-966a-3a7eb0be75d3', '496a887e-ad6d-4282-8899-7023e799e85f'),
    ('8bdcced6-1168-4a04-80a4-c759104b441a', 'ac5b3960-fa60-450b-bf2e-eeb1473cd0e5'),
    ('09265fe6-7368-4a45-92a7-bd602edeac68', 'db811e94-20f9-4ec1-949f-13d22ab5c94d'),
    ('32b1eb79-40e7-4736-abd3-b1877a7f1a33', '8c0ab2a0-8e90-4d04-92ae-f2492fc7ad63'),
    ('3841fa8f-bdb3-41b5-975b-115565ddce19', 'c345c931-7c66-4e73-ac28-adff3a52b119'),
    ('61217cfd-3755-4550-989c-053334a05e5a', 'ebae542b-8fef-4e92-9f13-d849166241b8'),
    ('a22a1ffb-250a-438b-8865-a94abb60b54a', '9815911f-18fb-4123-b7f9-f0e80b227df7'),
    ('3d711b4b-2739-4306-9bf2-e48bc4fbd847', '0dea5b55-20b7-42be-a5a0-4b1b90f4a9a6'),
    ('fa2bc782-b90f-4e76-b8c9-242c2e21c513', 'e871d157-2ff9-4e3e-a421-ba4599f2a8c1'),
    ('49bd8649-d150-4f32-bbdf-d790bd32edf3', '34001b5f-0972-448e-bb21-afb5790751e1'),
    ('7905e3bd-1280-4260-850b-bc0507069a1c', 'b2ca5533-0077-4384-ad97-69c6740b0a84'),
    ('d1e427f5-b2f7-43e3-9978-ebb3970bf734', '85c48aec-9339-4a5d-8a70-4b04fdeedeaa'),
    ('9042dd78-3832-479a-8897-215b47b445bd', '4c03f794-7121-47e2-8b57-fda7f4c9c3bb'),
    ('8e077a27-7845-4179-b06d-ecf638422479', '4b701d5e-10eb-4570-95ce-8ac30433d018'),
    ('31cdc947-00c4-43eb-a78b-70adcfac66e1', 'ee9c8e0b-56f7-467d-9689-cf0098fca142'),
    ('8a4770cb-502f-430d-94a9-b55feeee4443', '10eda002-c1da-410f-ac8d-b772c8cd0284'),
    ('d23e2ca6-9bae-44b8-8a38-9154af5403df', 'c7a7d106-1878-4aa0-b205-4335648da888'),
    ('b7a3e86a-4fc5-4bfb-bb55-e6e257d572c8', '64bbfe44-9698-4bc6-b2c3-c3b0ad26f0f0'),
    ('ee4dd022-8e32-4e0e-8ecc-ebd986dcd8c1', '46700c09-b589-4344-83f5-0d56c9ab66a9'),
    ('a185d7ee-90ed-43d8-8f04-4b491e9eafd0', '75a9cf19-8167-4735-8fee-eeb85b19bfe8'),
    ('28494eed-c737-4ebb-b073-5090e3db11bf', '6508ce58-8403-4807-9d06-16a0e3b8fc9f'),
    ('c2cb8400-65bf-4da4-bfc9-a38ffdf34d32', 'fea6afb6-8ea5-40c6-84ed-9908bd1f0a8f'),
    ('bd30d02e-5a07-4954-95ac-b7cc5a5497a8', 'dad5e37f-8231-4a49-ab3c-0f8504d70354'),
    ('3c479b76-da1c-4030-bff0-fd7a46720c20', '6dcaf0bf-f2af-4f04-ac8e-1fe1ccde7c30'),
    ('289eb6eb-5ce7-49ed-b2cf-860605b37c1c', '6de0d48f-b5a8-4965-bfaa-eb1c7a1793a6'),
    ('fab735cf-277b-4d55-9621-53f49393c5f1', 'c958141e-5472-4754-93ff-66cbcf179b7f'),
    ('dfe83dd5-e560-4f68-bb1e-049558765598', '44f85778-f95b-40ce-b176-ccc5cd69ea9b'),
    ('11844a97-23e6-4930-9ee8-70d78150802f', 'f22f364c-bf5b-46dd-81e2-ddabdc8f7630'),
    ('501e1d0e-aab4-4649-ad0c-c9cdc468fde3', '7c7775ff-d4ec-4eb6-8eba-6ab571ac243d'),
    ('6007e51c-e6a1-4a49-9607-5877350f2fed', 'dfddac62-d3c6-4c34-8af0-0037f0cfee4e'),
    ('e58f5344-7dd6-4ac5-91c3-f38b6dc253bb', '8f095789-0790-4d0d-ae8f-6bdc6b2e0179'),
    ('a2cce0cc-cabe-4a7c-8f41-ae86eccf16ce', 'fb5654f7-4b1d-4f8a-8bab-d767e98ae73c'),
    ('742de7b4-abd9-417c-bfa7-c22a8f0a8c4b', '583c5b10-8f7c-455f-91f5-90f0ee61195f'),
    ('bd2d13d5-6651-498d-bf9a-2324459df835', 'c2f821ad-6a8e-487d-a6bc-16ecb495a544'),
    ('5e6f535f-bb05-48dc-8aa6-a93433476a51', 'd87445d2-5e35-4459-8acf-8a13be2addd2'),
    ('2a04b8a1-03a2-4eca-b1b2-bba3044f4f4e', 'cca75300-a442-4b65-a5b9-66c52af64067'),
    ('9e1d8b80-4cc9-42ea-945d-2acca09ba753', '81eeb511-c221-4f77-a941-d49a547b784d'),
    ('05360ae4-d3a9-4efd-bb52-e8ee793723cb', '16d4c3f1-1c42-41bc-ace2-48874d8b15e4'),
    ('ffea36c0-926a-4b49-8495-1a913f3befe2', 'e4e11dd1-a31b-44c2-944b-9a46f1d43e3d'),
    ('d673c8b8-0531-4475-a481-815ef6ff8ca4', '45800de2-40dd-4bc0-937b-b8ecd970ec0f'),
    ('414be44a-7a71-478d-8643-94be981593c1', 'e186d50d-d9f6-4886-b636-a4dd1f26f450'),
    ('ce1e9ea9-71ca-4209-91d9-9eea9857430e', '021e291b-ecec-4294-8604-fda4cf438c99'),
    ('c7be9fbe-cc74-4f44-be7a-ace7cf2a1335', '896bc8d8-ed87-404e-aaa5-4d50e8b07fde'),
    ('9801c6dc-e938-4feb-bec9-ee13cfb6f474', 'b66d9880-04e9-44b4-ab41-456bcf62c7f0'),
    ('e2015f13-32a3-4acc-894c-50bc42855577', '6edc74c8-7da7-4cb9-a8e4-63bff9cd0e02'),
    ('ab07050f-e89a-4a3f-8a90-470dad73b84c', '920ac48c-f4d2-4486-a14d-ec8b8b643e54'),
    ('2eed2f01-95b4-449d-a0fd-4916a3c8478d', 'b2579a46-8992-47aa-9324-03043fd452cd'),
    ('d3dc3eea-c1d9-44a1-82bb-7a706b4bf284', '2648a5ee-ef3a-48cf-ab20-5ce3789c62ae'),
    ('90e0c700-f686-4913-abf6-fc092fb7302a', '1e958571-7c2c-4174-8176-6376ecaf9e3a'),
    ('4a510330-4eda-4f5a-9b12-101bdcc7a7a4', '057fb121-8450-4ae0-be04-fa6466d51e76'),
    ('d59f3d62-9950-4e6a-8ee8-99f142395fbd', '0353f981-179b-4665-a398-2f13145c18ef'),
    ('c5bf193d-d1a9-4093-82fb-018a4c76899a', 'd330b55c-6f4e-4183-a1bd-d2d28abdbc52'),
    ('c3b6b511-a5f8-4507-97d0-826e710b8a0d', '7a55a192-54af-4612-9ccd-e3cf1e85584d'),
    ('2fd2d9dc-3486-4c07-899f-52a266081b29', '6723f131-bff9-4eea-a5ed-72071aeee54c');

INSERT INTO seat_maps (id, show_id) VALUES
    ('f6463e44-b32e-4bb9-b636-1a4d1b391c57', '578f6f0c-1573-42aa-810b-eeb5d59cbc79'),
    ('dfc128d9-bad4-40bb-b95b-6aae12eaf2ee', '8a6d94b0-57cd-499b-b194-ddfff0c55f8f'),
    ('2adc27f7-0c18-4dbb-9b31-267baa8488eb', 'da2b679e-da7e-453c-a52a-0f2fcc9440c2'),
    ('9a8d160a-028b-43d3-aa8c-23c60f6709bb', '508e88c5-c9aa-4b7a-aa26-70072a9656a8'),
    ('26f5b93e-ecf7-4b88-802d-4830311dcb45', '1240b6a5-bf88-4903-baec-68871d0e05a9'),
    ('8192d26d-cb79-4c63-b145-fa42122c1a10', '9a85d610-0829-4427-85cf-64a6ea7dc21a'),
    ('57e7fa78-8b30-463c-8e94-322afc481b10', '5c26e4fd-ecc0-4b64-8f52-ba9ee531a921'),
    ('729051ee-efcb-49d7-ad7c-efc2cf9bbb5b', 'e600954b-0c20-46c8-8793-c73aa079576a'),
    ('e83ee172-e56a-4d69-92fa-89c58a679516', '745b325a-ac90-4058-a61e-a425afdbdf1f'),
    ('c1ca9219-3453-47ac-a8f5-502b6edf027c', '1b5c361a-6cb8-4ba0-a5cc-99a9f84d921d'),
    ('56ce26a6-8887-46a7-99cd-501c194ad70d', 'b4898429-6691-4a7a-9a27-a2857d9dc3c5'),
    ('0e5aed6e-2099-4679-a224-7e5316089eeb', '1f1e16b8-4ec6-41f7-890d-7d6e11cf9809'),
    ('b245b10e-b3e4-41c0-9575-3716fa7028f3', '0a03a905-6002-4699-9a8b-1923fea8a9d3'),
    ('d6575100-a34c-4e1f-9245-d94d796cc5b2', '3d3b81b5-e5c8-4f07-8dd3-1334090f492c'),
    ('113b8782-823b-46f4-84ac-e4ab7636660c', '7399ef02-c84b-4103-a01d-327180ec5e73'),
    ('ddd53930-ac68-4ed3-b9a3-1822ea7e1214', '1f5acdc5-e9b1-4f23-b68a-77773bd62aff'),
    ('d9ad42d5-1c85-450f-abf0-707efe85f6e1', '1c74adf9-b118-4374-92c5-5c10301d7994'),
    ('4b5016fc-205a-4ab8-bfe2-0e23ddcc1c9c', '738b710b-1811-4bab-b932-ca8b036000f4'),
    ('a28f2fba-131a-4e6c-9414-d46214db4097', '08e503b9-a09d-4686-b609-3b684ff72541'),
    ('4ca5ed7b-9e06-4134-8b22-927acc3f76c4', '78321d41-b1e5-424e-9263-3abc55664b0c'),
    ('f62eadb0-124e-4dcb-80b1-efd989bc71ac', 'b5e6f946-f85a-4a79-acba-5bdbaaec5d03'),
    ('c0c8a81f-427a-4fc9-896e-322a87d3b971', '2bc36edf-436d-47ac-a67f-a336c1307d28'),
    ('a6c54ee5-9c93-4e28-9298-35815010214b', 'b546dff5-cbfa-4055-97e5-75d4d85a4264'),
    ('e6138f51-8ca4-474a-a734-b7cbf0a4fea7', '1d47e3af-c5ec-4f59-8f20-4b16296b709f'),
    ('ad94fb96-6010-48aa-a766-017f4abeaba5', '394a077e-8a5d-471b-a47c-24183b25f407'),
    ('26d6a9f4-e8e8-4fc4-941c-887ae2cea581', '8280fb54-306a-4683-bf68-f6f1401fa967'),
    ('4caed5d4-a990-4e4d-abc4-714481647ea6', 'a2c6259f-6506-4fa9-b4e8-f99bec6ebeb5'),
    ('5a12b683-6658-4bf5-bb8b-67b80a5abf74', '63695a92-7ad3-42bd-bca1-594920fbd177'),
    ('ee923406-be9f-4554-bbf3-bbb11dc76f9e', '67415565-1a0b-4fd1-a005-91d20fa99e9b'),
    ('5d16f769-f601-4ebd-b25b-251fd04dbcd7', '84864256-9103-4369-9cd7-09e1073e5477'),
    ('7d880ea6-9c4d-4560-9df5-a5da93b8a7c0', '94318b2a-0b41-4523-925c-1752b9dd653c'),
    ('f8d5f406-9a50-4784-b766-8a0ce66d7b2f', '3a092c71-206b-4f92-ae49-0a469b63b973'),
    ('6841421d-c660-4d90-862b-a9647c5870cb', '13fd43d3-6886-447a-a4a5-ba4f30150a10'),
    ('8921fa51-6cd8-4729-bd58-627d0c7d5ca1', '754b0008-8e9b-4aa7-9e21-8043f6180940'),
    ('5965d051-e15b-4427-9914-e2692358d47c', 'd049a8e4-bab9-4bf6-ac62-33f4bd5d7e22'),
    ('b78e3f47-ce10-472d-91dd-87f6192958f2', 'e9fd7d45-b240-4dfb-90aa-d5bd0810a2f3'),
    ('a7441b96-fe8e-4128-a1ee-5145921f3949', '41c2c993-059c-49c6-965b-68f4311f39c5'),
    ('38f8a190-d019-4c45-86f7-dd85da502bf6', '8806bccd-ece7-4755-8fbc-93119a719bf1'),
    ('55f71b05-bcb3-47b7-8236-8e5e1338e42c', '44526225-087d-4f8e-b637-d1ea9c7159a0'),
    ('9b17bfa6-c863-406b-93c4-517fd2637c3d', '6c4d1b12-fe2e-4724-b113-7b271687b859'),
    ('b5563348-b6f7-4a90-be03-ac0426ca9e0d', '4cdb5585-b4d2-4c9a-92cd-a033295b13cb'),
    ('22d326d5-a260-4741-9b73-084b33a5c414', 'd58b44f3-b949-473d-8640-ab2621a2f238'),
    ('ded57314-7f8a-4a16-9306-19f49737e8a4', '68dbb420-737c-4d5b-95e8-f2f5ffab9cb6'),
    ('421b8c8e-187f-4a2d-a045-92809f3eaf93', 'a5e78a81-b24d-4e2d-9728-6f7437a9b502'),
    ('576a976e-9ad8-4c37-bfa7-b5b4ee1f2150', 'c196c000-5e42-4056-84dd-d85337bc4207'),
    ('0cacc745-6686-430d-a661-c8c6576a75ab', 'aab09a3a-3546-4879-bf96-56b6c1bc97d5'),
    ('5a3befee-3f82-4629-ab8e-74c0fe931dd7', '3fa47fc3-63ea-4d3f-9555-f2233e118c82'),
    ('1e3c3fc2-77fc-4444-824f-f9b702127593', '784b2f4b-5c75-4e3b-ac20-08306aca7418'),
    ('b0c0ac63-5c4a-4ed7-ac37-5fd74284efef', '42ab0bed-d76f-449b-80f2-986653a69713'),
    ('8bd265b4-c447-4011-ae73-69340c189c19', 'b7b71d81-0654-4692-95fc-7ca53aa9b85b'),
    ('5b58e187-51b6-4fba-b8a3-6320b35e370b', 'ec01b65e-e1f7-48f3-81c3-d9f0618b22b1'),
    ('30ac6829-9142-4fdf-97cc-bce609ee433c', '70700615-46e7-4fa9-a977-8722e06aac04'),
    ('a2b9df3a-48a1-4072-a77a-4c18c3d9f873', '23a05690-003b-4f50-b6dc-59df1afdf490'),
    ('a649bb6d-9b65-4a34-afbd-9a93ff37bff7', '05864fbe-6d0d-4b0a-99c7-426382d2efae'),
    ('4e528c48-eb0d-45dc-a8f2-f4435c6c0a24', 'a9ac3b49-a0c7-4a71-9a1e-752729487caf'),
    ('ce1f2f20-2038-40de-860d-7fe995c0abb3', 'd1d4fe7f-38bc-4969-8af3-b5153d5af35d'),
    ('04bf7fdd-a6d0-49f4-bc38-0483f6f2ceed', '8f776643-7277-4221-a8d8-bfb2a6b42b2b'),
    ('97035513-d0c0-4f7d-b595-4abf28310092', '2b213698-3887-4b0f-b865-0bf769b34dc4'),
    ('c3557dff-f9ca-4e81-be32-e8631c671c11', 'b03bd4fc-eb98-4658-8df0-7b2ae0daf22c'),
    ('9bc93edd-26d8-401a-8d36-b7499183e7e3', 'f3755a76-439d-427b-8937-b676b7d3f5a7'),
    ('77018d7e-063a-46df-9459-2031b0e8cf10', '71d2aa93-3510-419d-9e68-4609542f7158'),
    ('d99d07ec-3faa-4421-857a-9f7748c34334', '8340d648-594f-48b2-8a99-a748fc563ae4'),
    ('34490c9b-5126-4d72-8f9d-1065e267f405', '7c9e1a8b-87c7-4640-8fe0-f17923b5ad91'),
    ('c61b84f1-c2de-47ba-a5a1-cdc8f4dcb8c7', 'ddd7ba61-66ec-489a-8fb6-112b3a223040'),
    ('b831c756-4763-422c-9a09-67542c2c9089', '931617f8-1d6d-4266-8957-b50c6e85078e'),
    ('607e60a8-61b8-4c66-9f12-1134b8300b54', 'aaf96e74-7daa-4e7f-9e6b-b80aa138e066'),
    ('795f52dc-666c-4779-8b78-ae863a34ba4d', '8935c4b8-4e29-45ae-bfa0-9a60aa4d9aed'),
    ('c650df57-3a17-45fa-b771-16b6f9088e06', '37dfb8c4-35a0-4807-8b9b-b92e975d8ca3'),
    ('332b9100-c234-42c6-b9bb-0ce861de25ea', '54f31026-f5fc-4b0f-a9cd-09bb245297bf'),
    ('96914941-12a5-439e-be89-6de841729502', 'a54a332d-315d-4fa7-ba09-bc29fc0adb5e'),
    ('5bab2e61-1ef2-4ad5-b900-6b08500c15dd', '90f6a519-6dc6-41a8-9aa0-fb4bac4e5047'),
    ('bc98c127-d076-465d-92ff-7418ddc44ce5', 'bd772d04-f107-4f05-89a7-8025d33febac'),
    ('5cb79cdc-f1d7-4a85-bea4-300a0acd72d5', '0772b269-e49e-4758-8eae-bcfd740e1225'),
    ('997aaa60-79e2-40e3-98a2-fe1355b75613', '4439c5b3-b643-4330-ae2a-c7624c18a8fb'),
    ('11919c7b-a733-4ae2-aec9-3be0afe8b352', '1270ccb7-ad60-4d88-a056-5b379e51d3c2'),
    ('775ace05-c28d-4980-a900-43a1312eb24d', '2eb61a26-9247-47ab-938c-8cc59012a4ba'),
    ('b5e79908-dd0b-4187-b588-11310aaba952', '33432701-32f8-4df9-b1a1-3996ea5438ee'),
    ('5158444f-0e3b-4ea0-ab19-28daf893cb70', 'cb743fdb-5301-466c-ab65-97e2633c1fcd'),
    ('98ccd139-9cc9-4957-a9f0-c7fa3f3ceb5b', '5a7cf8bd-617a-4f01-8ea2-b91d1f03d3ca'),
    ('1eedf79e-103b-4c07-a797-0c568433a3e8', '7d990b28-6415-4b92-9e7d-599e8964619d'),
    ('6bb348f1-366a-4ad3-ad7e-e7c5902b648d', 'b3fc9403-d78f-4835-831c-756e4464538f'),
    ('d238fed8-2d57-4511-845e-b3c073b49446', '7e8d9e80-017e-4c05-9a92-2a3e1326d3f5'),
    ('ba48f8af-3f5e-49a6-998b-3b2c46562f3e', '9dcfe9c5-57c9-4996-9c6b-603d61317182'),
    ('46bcb7b9-1969-4e1c-9241-83b5346ac9d2', '43373f1a-969a-428d-bf5e-5ff6d97a7591'),
    ('8b03b493-ce72-4c57-adaa-15709d61e24f', '4acd9910-5440-4131-a463-e8867f1d3bf1'),
    ('c54eb349-bd24-4206-9607-f75c6ef8ff7b', 'be099808-a45b-43d8-a24a-4b76306e7cf0'),
    ('b9bc651d-9e77-462a-9f51-872974b6cca4', '25ce0755-d0a3-482b-8fe4-0aa6e7392e8b'),
    ('30faeb58-1084-48ba-b16b-d6f98a451d9b', '0a744181-c29a-406d-a3df-31ca311eab3c'),
    ('8445bdc3-8c89-4e49-97f0-58681506d6f4', '93139ba2-aaa0-47d1-8db1-e317448252c7'),
    ('766bf5e0-99d9-4ad3-8665-5f8ad3ba896a', '36f921ba-d604-445b-9e20-55ca64dc6330'),
    ('79eaef4a-d988-47df-a836-19004b1ac8cb', 'd3ef3199-f187-4673-99f5-7f9ef311ee1d'),
    ('550d9471-2bd5-44f6-8915-7a0d7aae83ce', 'c467446a-5341-48a3-bdd7-e2c7569ffde1'),
    ('188df77b-6a86-4da2-8558-548984d648fd', '422dd618-b8f9-4f85-a0d9-f032bc6cb87c'),
    ('0cfe8c66-a9b0-4f0e-b5d1-88a8cbac0901', '92b4b990-979a-442e-8a81-058fecb3fcf7'),
    ('62b4473f-c739-43ce-a1d2-f91db53b28c4', 'dd97e191-e802-4535-9d72-c3dbabb57d33'),
    ('cd4bae8f-0c8e-420b-8cb5-af89a1a79873', 'bb277756-8e01-4fef-9beb-f1c2d0b39427'),
    ('4496d0e1-8985-41fc-be15-8b16db3ef8a8', '1ddedb07-2455-4ab4-bde8-38ee26e1a65a'),
    ('19caf007-a19b-482d-93a6-047bb38d5d6e', '89cf0f7e-e7e9-4887-b871-f9a65fc79ec8'),
    ('4bbf4387-09e1-4ab5-8c84-0cd6a2d2093f', '8f8ad9df-5a3d-4950-b89c-439b0d52ac92'),
    ('ce34563f-3601-4cf9-996c-7945d1c67fe0', '3e29a6f3-e1ae-4ac1-8605-8210fe2b1834');

INSERT INTO seat_maps (id, show_id) VALUES
    ('0ff45ca9-9db1-47e0-a487-c0c995f8880c', 'bcdb8094-b163-40a1-9396-30c4cca03479'),
    ('1a1c2636-87db-430d-a190-ca68cb5e17f7', '30926db3-88b0-49e9-afdb-81d8ccc778e2'),
    ('69bd9b5d-db62-4209-b983-8e742a7ba3c7', 'e7108ce1-65b5-405b-87c4-40a1566e5caa'),
    ('e54d867b-dca3-4b69-878b-bf4f8f5f362d', 'c90b1db8-2132-41aa-bd08-6506fa1a333b'),
    ('9e399ef6-d228-4e5d-81d0-b2ea3a72fcf7', 'b51529ab-95b4-428f-aed1-3ed5500e1ae3'),
    ('2ccd1f4c-a4cc-467f-80aa-55ba1dfc5de7', '7bb662a6-ba7b-4abd-9d89-af06a18bdf1b'),
    ('b2255096-58f3-4c8d-862c-479da81d705f', 'aeb2798e-06f8-4b92-b1cb-687da07f49b6'),
    ('28907df8-0947-418d-89f0-e240d10eb446', 'fc622849-cb78-4daa-9312-5d668a21895b'),
    ('27da5c6b-3fad-4870-847a-79481db32859', '47414b85-2105-41c6-9414-55c4cd8e3fef'),
    ('33c1a473-62df-4bba-8733-b2f1b0c99f21', 'b767fba2-2b53-4b6c-a6fd-473e93a5d0bd'),
    ('c224e80c-6961-4eb3-84b2-a92dadd99b91', 'f049b318-55c6-43c5-a1e9-707196fe479a'),
    ('8368de92-baf0-4fd9-9244-fa10eac81b72', 'adba4bb3-a2cb-4b8d-a9ff-580dd9256f2d'),
    ('8fbba333-00f6-4070-8c17-9db73acc92a2', '17ec66ba-c16b-45f4-830c-99bb7ba07f72'),
    ('ff70d935-35ca-49cb-83c0-d8c619e0f251', '692c01b9-70f0-4c58-9516-6090c89ecd52'),
    ('c42ec1ac-b54d-47ba-b6e7-e1f413b2e3ed', '83d9d133-bc51-43a9-bf30-f80aee752fd1'),
    ('b0415c66-6b95-4a1f-8c26-926450e5afb7', '65ae6de8-8291-4b5e-9329-ad72ec3d5c84'),
    ('2ab1bdd5-6588-438d-ae6d-4938a6ae37a1', '525bd4fa-2a36-479b-be3e-22989ccbdfcc'),
    ('acacd502-3f07-4207-bd31-66d2593ca0d4', '98d4c132-fd9c-4c77-a26d-8833c2fecd87'),
    ('c0c165c6-0361-4178-8f63-f99a5a07487c', '38011823-8e5c-47ac-b16c-d11d0a7dd222'),
    ('06b0a883-0b72-4d23-838a-6f204c76dc71', 'f3380112-ae90-4af0-a579-1a4bf35184da'),
    ('d2116430-8ad6-48a8-a989-b27c95045e1f', '7ba06232-c1fd-4359-bbb9-ef497908ae74'),
    ('96b30ead-9273-4378-9aee-9c4ff9a76a42', '054ee07a-f836-4c88-bec5-4b70b12c8921'),
    ('f9d81287-1a9a-4732-8f3d-0bff0eb70b1b', '5e27e7bd-ae97-4fec-88a7-ac824c9ca0f9'),
    ('1f37a8f7-ef9c-4f7d-a669-36d6c4ec2a29', '1c01098f-3875-4613-ad58-af436046dd85'),
    ('7742de19-762a-49e1-9efb-877e142085e2', 'f218e844-71f4-43ae-a58e-2dddb6eaa334'),
    ('90b4efad-e6ab-480d-b2fc-965900351583', '02392a98-f5bc-4048-865c-970b2ca6a90c'),
    ('4a09d2ac-5a03-4261-be35-30ad10a2477b', '907cbf09-2f21-4b39-bccd-f6268c8cddda'),
    ('b19b90cc-112e-4700-b7d3-642842174eda', '5ed8c6cc-850b-43a3-985f-940ba273acfc'),
    ('6b306017-4ae7-40d2-b14b-632d48b478c5', '81fe731a-bb62-44fa-a1c4-3186892f81de'),
    ('53688258-c2ef-49ad-8f70-0d8a03c5085c', '31074eb9-42f6-45d3-9388-fb3e998b2819'),
    ('73499616-c404-4931-80f2-f5ce34c00657', 'a5516fee-c114-47eb-9586-80b933ea7410'),
    ('2c550fa3-d08f-41a6-8ffc-097ba09a181d', '5108b3c5-d3d1-4a1c-b410-1460dcee90af'),
    ('dcc1b22d-b272-44cb-81e7-f062205ba281', '8bb3e23c-d2de-4594-95c5-1ba12161510d'),
    ('e02ffd90-fd04-47b3-9266-6a22a1bfde65', '85529ec2-50ec-4b41-8323-25a0a7d998a3'),
    ('d3891e6f-e031-468d-a863-cb1bf1b12ed5', '5fdf7c87-cd42-48b5-99bf-6956e1e9437b'),
    ('aa815202-8cb5-4666-a1b9-f36af1f5cbaa', '8963b285-a357-4965-9ce8-471d39e3d6c7'),
    ('6979b7b8-ec5c-4bba-b1a6-9ad3f3552d17', 'fe25dcac-0a6d-41b2-9a20-ce4eda08b1c1'),
    ('f395977e-8d4e-4576-b0e7-ed4802623873', 'd7b956f1-9d59-4d58-8739-5b5064ff42c4'),
    ('7cce9d0c-bc90-422a-8b5c-fc56c3d2c6a2', 'cc74108e-a470-40b3-baea-97e6ff8df188'),
    ('e49311b5-779a-4a3a-88b4-1261a99ed940', '05ae3deb-d5a7-440e-9189-4906eb9f3ce0'),
    ('8f1554e2-ae06-4dde-8ae6-96a4a992a6f5', '01a37005-505a-4a8a-93d7-9d25626f701c'),
    ('c4a94077-54bd-44e8-98c1-675e002e51c6', '0b1cd35b-f1cb-447c-ae1b-bd732edc643f'),
    ('106334a0-0a6c-4880-8834-08a99790f52c', '45cc7907-14e7-4751-9118-ff98b60345d1'),
    ('3281faa2-561f-4e4f-baeb-cb98183f477f', 'b0227c03-1196-40d2-bfe0-70830162748a'),
    ('2e3f97c2-9ec0-40d3-b777-eb54f892d3e6', 'f702f47e-8c3d-4476-81c3-34e5bd538984'),
    ('bb856936-dded-4cc3-85c8-e3d372cae245', '4b69742b-8778-48d1-bcfa-4888dda6ba62'),
    ('5443c1f8-19ca-409b-8473-68cd01c39fac', '9196184d-43a0-4bb0-83a1-abbead352470'),
    ('806c87c6-c2fe-497e-8342-73d9c0c07710', '33792da7-0873-4cd8-8074-cadd5d480d42'),
    ('45074ae2-95e1-490d-afd8-2c38dd8fb36a', 'bf81a3d1-d7a2-47ae-b278-923e1b9eabcf'),
    ('b2c8ef1e-b9f5-411e-945b-bb778080a09a', 'f6a87683-2a8c-402b-90b0-1144e55a7f2d'),
    ('fd2f4bd6-1861-4f5d-97d3-bb823f07801f', 'b6d1c4d8-27e3-49d6-91f3-e77e7512ec04'),
    ('4469223a-1495-4e0a-be70-68fc92e2bf87', '78616cd3-d736-444d-810d-c32b83343ad3'),
    ('4029fdf6-7839-4551-b139-eecfa98ea909', 'cd3b9b19-1480-433e-b543-13c440a5440a'),
    ('4531da1e-3ecb-49ca-8433-3ad258c6b03f', '9585ef48-16b8-4302-91a8-3cd3a1fdc8f7'),
    ('5ad06167-4ed1-4372-81f4-1a3e9fb7836d', '189f074a-fe73-416c-9a2b-12809e785dcb'),
    ('9bc30b40-effb-4b5c-9254-fd29ea7e0080', '18731704-3c49-4b8f-ab10-4cb493983255'),
    ('a488af91-595c-40d1-8ce8-5c02ecd74495', '8557271b-b9cf-4b2a-90c4-f7f4efafadb5'),
    ('83c35cb1-62fe-44af-95c1-ecad3a2f507e', 'd7b3a66b-e2ca-49fc-8bc2-ae027efe9f76'),
    ('47f69b1d-da2f-4fb8-8bc6-738fcf125c01', '0573e441-a680-48f2-b4d3-920ca4098559'),
    ('92efa1d0-cbff-492f-9be7-72bbc73d5896', '2a95d87e-c06f-4a2d-a5b0-7a112b095934'),
    ('a001ca7e-e471-48a1-b636-bfbd8b1da26e', 'b94b2808-4306-4bf9-9e9f-94555c1b5745'),
    ('ec2ee229-2db7-475f-b24e-b89d0b27b201', 'bf3cf3ca-6114-404c-8ead-0bd6efd70445'),
    ('471dd222-2ec7-4705-bde7-0acdfb45ffe2', 'c54009e4-d3c1-4dcb-9e20-f52b1606d85a'),
    ('78435b26-4a2c-41b3-a099-f6547575c179', '8645827c-c0c4-4dd3-a6cf-b5d49125e0f7'),
    ('e4ac057f-14b5-4309-b0bc-d5e02ce45810', 'c37fc906-aa21-424a-8611-f4124ca14a53'),
    ('527345ea-00bb-4fe4-ac2d-9b640504cacb', '584b423a-5016-4954-8c03-7981d62c3090'),
    ('c038d2b8-83e5-486a-a4e7-a9ef35a420cc', '2dcf5db7-0cb9-4286-ac4f-c16c375818ed'),
    ('55b34091-a05d-4f42-bf66-2e3867b01882', '20a664ad-a4da-4339-8775-b6cfd1801633'),
    ('e3eeb051-359a-4d64-9dd1-464960a1044a', '604d3da1-08ee-493b-8fbc-bc890da3721d'),
    ('2a3d13a3-9be1-4255-938b-89017618ac1f', '3c925e15-87e6-4b16-9a75-ab887eaa3398'),
    ('11b3567d-f1fb-4b9a-b30f-8d3158e72212', '33e08e6e-4506-47ae-8757-df9b0dd5d148'),
    ('ce5d989d-2194-4023-a87b-644086e52ec6', 'd7fa4054-99a3-4453-85c0-1e05ee74c2c4'),
    ('f5103750-7c47-4699-b50b-57abc867b1f5', 'a29ddc13-5971-4863-a517-dc8c4d45ff0d'),
    ('e5e24ed8-8c07-4f50-9f4a-62383cfb20d1', '12e94338-c6d5-49dd-9b0d-2f4f5a5b4e6c'),
    ('d1bee529-7e0f-4d1d-a3ca-28b4786d4c63', '7540836c-2255-4daa-bdf6-2b8b1a449f95'),
    ('3d3b275b-3f90-4aea-811e-b5101856ca6c', '6ee5ca8d-9a5d-4432-8eed-0804fd0e8419'),
    ('039a9ced-379d-44a2-82e7-9e9e19c4be53', '3b2b6be7-2754-4415-9718-84b1c70867cf'),
    ('2677e474-3d49-4ac2-af8d-20daeda348fb', '5f831565-d558-423a-b7cf-1b167832df33'),
    ('c74667c9-8465-4506-be50-6bb405f5afe4', '0b4967c8-3e4c-4062-b4aa-a4c84c1abcdd'),
    ('39c34efa-ea18-4f54-afe8-3190235809a9', '57c69b42-33ea-418c-a765-5169b8128097'),
    ('c686e5da-82ab-4a11-bbe1-e7cfc2070eed', '4761d14f-6f4d-44d9-96a8-20547e377442'),
    ('781cb8b4-e954-4bd9-90bb-2b7a60d1afca', '9e6c4eed-ed75-45f9-a60d-d31737054980'),
    ('167c96eb-6fde-4cc0-99ab-39e6c1698061', '6c57b5bc-b31e-4663-851a-438a2b0185b7'),
    ('8591fdb0-d97f-451b-8060-e2c2ebcbbbbc', 'b87b5ec0-558a-464b-9925-ecb02a4b6344'),
    ('6e612d35-6be9-4f01-ae41-f5fb26308be8', 'a36e1e5b-9ab3-4276-8f7f-acde04baed79'),
    ('ec821a2f-28a2-4af6-94d8-ef75b7a680f9', '836d1ded-3280-4f87-b8ee-2226a4747117'),
    ('10befeaf-85ed-40bc-aba3-1fb5bc3d6f68', '41e74007-becf-4a3d-8125-5df8d4a3c664'),
    ('26ce13ee-3beb-47a8-82ff-ee39ab3ff4d3', 'c4cac9d5-052f-4bd2-afdc-2948fcf6ee4c'),
    ('abd60355-2070-44c9-a6eb-462d0cd72b1e', '3d38664c-8ca7-4061-814e-f498c71541e2'),
    ('5a8601de-44dc-449c-8fc4-525ab0e99494', '0226f048-716a-46a9-9e24-7709cd929bb1'),
    ('b79e6928-c2bb-4e88-be54-3c8bcf51fb9a', '2a08cbaa-5a28-4522-bef2-56178f7369be'),
    ('d6706746-1a66-40b0-b2fc-8cc16119cc29', '1a897387-73b0-44d6-aef1-ef670b6afd5e'),
    ('5347b3a3-1179-4b31-a0bd-f4346787fb84', '0a0a5ac1-0555-48e9-b38d-e892f5bff5e3'),
    ('791592c5-bc82-47f9-944e-168ba45fa41d', 'bff081c5-4fd8-4d27-8f3d-772416a6d862'),
    ('4a7089f1-8c0a-4227-8cae-df9b5dac1ac1', 'c8c1520c-b62a-4b0a-ae4c-35cee10475b1'),
    ('d53babdf-6fef-44c0-8333-02a9d101f5ee', '8540ebe3-af15-4652-8d72-e663bed3b98a'),
    ('6bdfeb91-8e48-4ab8-b317-94e52030a951', '2fd9b509-c59a-4c21-af4c-482a3087b76a'),
    ('1b4f9e7e-c85e-449d-b7bd-750d8bb9362f', 'b842be0d-e87c-40ac-8f0b-ea20318688c0'),
    ('6be5945e-f7ca-4724-a069-b279963e8aa4', '27087ed1-100f-4cc0-b85f-b0ab2b6be361'),
    ('872333cd-6bb1-42f4-b5b3-cbc6d2e56445', '40deea6d-7aa2-455d-ad91-08df28c512b0');

INSERT INTO seat_maps (id, show_id) VALUES
    ('9fd03635-7636-412f-9920-255418221456', 'b9287047-c1bc-4854-b3b1-e16d5a1d541e'),
    ('20d4da5e-767c-4d0d-a456-3c9cb8387dce', '1909d607-8c57-4198-ad2d-3874a23b8b8c'),
    ('1db4638a-47d3-4377-ab52-1741a9abcbd3', '5c0b8db5-22bb-4ae2-83b1-959138677c39'),
    ('5091d12a-444b-4359-9040-db62c872fa56', 'b6e41097-9684-4521-90b0-84648cfb84b2'),
    ('81eda25b-e1a8-4653-bd3c-b5139e3fc576', 'da7dce16-3193-4748-a1e0-40e560e28b4c'),
    ('2b4013b0-1d2b-4a9e-941e-c91c57fde3d2', '32b7d95d-0b67-4835-a7f9-faff4efb5b16'),
    ('3d651e17-8429-4bf8-a5ef-aa7ef4ea48e3', '5e35f5fb-6d5e-48f6-972b-2ed4e8a47b52'),
    ('ff8b9032-aebb-4993-85db-64dd3ea2a00f', 'cc1134ba-8d28-4f5b-8c31-0a21cecca792'),
    ('b15a53f4-8664-483f-8524-4f315fe71b06', 'acdd9885-7807-4c6d-8035-f721af69ed98'),
    ('5cbe61ea-08e5-4846-a346-f2c0e711a860', '22d947b7-8df2-4eca-bc48-8bf974dd5099'),
    ('3aefee6e-3f17-4b19-b680-420919c58c19', 'b9003bf4-f057-4768-bedc-c1fdf7b8fef2'),
    ('da02fe5e-11eb-4d4f-871f-e203d83f448b', '6b1c6704-be5e-45b1-be5a-ab9431809bbe'),
    ('64646048-f93c-4337-9bdb-90e6cacc0734', '67636bea-e66e-4024-a1e5-aaeb8a60bb9c'),
    ('add02446-8e5c-4629-86d2-3e9f09bc4eb8', 'fe0c384a-98b6-44e3-b27b-733c206407a5'),
    ('4008faa1-3dad-4152-afb6-48ecd70e493a', '4eb958e0-a02e-40e3-a86e-273841d74f85'),
    ('742bc976-c893-4e99-bf1b-9e23109fca7d', 'b9ad65b2-f072-4420-ad81-c18884e06a84'),
    ('aad87380-4069-4c2b-9e8d-2b37147768ea', '8952c76b-0d2f-4b7b-a2ea-e38552e3ccf6'),
    ('a04fb59a-7c5a-4bdb-8498-74d51aa7b6f2', '5ea004db-1247-44ac-9f70-269e9a2cfeb4'),
    ('c29fda60-2bcd-40b3-8289-38625a98ef89', '7ebe499b-b41a-4389-8ec3-eff509097b05'),
    ('7f39af98-9199-41cd-831a-5444f7af089e', '17a3935d-0e9d-4fc9-b9a2-224267e4cd20'),
    ('66cb8441-29bf-44a5-9e9b-c95c93c1b047', 'da15047d-8730-4041-a36b-0a86a93f0b65'),
    ('a3a65a9f-1867-4bdf-b233-2e9e5a1a8fbf', '980acda2-35b7-4bde-97aa-56e2d8cac826'),
    ('5b353f63-32f1-462a-b9b3-833d08bbacd5', '33b5339a-dec2-4b73-8c61-706f3a16f4f6'),
    ('3980d649-3747-4106-b8ad-841b9ac1f4d5', 'bc7ac73a-16ee-4bb5-85d2-41da33bf2269'),
    ('e5a15204-0eea-478f-b725-26b6df71f1e1', '1eb21384-a536-4d45-97fb-fae722a0e7ee'),
    ('9469d897-ca77-471b-b0bc-c0d242383c5b', '3a46c652-06ee-4704-bfa8-f211c2b7f19b'),
    ('15e23120-72c5-486c-8a79-ebba68a2eb78', '5ee15d36-1492-4fc8-89c3-48328c5d27c0'),
    ('7a017bb8-4660-41f5-a7a6-912b3bb1c7ac', '46f866d4-d875-456b-ab98-e73c5b325b28'),
    ('ac4ae061-536a-4061-9abc-2a98e92f05f2', 'c05162ef-5aa5-49d2-8a55-0b606fca63de'),
    ('9caef3af-949b-4508-b049-8a242b85148c', '326f84f1-45f0-4fe6-84d7-b985eb2fd1b6'),
    ('e69b35b3-b157-476a-bc47-0ee06cefb865', '7a78e6a0-a53c-4ed9-9d58-2f54c06f8284'),
    ('6b8e29e1-1b9a-47c2-b9dd-73878ed2e999', '027e4692-2e3e-4004-9985-0c1d0c8a1bba'),
    ('5317c01f-301b-4574-aee5-e06fbcaf4bb0', '0ea8ae03-509e-485a-a3ac-a2e7b6dcfa73'),
    ('43047cb9-2daa-4212-abd8-63cd1e6a9eb3', '8d310a7b-e87a-4104-82ba-47316fdbb9c9'),
    ('e8ed1d21-1563-48f4-b879-24f26d8cfaaa', 'c0c79e7f-a5cf-4651-9179-da19669ddb4b'),
    ('c124ad3f-51ba-4960-a2e6-c6aba1e2c90e', '1b5427d2-aab6-47c1-a053-600db145d0bf'),
    ('3627c0a4-6937-41c9-ba7e-fc93492bd518', '55c9b050-6ce2-4059-ab8b-5fe6788975c1'),
    ('26413e40-9ba3-44a5-80c9-80acc96fa466', 'cd3c83f1-be02-4432-a6ff-1ef0046bfd32'),
    ('a467e99c-35d0-4b37-961e-1498dbb574a0', 'e9dfcddd-4aca-4541-a273-da4d96041609'),
    ('b0af1b2b-40d4-4ac4-8f90-a62eeebca4f9', '8ad4dbcf-d0b4-4869-a97d-8417923b845a'),
    ('8695159d-b2fd-4a06-81e0-3837b10e81d5', 'bdb1fbca-1da6-46ad-a1bb-ced30f9fa7fe'),
    ('3e16edd3-d701-4bc8-bd50-6b57fc6555f8', 'f29f13d1-8bcb-4d18-bb4e-d92ee755d791'),
    ('409a204b-b9d7-473a-a306-eb95d6e4eba6', '0ebefc91-fc6b-41ba-a707-8e4de3591261'),
    ('57a810e2-4098-4730-bf82-924263ca6e71', '1577f983-9161-4784-b7b4-29741dc78358'),
    ('4b9cea16-9176-4b3d-ab94-0de03efc5a2c', '9cac64b5-16b3-4b2c-89bd-e5ae23361866'),
    ('d7d1d855-3bc0-4d69-951e-d20751b22b34', '5992a677-9c07-412e-8fea-9382b67c72b5'),
    ('a7376701-5d41-4d62-8155-afb54fe5776a', '8625e939-1696-4f3c-8132-34ceee53981c'),
    ('d1b7cf74-0215-4955-ae70-c8638260a668', 'b40d6bfd-df13-49c1-a0ce-00fd3592e35d'),
    ('896ff00a-8457-429f-8605-f13ee66ea601', '8bf9a73c-bd76-4260-b9a4-19b8d0e08bd3'),
    ('1e31c098-42fa-47fe-ac0b-d003a045ba3a', '397f27bf-61b1-4619-ba24-d26069f1b7b1'),
    ('bcd73836-daa1-44c5-84b9-4cde706c2396', '15be0ce3-1926-4f46-9d7c-f6dc31dcd67d'),
    ('dc62264f-94de-4cc4-b07f-95d0bb7e688a', '2b3c6b33-363f-4524-9986-70dcde0f0fd8'),
    ('d98d10b6-4b71-4834-8804-6e615f2123eb', '6cec44a5-9177-4248-b3e9-9d5406537d60'),
    ('ff092a8f-fd8f-4b93-9223-ae4de1d7027c', '72e42d14-ca06-4c2a-8a9e-f2445cc07ea8'),
    ('cff63eea-abfe-49ea-8ad6-1f97cb044e2e', '7402af40-abd3-4271-8396-620245dfb8b6'),
    ('38954f4d-9e1c-4d11-98a2-28dc4792f34a', '843f724b-f549-485f-b816-1804af4a3d0a'),
    ('4e6ebba3-370f-43c4-8075-84a3a42a8e76', '0a619c1d-dd2d-49b5-b2d7-2e5d57448fb7'),
    ('008e7452-1c58-421b-a79b-7beef3aee511', '390adb02-7f9d-4d3d-b12c-e9fbfa77aa03'),
    ('e16d04dd-48c8-4847-b9e9-c5d303ed3f03', '7cc3b864-db23-4360-8063-dd4181d1e66d'),
    ('0aea2572-e463-4478-9a60-e27c94b87717', '8e64057a-65c7-4a0f-af71-0f886cee7621'),
    ('a8e74c65-54e1-4936-9195-02183411d606', '998fa256-739f-4a65-a08e-9d048137b6b8'),
    ('415d011b-b567-4d0e-b49e-5c7fd80a4bd4', 'f427d7b1-d5a2-40d0-a328-5bb9d37c8627'),
    ('c717aca8-219c-467b-8bb3-a336b3ee68a5', 'a2f5adf1-d984-4f7d-94c7-c893fa5daaa2');

-- Seats: 2 premium rows (front, 1.5x) + the rest regular, per seat map.
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '68ba61f6-ca84-4958-962c-25fe044744a7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '038264f6-5e69-464a-920c-f8ec89e00e86', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a05c0e28-e510-4bec-8c51-d8db9e387d76', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '07d173e2-2498-41af-8098-a4275d77a7a3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1a356d1b-275e-4fb2-a0ec-3dd47f259210', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1f655111-1821-455b-8586-634141d2fcb9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '24b30a51-5b77-47d4-94df-999c934d4b0c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '62064bc7-2c3a-42ec-bb03-4e5454e22693', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '02924672-69b2-4667-963e-84097700c7ab', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3a9576d9-e906-4f07-a0b0-bac2f9054503', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c5e8a3c8-ab22-47a1-9ff7-fe5e6cffc576', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1d395bba-8cd9-4daf-9d66-0b1c45c9fe46', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '81243e55-5554-4d6c-ac24-97a65f5187d9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7fa960cc-45c5-4418-a3bf-722a02576c03', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '37f004c3-8f4d-4f1e-9885-ffe35915e0ea', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ee6ccd8f-fb13-4062-b885-55c20d1ff663', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b6a41cda-9b53-4ae2-8e3e-2440af84afde', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ec0b9858-3dbc-4e38-9d52-2e3018a3cfa9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '27b4834b-1a87-4b10-bd07-ec28997b9b26', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '022b06da-e5b6-489f-9825-cd61dc15eab7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dba4c135-0233-4f62-b786-6e8aa2c84475', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f9b48c74-b800-43e0-9a34-c8336312a874', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd505077a-9426-4b92-86ef-e35f8d7d58e3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '15e8679a-21ba-491e-8b71-22c8fa37dfc2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '93854fec-042c-4e85-bd62-4f7888fed3a1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8dc4e358-d59f-4743-937b-ce1af0cfd35e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2bdf1648-64e1-4e77-979e-288c04cea443', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9b2df2b5-ce4c-4d44-9efa-95c4cfde257b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3414033d-de45-4318-9311-deb3e6a326d5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2d28b18a-0597-4189-9af4-8b95d7707d31', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '84914a27-6354-461c-ba6d-150750967513', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5e4add6a-9e69-4aca-8913-e67dda7aff0b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f3e48d3f-a7ba-4e37-9db3-18bfabda9c5c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f729fe6c-2a3d-4e0a-ab3d-24edc28e03c4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c91733cf-6a57-42ed-a381-acc0f715324c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f02c318e-807f-42fc-8cd3-ad9de764dfd7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dae701d2-3dda-40b0-9110-55dbea6b5489', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1e75e9f3-a0e7-4c14-bf9b-e6cbc031d19f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a743f2ea-95fd-4c2f-bd13-5378059700cc', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0c8945f4-f1bd-4631-8d6f-40281afc3d32', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '48a074f5-cecc-4721-9157-be823ab25487', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1af4c639-120f-4fed-81a4-2397e4539566', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5c391abe-8693-40ec-89d4-291dee77e1d9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9c2ae654-3c99-4f1f-b0f3-4944baae1e0e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c0d63afa-b8a4-486e-a515-91e1fb559391', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8ac809f7-e4ee-4455-bc3c-8f99ee3049d5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2316a1a9-3a78-40fa-966a-3a7eb0be75d3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8bdcced6-1168-4a04-80a4-c759104b441a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '09265fe6-7368-4a45-92a7-bd602edeac68', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '32b1eb79-40e7-4736-abd3-b1877a7f1a33', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3841fa8f-bdb3-41b5-975b-115565ddce19', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '61217cfd-3755-4550-989c-053334a05e5a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a22a1ffb-250a-438b-8865-a94abb60b54a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3d711b4b-2739-4306-9bf2-e48bc4fbd847', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'fa2bc782-b90f-4e76-b8c9-242c2e21c513', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '49bd8649-d150-4f32-bbdf-d790bd32edf3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7905e3bd-1280-4260-850b-bc0507069a1c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd1e427f5-b2f7-43e3-9978-ebb3970bf734', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9042dd78-3832-479a-8897-215b47b445bd', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8e077a27-7845-4179-b06d-ecf638422479', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '31cdc947-00c4-43eb-a78b-70adcfac66e1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8a4770cb-502f-430d-94a9-b55feeee4443', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd23e2ca6-9bae-44b8-8a38-9154af5403df', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b7a3e86a-4fc5-4bfb-bb55-e6e257d572c8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ee4dd022-8e32-4e0e-8ecc-ebd986dcd8c1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a185d7ee-90ed-43d8-8f04-4b491e9eafd0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '28494eed-c737-4ebb-b073-5090e3db11bf', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c2cb8400-65bf-4da4-bfc9-a38ffdf34d32', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'bd30d02e-5a07-4954-95ac-b7cc5a5497a8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3c479b76-da1c-4030-bff0-fd7a46720c20', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '289eb6eb-5ce7-49ed-b2cf-860605b37c1c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'fab735cf-277b-4d55-9621-53f49393c5f1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dfe83dd5-e560-4f68-bb1e-049558765598', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '11844a97-23e6-4930-9ee8-70d78150802f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '501e1d0e-aab4-4649-ad0c-c9cdc468fde3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6007e51c-e6a1-4a49-9607-5877350f2fed', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e58f5344-7dd6-4ac5-91c3-f38b6dc253bb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a2cce0cc-cabe-4a7c-8f41-ae86eccf16ce', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '742de7b4-abd9-417c-bfa7-c22a8f0a8c4b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'bd2d13d5-6651-498d-bf9a-2324459df835', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5e6f535f-bb05-48dc-8aa6-a93433476a51', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2a04b8a1-03a2-4eca-b1b2-bba3044f4f4e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9e1d8b80-4cc9-42ea-945d-2acca09ba753', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '05360ae4-d3a9-4efd-bb52-e8ee793723cb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ffea36c0-926a-4b49-8495-1a913f3befe2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd673c8b8-0531-4475-a481-815ef6ff8ca4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '414be44a-7a71-478d-8643-94be981593c1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ce1e9ea9-71ca-4209-91d9-9eea9857430e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c7be9fbe-cc74-4f44-be7a-ace7cf2a1335', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9801c6dc-e938-4feb-bec9-ee13cfb6f474', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e2015f13-32a3-4acc-894c-50bc42855577', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ab07050f-e89a-4a3f-8a90-470dad73b84c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2eed2f01-95b4-449d-a0fd-4916a3c8478d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd3dc3eea-c1d9-44a1-82bb-7a706b4bf284', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '90e0c700-f686-4913-abf6-fc092fb7302a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4a510330-4eda-4f5a-9b12-101bdcc7a7a4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd59f3d62-9950-4e6a-8ee8-99f142395fbd', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c5bf193d-d1a9-4093-82fb-018a4c76899a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c3b6b511-a5f8-4507-97d0-826e710b8a0d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2fd2d9dc-3486-4c07-899f-52a266081b29', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f6463e44-b32e-4bb9-b636-1a4d1b391c57', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dfc128d9-bad4-40bb-b95b-6aae12eaf2ee', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2adc27f7-0c18-4dbb-9b31-267baa8488eb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9a8d160a-028b-43d3-aa8c-23c60f6709bb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '26f5b93e-ecf7-4b88-802d-4830311dcb45', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8192d26d-cb79-4c63-b145-fa42122c1a10', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '57e7fa78-8b30-463c-8e94-322afc481b10', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '729051ee-efcb-49d7-ad7c-efc2cf9bbb5b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e83ee172-e56a-4d69-92fa-89c58a679516', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c1ca9219-3453-47ac-a8f5-502b6edf027c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '56ce26a6-8887-46a7-99cd-501c194ad70d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0e5aed6e-2099-4679-a224-7e5316089eeb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b245b10e-b3e4-41c0-9575-3716fa7028f3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd6575100-a34c-4e1f-9245-d94d796cc5b2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '113b8782-823b-46f4-84ac-e4ab7636660c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 220.00 * 1.5 ELSE 220.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ddd53930-ac68-4ed3-b9a3-1822ea7e1214', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 225.00 * 1.5 ELSE 225.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd9ad42d5-1c85-450f-abf0-707efe85f6e1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 230.00 * 1.5 ELSE 230.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4b5016fc-205a-4ab8-bfe2-0e23ddcc1c9c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 235.00 * 1.5 ELSE 235.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a28f2fba-131a-4e6c-9414-d46214db4097', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4ca5ed7b-9e06-4134-8b22-927acc3f76c4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f62eadb0-124e-4dcb-80b1-efd989bc71ac', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c0c8a81f-427a-4fc9-896e-322a87d3b971', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a6c54ee5-9c93-4e28-9298-35815010214b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e6138f51-8ca4-474a-a734-b7cbf0a4fea7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ad94fb96-6010-48aa-a766-017f4abeaba5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '26d6a9f4-e8e8-4fc4-941c-887ae2cea581', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4caed5d4-a990-4e4d-abc4-714481647ea6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5a12b683-6658-4bf5-bb8b-67b80a5abf74', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ee923406-be9f-4554-bbf3-bbb11dc76f9e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5d16f769-f601-4ebd-b25b-251fd04dbcd7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7d880ea6-9c4d-4560-9df5-a5da93b8a7c0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f8d5f406-9a50-4784-b766-8a0ce66d7b2f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6841421d-c660-4d90-862b-a9647c5870cb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8921fa51-6cd8-4729-bd58-627d0c7d5ca1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5965d051-e15b-4427-9914-e2692358d47c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b78e3f47-ce10-472d-91dd-87f6192958f2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a7441b96-fe8e-4128-a1ee-5145921f3949', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '38f8a190-d019-4c45-86f7-dd85da502bf6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '55f71b05-bcb3-47b7-8236-8e5e1338e42c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9b17bfa6-c863-406b-93c4-517fd2637c3d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b5563348-b6f7-4a90-be03-ac0426ca9e0d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '22d326d5-a260-4741-9b73-084b33a5c414', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ded57314-7f8a-4a16-9306-19f49737e8a4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '421b8c8e-187f-4a2d-a045-92809f3eaf93', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '576a976e-9ad8-4c37-bfa7-b5b4ee1f2150', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0cacc745-6686-430d-a661-c8c6576a75ab', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5a3befee-3f82-4629-ab8e-74c0fe931dd7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1e3c3fc2-77fc-4444-824f-f9b702127593', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b0c0ac63-5c4a-4ed7-ac37-5fd74284efef', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8bd265b4-c447-4011-ae73-69340c189c19', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5b58e187-51b6-4fba-b8a3-6320b35e370b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '30ac6829-9142-4fdf-97cc-bce609ee433c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a2b9df3a-48a1-4072-a77a-4c18c3d9f873', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a649bb6d-9b65-4a34-afbd-9a93ff37bff7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4e528c48-eb0d-45dc-a8f2-f4435c6c0a24', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ce1f2f20-2038-40de-860d-7fe995c0abb3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '04bf7fdd-a6d0-49f4-bc38-0483f6f2ceed', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '97035513-d0c0-4f7d-b595-4abf28310092', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c3557dff-f9ca-4e81-be32-e8631c671c11', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9bc93edd-26d8-401a-8d36-b7499183e7e3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '77018d7e-063a-46df-9459-2031b0e8cf10', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd99d07ec-3faa-4421-857a-9f7748c34334', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '34490c9b-5126-4d72-8f9d-1065e267f405', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c61b84f1-c2de-47ba-a5a1-cdc8f4dcb8c7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b831c756-4763-422c-9a09-67542c2c9089', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '607e60a8-61b8-4c66-9f12-1134b8300b54', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '795f52dc-666c-4779-8b78-ae863a34ba4d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c650df57-3a17-45fa-b771-16b6f9088e06', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '332b9100-c234-42c6-b9bb-0ce861de25ea', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '96914941-12a5-439e-be89-6de841729502', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5bab2e61-1ef2-4ad5-b900-6b08500c15dd', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'bc98c127-d076-465d-92ff-7418ddc44ce5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5cb79cdc-f1d7-4a85-bea4-300a0acd72d5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '997aaa60-79e2-40e3-98a2-fe1355b75613', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '11919c7b-a733-4ae2-aec9-3be0afe8b352', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '775ace05-c28d-4980-a900-43a1312eb24d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b5e79908-dd0b-4187-b588-11310aaba952', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5158444f-0e3b-4ea0-ab19-28daf893cb70', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '98ccd139-9cc9-4957-a9f0-c7fa3f3ceb5b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1eedf79e-103b-4c07-a797-0c568433a3e8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6bb348f1-366a-4ad3-ad7e-e7c5902b648d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd238fed8-2d57-4511-845e-b3c073b49446', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ba48f8af-3f5e-49a6-998b-3b2c46562f3e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '46bcb7b9-1969-4e1c-9241-83b5346ac9d2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8b03b493-ce72-4c57-adaa-15709d61e24f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c54eb349-bd24-4206-9607-f75c6ef8ff7b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b9bc651d-9e77-462a-9f51-872974b6cca4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '30faeb58-1084-48ba-b16b-d6f98a451d9b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8445bdc3-8c89-4e49-97f0-58681506d6f4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '766bf5e0-99d9-4ad3-8665-5f8ad3ba896a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '79eaef4a-d988-47df-a836-19004b1ac8cb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '550d9471-2bd5-44f6-8915-7a0d7aae83ce', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '188df77b-6a86-4da2-8558-548984d648fd', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0cfe8c66-a9b0-4f0e-b5d1-88a8cbac0901', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '62b4473f-c739-43ce-a1d2-f91db53b28c4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'cd4bae8f-0c8e-420b-8cb5-af89a1a79873', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4496d0e1-8985-41fc-be15-8b16db3ef8a8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '19caf007-a19b-482d-93a6-047bb38d5d6e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4bbf4387-09e1-4ab5-8c84-0cd6a2d2093f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ce34563f-3601-4cf9-996c-7945d1c67fe0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0ff45ca9-9db1-47e0-a487-c0c995f8880c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1a1c2636-87db-430d-a190-ca68cb5e17f7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '69bd9b5d-db62-4209-b983-8e742a7ba3c7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e54d867b-dca3-4b69-878b-bf4f8f5f362d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9e399ef6-d228-4e5d-81d0-b2ea3a72fcf7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2ccd1f4c-a4cc-467f-80aa-55ba1dfc5de7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b2255096-58f3-4c8d-862c-479da81d705f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '28907df8-0947-418d-89f0-e240d10eb446', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '27da5c6b-3fad-4870-847a-79481db32859', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '33c1a473-62df-4bba-8733-b2f1b0c99f21', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c224e80c-6961-4eb3-84b2-a92dadd99b91', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8368de92-baf0-4fd9-9244-fa10eac81b72', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8fbba333-00f6-4070-8c17-9db73acc92a2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ff70d935-35ca-49cb-83c0-d8c619e0f251', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c42ec1ac-b54d-47ba-b6e7-e1f413b2e3ed', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b0415c66-6b95-4a1f-8c26-926450e5afb7', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2ab1bdd5-6588-438d-ae6d-4938a6ae37a1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'acacd502-3f07-4207-bd31-66d2593ca0d4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c0c165c6-0361-4178-8f63-f99a5a07487c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '06b0a883-0b72-4d23-838a-6f204c76dc71', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd2116430-8ad6-48a8-a989-b27c95045e1f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '96b30ead-9273-4378-9aee-9c4ff9a76a42', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f9d81287-1a9a-4732-8f3d-0bff0eb70b1b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1f37a8f7-ef9c-4f7d-a669-36d6c4ec2a29', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7742de19-762a-49e1-9efb-877e142085e2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '90b4efad-e6ab-480d-b2fc-965900351583', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4a09d2ac-5a03-4261-be35-30ad10a2477b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b19b90cc-112e-4700-b7d3-642842174eda', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6b306017-4ae7-40d2-b14b-632d48b478c5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '53688258-c2ef-49ad-8f70-0d8a03c5085c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '73499616-c404-4931-80f2-f5ce34c00657', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2c550fa3-d08f-41a6-8ffc-097ba09a181d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dcc1b22d-b272-44cb-81e7-f062205ba281', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e02ffd90-fd04-47b3-9266-6a22a1bfde65', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd3891e6f-e031-468d-a863-cb1bf1b12ed5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 240.00 * 1.5 ELSE 240.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'aa815202-8cb5-4666-a1b9-f36af1f5cbaa', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 245.00 * 1.5 ELSE 245.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6979b7b8-ec5c-4bba-b1a6-9ad3f3552d17', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 250.00 * 1.5 ELSE 250.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f395977e-8d4e-4576-b0e7-ed4802623873', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 255.00 * 1.5 ELSE 255.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7cce9d0c-bc90-422a-8b5c-fc56c3d2c6a2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 260.00 * 1.5 ELSE 260.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e49311b5-779a-4a3a-88b4-1261a99ed940', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 265.00 * 1.5 ELSE 265.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8f1554e2-ae06-4dde-8ae6-96a4a992a6f5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c4a94077-54bd-44e8-98c1-675e002e51c6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '106334a0-0a6c-4880-8834-08a99790f52c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3281faa2-561f-4e4f-baeb-cb98183f477f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2e3f97c2-9ec0-40d3-b777-eb54f892d3e6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'bb856936-dded-4cc3-85c8-e3d372cae245', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5443c1f8-19ca-409b-8473-68cd01c39fac', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '806c87c6-c2fe-497e-8342-73d9c0c07710', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '45074ae2-95e1-490d-afd8-2c38dd8fb36a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b2c8ef1e-b9f5-411e-945b-bb778080a09a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'fd2f4bd6-1861-4f5d-97d3-bb823f07801f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4469223a-1495-4e0a-be70-68fc92e2bf87', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4029fdf6-7839-4551-b139-eecfa98ea909', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4531da1e-3ecb-49ca-8433-3ad258c6b03f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5ad06167-4ed1-4372-81f4-1a3e9fb7836d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9bc30b40-effb-4b5c-9254-fd29ea7e0080', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a488af91-595c-40d1-8ce8-5c02ecd74495', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '83c35cb1-62fe-44af-95c1-ecad3a2f507e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '47f69b1d-da2f-4fb8-8bc6-738fcf125c01', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '92efa1d0-cbff-492f-9be7-72bbc73d5896', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a001ca7e-e471-48a1-b636-bfbd8b1da26e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ec2ee229-2db7-475f-b24e-b89d0b27b201', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '471dd222-2ec7-4705-bde7-0acdfb45ffe2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '78435b26-4a2c-41b3-a099-f6547575c179', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e4ac057f-14b5-4309-b0bc-d5e02ce45810', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '527345ea-00bb-4fe4-ac2d-9b640504cacb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c038d2b8-83e5-486a-a4e7-a9ef35a420cc', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '55b34091-a05d-4f42-bf66-2e3867b01882', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e3eeb051-359a-4d64-9dd1-464960a1044a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2a3d13a3-9be1-4255-938b-89017618ac1f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '11b3567d-f1fb-4b9a-b30f-8d3158e72212', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ce5d989d-2194-4023-a87b-644086e52ec6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'f5103750-7c47-4699-b50b-57abc867b1f5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e5e24ed8-8c07-4f50-9f4a-62383cfb20d1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd1bee529-7e0f-4d1d-a3ca-28b4786d4c63', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3d3b275b-3f90-4aea-811e-b5101856ca6c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '039a9ced-379d-44a2-82e7-9e9e19c4be53', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2677e474-3d49-4ac2-af8d-20daeda348fb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c74667c9-8465-4506-be50-6bb405f5afe4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '39c34efa-ea18-4f54-afe8-3190235809a9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c686e5da-82ab-4a11-bbe1-e7cfc2070eed', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '781cb8b4-e954-4bd9-90bb-2b7a60d1afca', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '167c96eb-6fde-4cc0-99ab-39e6c1698061', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8591fdb0-d97f-451b-8060-e2c2ebcbbbbc', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6e612d35-6be9-4f01-ae41-f5fb26308be8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ec821a2f-28a2-4af6-94d8-ef75b7a680f9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '10befeaf-85ed-40bc-aba3-1fb5bc3d6f68', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '26ce13ee-3beb-47a8-82ff-ee39ab3ff4d3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'abd60355-2070-44c9-a6eb-462d0cd72b1e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5a8601de-44dc-449c-8fc4-525ab0e99494', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b79e6928-c2bb-4e88-be54-3c8bcf51fb9a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd6706746-1a66-40b0-b2fc-8cc16119cc29', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5347b3a3-1179-4b31-a0bd-f4346787fb84', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '791592c5-bc82-47f9-944e-168ba45fa41d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4a7089f1-8c0a-4227-8cae-df9b5dac1ac1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd53babdf-6fef-44c0-8333-02a9d101f5ee', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6bdfeb91-8e48-4ab8-b317-94e52030a951', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1b4f9e7e-c85e-449d-b7bd-750d8bb9362f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6be5945e-f7ca-4724-a069-b279963e8aa4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '872333cd-6bb1-42f4-b5b3-cbc6d2e56445', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9fd03635-7636-412f-9920-255418221456', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '20d4da5e-767c-4d0d-a456-3c9cb8387dce', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1db4638a-47d3-4377-ab52-1741a9abcbd3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5091d12a-444b-4359-9040-db62c872fa56', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '81eda25b-e1a8-4653-bd3c-b5139e3fc576', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '2b4013b0-1d2b-4a9e-941e-c91c57fde3d2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3d651e17-8429-4bf8-a5ef-aa7ef4ea48e3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ff8b9032-aebb-4993-85db-64dd3ea2a00f', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b15a53f4-8664-483f-8524-4f315fe71b06', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5cbe61ea-08e5-4846-a346-f2c0e711a860', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3aefee6e-3f17-4b19-b680-420919c58c19', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'da02fe5e-11eb-4d4f-871f-e203d83f448b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '64646048-f93c-4337-9bdb-90e6cacc0734', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'add02446-8e5c-4629-86d2-3e9f09bc4eb8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4008faa1-3dad-4152-afb6-48ecd70e493a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '742bc976-c893-4e99-bf1b-9e23109fca7d', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'aad87380-4069-4c2b-9e8d-2b37147768ea', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a04fb59a-7c5a-4bdb-8498-74d51aa7b6f2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c29fda60-2bcd-40b3-8289-38625a98ef89', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7f39af98-9199-41cd-831a-5444f7af089e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '66cb8441-29bf-44a5-9e9b-c95c93c1b047', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a3a65a9f-1867-4bdf-b233-2e9e5a1a8fbf', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5b353f63-32f1-462a-b9b3-833d08bbacd5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3980d649-3747-4106-b8ad-841b9ac1f4d5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e5a15204-0eea-478f-b725-26b6df71f1e1', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9469d897-ca77-471b-b0bc-c0d242383c5b', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '15e23120-72c5-486c-8a79-ebba68a2eb78', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '7a017bb8-4660-41f5-a7a6-912b3bb1c7ac', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ac4ae061-536a-4061-9abc-2a98e92f05f2', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '9caef3af-949b-4508-b049-8a242b85148c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e69b35b3-b157-476a-bc47-0ee06cefb865', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '6b8e29e1-1b9a-47c2-b9dd-73878ed2e999', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '5317c01f-301b-4574-aee5-e06fbcaf4bb0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '43047cb9-2daa-4212-abd8-63cd1e6a9eb3', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e8ed1d21-1563-48f4-b879-24f26d8cfaaa', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c124ad3f-51ba-4960-a2e6-c6aba1e2c90e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3627c0a4-6937-41c9-ba7e-fc93492bd518', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '26413e40-9ba3-44a5-80c9-80acc96fa466', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a467e99c-35d0-4b37-961e-1498dbb574a0', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'b0af1b2b-40d4-4ac4-8f90-a62eeebca4f9', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '8695159d-b2fd-4a06-81e0-3837b10e81d5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '3e16edd3-d701-4bc8-bd50-6b57fc6555f8', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '409a204b-b9d7-473a-a306-eb95d6e4eba6', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '57a810e2-4098-4730-bf82-924263ca6e71', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4b9cea16-9176-4b3d-ab94-0de03efc5a2c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd7d1d855-3bc0-4d69-951e-d20751b22b34', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a7376701-5d41-4d62-8155-afb54fe5776a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd1b7cf74-0215-4955-ae70-c8638260a668', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '896ff00a-8457-429f-8605-f13ee66ea601', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '1e31c098-42fa-47fe-ac0b-d003a045ba3a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'bcd73836-daa1-44c5-84b9-4cde706c2396', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'dc62264f-94de-4cc4-b07f-95d0bb7e688a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'd98d10b6-4b71-4834-8804-6e615f2123eb', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'ff092a8f-fd8f-4b93-9223-ae4de1d7027c', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'cff63eea-abfe-49ea-8ad6-1f97cb044e2e', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 280.00 * 1.5 ELSE 280.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '38954f4d-9e1c-4d11-98a2-28dc4792f34a', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 285.00 * 1.5 ELSE 285.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '4e6ebba3-370f-43c4-8075-84a3a42a8e76', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 290.00 * 1.5 ELSE 290.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '008e7452-1c58-421b-a79b-7beef3aee511', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 295.00 * 1.5 ELSE 295.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'e16d04dd-48c8-4847-b9e9-c5d303ed3f03', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 300.00 * 1.5 ELSE 300.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '0aea2572-e463-4478-9a60-e27c94b87717', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 305.00 * 1.5 ELSE 305.00 END,
       'AVAILABLE'
FROM generate_series(1, 5) AS row_num, generate_series(1, 10) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'a8e74c65-54e1-4936-9195-02183411d606', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 2500.00 * 1.5 ELSE 2500.00 END,
       'AVAILABLE'
FROM generate_series(1, 20) AS row_num, generate_series(1, 20) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), '415d011b-b567-4d0e-b49e-5c7fd80a4bd4', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 500.00 * 1.5 ELSE 500.00 END,
       'AVAILABLE'
FROM generate_series(1, 30) AS row_num, generate_series(1, 40) AS seat_num;
INSERT INTO seats (id, seat_map_id, row_label, seat_number, seat_type, price, status)
SELECT gen_random_uuid(), 'c717aca8-219c-467b-8bb3-a336b3ee68a5', row_num::text, seat_num,
       CASE WHEN row_num <= 2 THEN 'PREMIUM' ELSE 'REGULAR' END,
       CASE WHEN row_num <= 2 THEN 400.00 * 1.5 ELSE 400.00 END,
       'AVAILABLE'
FROM generate_series(1, 10) AS row_num, generate_series(1, 10) AS seat_num;
