--1. Stored Procedure: Insert User


CREATE OR REPLACE PROCEDURE insert_user(IN p_username VARCHAR, IN p_email VARCHAR, IN p_password VARCHAR, IN p_region_id INTEGER)
LANGUAGE 'plpgsql'
AS $$
BEGIN
  INSERT INTO users (username, email, password, region_id, created_at)
  VALUES (p_username, p_email, p_password, p_region_id, NOW());
END;
$$;


--Usage:
--
--
--CALL insert_user('example_username', 'example@example.com', 'example_password', 1);


--2. Custom Function: Calculate average game rating


CREATE FUNCTION avg_game_rating(p_game_id INTEGER)
RETURNS FLOAT
AS $$
DECLARE
  average_rating FLOAT;
BEGIN
  SELECT AVG(rating) INTO average_rating
  FROM reviews
  WHERE game_id = p_game_id;
  RETURN average_rating;
END;
$$ LANGUAGE plpgsql;


--Usage:
--
--
--SELECT avg_game_rating(1);


--3. Trigger: Update game's `updated_at` and `updated_by` on review creation


CREATE FUNCTION trigger_update_game_on_review() RETURNS trigger
AS $$
BEGIN
  UPDATE games g
    SET updated_at = NEW.created_at, updated_by = NEW.user_id,
    rating = (OLD.rating * (SELECT COUNT(*) FROM reviews r WHERE r.id = g.game_id) + NEW.rating)/
    (SELECT COUNT(*) FROM reviews r WHERE r.id = g.game_id)
    WHERE g.id = NEW.game_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_game_on_review
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_update_game_on_review();



--4. Stored Procedure: Add favorite game for a user


CREATE OR REPLACE PROCEDURE add_favorite_game(IN p_user_id INTEGER, IN p_game_id INTEGER)
LANGUAGE 'plpgsql'
AS $$
BEGIN
  INSERT INTO favorite_games (user_id, game_id, updated_at)
  VALUES (p_user_id, p_game_id, NOW());
END;
$$;

--
--Usage:
--
--
--CALL add_favorite_game(1, 1);


--5. Custom Function: Get user's favorite games


CREATE FUNCTION get_favorite_games(p_user_id INTEGER)
RETURNS TABLE (game_id INTEGER)
AS $$
BEGIN
  RETURN QUERY
  SELECT game_id
  FROM favorite_games
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;


--Usage:
--
--
--SELECT * FROM get_favorite_games(1);


--6. Trigger: Check game purchasing before adding review


CREATE FUNCTION trigger_check_game_purchase_before_review() RETURNS trigger
AS $$
DECLARE
  v_purchased_game BOOLEAN;
BEGIN
  SELECT EXISTS(
    SELECT 1
    FROM game_purchases
    WHERE game_id = NEW.game_id
    AND user_id = NEW.user_id
  ) INTO v_purchased_game;

  IF (NOT v_purchased_game) THEN
    RAISE EXCEPTION 'User cannot review a game without purchasing it';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_game_purchase_before_review
  BEFORE INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_check_game_purchase_before_review();


--7. Stored Procedure: Update game rating


CREATE OR REPLACE PROCEDURE update_game_rating(p_game_id INTEGER, p_new_rating FLOAT)
LANGUAGE 'plpgsql'
AS $$
BEGIN
  UPDATE games
    SET rating = p_new_rating, updated_at = NOW()
    WHERE id = p_game_id;
END;
$$;


--Usage:
--
--
--CALL update_game_rating(1, 4.5);


--8. Custom Function: Get games by genre


CREATE FUNCTION get_games_by_genre(p_genre_id INTEGER)
RETURNS TABLE (game_id INTEGER)
AS $$
BEGIN
  RETURN QUERY
  SELECT game_id
  FROM game_genres
  WHERE genre_id = p_genre_id;
END;
$$ LANGUAGE plpgsql;


--Usage:
--
--
--SELECT * FROM get_games_by_genre(1);


--9. Trigger Create game_purchasing for user only if game released in user region


CREATE FUNCTION trigger_check_game_release_region() RETURNS trigger
AS $$
DECLARE
  v_regional_release_date DATE;
BEGIN
  SELECT release_date
  INTO v_regional_release_date
  FROM game_publishing
  WHERE game_id = NEW.game_id
  AND region_id = (SELECT region_id FROM users WHERE id = NEW.user_id);

  IF (v_regional_release_date IS NULL) THEN
    RAISE EXCEPTION 'This game has not been released in your region';
  ELSIF (v_regional_release_date > CURRENT_DATE) THEN
    RAISE EXCEPTION 'This game has not been released in your region yet';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_game_release_region
  BEFORE INSERT ON game_purchases
  FOR EACH ROW
  EXECUTE FUNCTION trigger_check_game_release_region();


--10. Stored Procedure: Update developer


CREATE OR REPLACE PROCEDURE update_developer(IN p_id INTEGER, IN p_name VARCHAR, IN p_founded_date DATE, IN p_website VARCHAR, IN p_country VARCHAR, IN p_updated_by INTEGER)
LANGUAGE 'plpgsql'
AS $$
BEGIN
  UPDATE developers
    SET name = p_name, founded_date = p_founded_date, website = p_website, country = p_country, updated_at = NOW(), updated_by = p_updated_by
    WHERE id = p_id;
END;
$$;


--Usage:
--
--
--CALL update_developer(1, 'Updated Developer', '2000-01-01', 'https://updated-dev.com', 'Updated Country', 1);
