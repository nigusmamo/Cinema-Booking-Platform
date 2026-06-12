-- Ensure tables exist just in case
CREATE TABLE IF NOT EXISTS public.halls (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL
);

-- Seed Hall
INSERT INTO public.halls (id, name) 
VALUES ('11111111-1111-1111-1111-111111111111', 'Grand Cinema Hall')
ON CONFLICT (id) DO NOTHING;

-- Seed Seats for the Hall
DO $$
DECLARE
    h_id UUID := '11111111-1111-1111-1111-111111111111';
    r TEXT;
    c INTEGER;
BEGIN
    FOR r IN SELECT unnest(ARRAY['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']) LOOP
        FOR c IN 1..16 LOOP
            INSERT INTO public.seats (id, hall_id, row_label, column_number, type)
            VALUES (gen_random_uuid(), h_id, r, c, 
                CASE 
                    WHEN r = 'A' THEN 'vip'
                    WHEN r = 'B' THEN 'couple'
                    ELSE 'standard'
                END
            ) ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

-- Seed Schedules for the next 7 days for all movies
DO $$
DECLARE
    m_record RECORD;
    h_id UUID := '11111111-1111-1111-1111-111111111111';
    start_dt TIMESTAMP WITH TIME ZONE;
    i INTEGER;
    j INTEGER;
BEGIN
    -- For each movie
    FOR m_record IN SELECT id, duration_minutes FROM public.movies LOOP
        -- For the next 7 days
        FOR i IN 0..6 LOOP
            -- Create 2 shows per day
            FOR j IN 1..2 LOOP
                start_dt := CURRENT_DATE + i * INTERVAL '1 day' + (14 + j * 4) * INTERVAL '1 hour';
                
                INSERT INTO public.schedules (id, movie_id, hall_id, start_time, end_time)
                VALUES (
                    gen_random_uuid(), 
                    m_record.id, 
                    h_id, 
                    start_dt, 
                    start_dt + m_record.duration_minutes * INTERVAL '1 minute'
                );
            END LOOP;
        END LOOP;
    END LOOP;
END $$;
