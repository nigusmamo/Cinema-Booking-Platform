
-- ============================================================
-- HALLS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.halls (
    id   uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL
);

INSERT INTO public.halls (id, name)
VALUES ('11111111-1111-1111-1111-111111111111', 'Grand Cinema Hall')
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- SEATS  (rows A-J, 16 columns each)
-- ============================================================
DO $$
DECLARE
    h_id UUID := '11111111-1111-1111-1111-111111111111';
    r    TEXT;
    c    INTEGER;
BEGIN
    FOR r IN SELECT unnest(ARRAY['A','B','C','D','E','F','G','H','I','J']) LOOP
        FOR c IN 1..16 LOOP
            INSERT INTO public.seats (id, hall_id, row_label, column_number, type)
            VALUES (
                gen_random_uuid(), h_id, r, c,
                CASE WHEN r = 'A' THEN 'vip'
                     WHEN r = 'B' THEN 'couple'
                     ELSE 'standard' END
            ) ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

DO $$
DECLARE
    h_id      UUID := '11111111-1111-1111-1111-111111111111';
    m_id      UUID;
    dur_min   INTEGER;
    base_date DATE := CURRENT_DATE;
    start_dt  TIMESTAMP WITH TIME ZONE;
    rec       RECORD;
    showtime  INTERVAL;
BEGIN
    -- Remove all future schedules (cascading cleanup for dev re-seeding)
    DELETE FROM public.booking_seats
    WHERE booking_id IN (
        SELECT b.id FROM public.bookings b
        JOIN public.schedules s ON s.id = b.schedule_id
        WHERE s.start_time::date >= base_date
    );
    DELETE FROM public.bookings
    WHERE schedule_id IN (
        SELECT id FROM public.schedules WHERE start_time::date >= base_date
    );
    DELETE FROM public.schedules WHERE start_time::date >= base_date;

    -- ── Build the 7-day programme ─────────────────────────────
    FOR rec IN
        SELECT day_offset, movie_title FROM (VALUES

            -- Day 0 — diverse opening day
            (0, 'The Dark Knight'),
            (0, 'Parasite'),
            (0, 'The Shawshank Redemption'),
            (0, 'Dune'),
            (0, 'Titanic'),
            (0, 'The Wolf of Wall Street'),

            -- Day 1 — sci-fi & crime night
            (1, 'Inception'),
            (1, 'Gladiator'),
            (1, 'The Godfather'),
            (1, 'Avatar'),
            (1, 'Joker'),
            (1, 'Oppenheimer'),

            -- Day 2 — action & mystery
            (2, 'The Matrix'),
            (2, 'Pulp Fiction'),
            (2, 'Mad Max: Fury Road'),
            (2, 'Spider-Man: No Way Home'),
            (2, 'Shutter Island'),
            (2, 'John Wick'),

            -- Day 3 — epic & drama rotation
            (3, 'Interstellar'),
            (3, 'The Godfather'),
            (3, 'Avengers: Endgame'),
            (3, 'The Wolf of Wall Street'),
            (3, 'Parasite'),
            (3, 'Titanic'),

            -- Day 4 — fan favourites encore
            (4, 'The Dark Knight'),
            (4, 'Inception'),
            (4, 'The Shawshank Redemption'),
            (4, 'Dune'),
            (4, 'Joker'),
            (4, 'Avatar'),

            -- Day 5 — blockbuster weekend
            (5, 'Gladiator'),
            (5, 'Pulp Fiction'),
            (5, 'Spider-Man: No Way Home'),
            (5, 'Oppenheimer'),
            (5, 'Mad Max: Fury Road'),
            (5, 'Shutter Island'),

            -- Day 6 — closing week wrap
            (6, 'Interstellar'),
            (6, 'John Wick'),
            (6, 'Avengers: Endgame'),
            (6, 'Titanic'),
            (6, 'The Matrix'),
            (6, 'The Wolf of Wall Street')

        ) AS t(day_offset, movie_title)
    LOOP
        SELECT id, duration_minutes
        INTO   m_id, dur_min
        FROM   public.movies
        WHERE  title = rec.movie_title
        LIMIT  1;

        IF m_id IS NOT NULL THEN
            FOR showtime IN
                SELECT unnest(ARRAY[
                    '14:00'::INTERVAL,
                    '17:30'::INTERVAL,
                    '20:30'::INTERVAL
                ])
            LOOP
                start_dt := base_date
                          + rec.day_offset * INTERVAL '1 day'
                          + showtime;

                INSERT INTO public.schedules (id, movie_id, hall_id, start_time, end_time)
                VALUES (
                    gen_random_uuid(),
                    m_id,
                    h_id,
                    start_dt,
                    start_dt + dur_min * INTERVAL '1 minute'
                );
            END LOOP;
        END IF;
    END LOOP;
END $$;
