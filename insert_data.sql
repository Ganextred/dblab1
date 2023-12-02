CREATE SEQUENCE item_id_seq;

DO $$
DECLARE
  user_id INTEGER;
  game_id INTEGER;
  num_users INTEGER := 1000;
  num_games_per_user INTEGER := 3;
  num_purchases_per_game INTEGER := 50;
  item_id INTEGER;
  item_name VARCHAR;
  item_description VARCHAR;
  item_price FLOAT;
  purchase_date DATE;
  purchase_time TIMESTAMP;
  game_specific_data JSON;
BEGIN
  FOR user_id IN 1..num_users LOOP
    INSERT INTO users (id) VALUES (user_id);
  END LOOP;

  -- Insert games
  FOR game_id IN 1..(num_users * num_games_per_user) LOOP
    INSERT INTO games (id) VALUES (game_id);
  END LOOP;
	
  FOR user_id IN 1..num_users LOOP
    FOR game_id IN 1..num_games_per_user LOOP
      FOR i IN 1..num_purchases_per_game LOOP
        item_id := game_id;
        item_name := 'Item_' || (ROUND(1 + RANDOM() * 1000)::INTEGER)::TEXT;
        item_description := 'Description for Item_' || (ROUND(1 + RANDOM() * 1000)::INTEGER)::TEXT;
        item_price := ROUND(0.99 + RANDOM() * 99);
        purchase_date := NOW()::DATE;
        purchase_time := NOW()::TIMESTAMP;

        game_specific_data := json_build_object(
          'stat_boost', (ARRAY['strength', 'agility', 'intelligence'])[(RANDOM() * 3)::INTEGER + 1],
          'duration', (ROUND((600 + RANDOM() * 3000))::INTEGER)::TEXT,
          'level_requirement', (ROUND((1 + RANDOM() * 50))::INTEGER)::TEXT
        );

        INSERT INTO "inGamePurchasedItems" (id, user_id, game_id, item_id, item_name, item_description, item_price, purchase_date, purchase_time, game_specific_data)
        VALUES (NEXTVAL('item_id_seq'),user_id, game_id, item_id, item_name, item_description, item_price, purchase_date, purchase_time, game_specific_data);
      END LOOP;
    END LOOP;
  END LOOP;
  RAISE NOTICE 'Test data inserted successfully!';
END $$;