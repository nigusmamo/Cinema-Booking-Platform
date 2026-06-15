-- Function: recalculates movies.rating_avg from actual user ratings.
-- Returns NULL when no user ratings exist (so the admin seed value is shown
-- until users start rating, then the live average takes over).
CREATE OR REPLACE FUNCTION sync_movie_rating_avg()
RETURNS TRIGGER AS $$
DECLARE
  target_movie_id uuid;
BEGIN
  -- Determine which movie_id to update
  IF TG_OP = 'DELETE' THEN
    target_movie_id := OLD.movie_id;
  ELSE
    target_movie_id := NEW.movie_id;
  END IF;

  UPDATE movies
  SET rating_avg = (
    SELECT AVG(rating_value)   -- NULL when no rows (keeps admin value until first rating)
    FROM ratings
    WHERE movie_id = target_movie_id
  )
  WHERE id = target_movie_id;

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: fires after every insert, update or delete on ratings
CREATE TRIGGER trg_sync_movie_rating_avg
AFTER INSERT OR UPDATE OR DELETE ON ratings
FOR EACH ROW EXECUTE FUNCTION sync_movie_rating_avg();
