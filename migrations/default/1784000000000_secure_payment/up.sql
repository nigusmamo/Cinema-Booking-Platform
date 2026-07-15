
ALTER TABLE public.bookings
  ADD COLUMN IF NOT EXISTS tx_ref text;
CREATE UNIQUE INDEX IF NOT EXISTS bookings_tx_ref_key
  ON public.bookings (tx_ref)
  WHERE tx_ref IS NOT NULL;


CREATE OR REPLACE VIEW public.booked_seats AS
  SELECT b.schedule_id,
         bs.seat_id
  FROM public.booking_seats bs
  JOIN public.bookings b ON b.id = bs.booking_id
  WHERE b.payment_status = 'completed';
