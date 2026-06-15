CREATE TABLE public.seat_prices (
  type  text    PRIMARY KEY,
  price numeric NOT NULL DEFAULT 0
);

INSERT INTO public.seat_prices (type, price) VALUES
  ('standard', 400),
  ('vip',      1200),
  ('couple',   800);
