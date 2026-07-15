DROP VIEW IF EXISTS public.booked_seats;

DROP INDEX IF EXISTS public.bookings_tx_ref_key;

ALTER TABLE public.bookings
  DROP COLUMN IF EXISTS tx_ref;
