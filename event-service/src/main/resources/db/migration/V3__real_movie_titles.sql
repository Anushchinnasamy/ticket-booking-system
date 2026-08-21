-- Swaps the three generic placeholder movie titles for real, recognizable
-- films so the catalog reads like an actual cinema listing during manual
-- testing/demos. IDs are untouched (still referenced by tests/docs) —
-- title/description only. Descriptions are original one-line blurbs, not
-- copied studio marketing copy.

UPDATE events SET
    title = 'Jurassic Park',
    description = 'A theme park of cloned dinosaurs goes wrong on opening weekend.'
WHERE id = '22222222-2222-2222-2222-222222222201';

UPDATE events SET
    title = 'Blade Runner 2049',
    description = 'A neo-noir hunt through a rain-soaked megacity three decades on.'
WHERE id = '22222222-2222-2222-2222-222222222202';

UPDATE events SET
    title = 'Arrival',
    description = 'A linguist races to decode an alien language before the world panics.'
WHERE id = '22222222-2222-2222-2222-222222222203';
