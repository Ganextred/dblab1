import psycopg2
import time
from pymongo import MongoClient

# Connect to the PostgreSQL database
pg_conn = psycopg2.connect("dbname=gaming user=postgres password=postgres host=localhost port=5432")
pg_cursor = pg_conn.cursor()

# Connect to MongoDB
mongo_client = MongoClient("mongodb://localhost:27017/")
mongo_db = mongo_client.mytestdb

# Set up sample query data
test_user_id = 1
test_game_id = 3

# Test Case 1: Query by indexed field user_id (SQL)
start_time = time.time()
pg_cursor.execute("SELECT * FROM \"inGamePurchasedItems\" WHERE user_id=%s", (test_user_id, ))
pg_results_user_id = pg_cursor.fetchall()
end_time = time.time()
print("PostgreSQL Test 1 (user_id) time:", end_time - start_time)

# Test Case 1: Query by indexed field user_id (NoSQL)
start_time = time.time()
mongo_results_user_id = list(mongo_db.InGamePurchasedItems.find({"user_id": test_user_id}))
end_time = time.time()
print("MongoDB Test 1 (user_id) time:", end_time - start_time)


# Test Case 2: Query by indexed field game_id (SQL)
start_time = time.time()
pg_cursor.execute("SELECT * FROM \"inGamePurchasedItems\" WHERE game_id=%s", (test_game_id, ))
pg_results_game_id = pg_cursor.fetchall()
end_time = time.time()
print("PostgreSQL Test 2 (game_id) time:", end_time - start_time)

# Test Case 2: Query by indexed field game_id (NoSQL)
start_time = time.time()
mongo_results_game_id = list(mongo_db.InGamePurchasedItems.find({"game_id": test_game_id}))
end_time = time.time()
print("MongoDB Test 2 (game_id) time:", end_time - start_time)

# Test Case 3: Query all games where specific user have purchased items (SQL)
start_time = time.time()
pg_cursor.execute("""
    SELECT  *
    FROM "inGamePurchasedItems"
    JOIN games ON "inGamePurchasedItems".game_id = games.id
    WHERE "inGamePurchasedItems".user_id = %s
""", (test_user_id,))
pg_results_user_games = pg_cursor.fetchall()
end_time = time.time()
print("PostgreSQL Test 3 (user_games) time:", end_time - start_time)

# Test Case 3: Query all games where specific user have purchased items (NoSQL)
# 3.1 Fetch distinct game IDs for the user (MongoDB)
start_time = time.time()
mongo_game_ids = mongo_db.InGamePurchasedItems.distinct("game_id", {"user_id": test_user_id})
# 3.2 For each game ID, fetch game data using SQL
game_ids_tuple = tuple(mongo_game_ids)
pg_cursor.execute("SELECT * FROM games WHERE id IN %s", (game_ids_tuple,))
game_data_results = pg_cursor.fetchall()
end_time = time.time()
print("Test Case 3 (user_games) time:", end_time - start_time)

# Test Case 4: Count 'stat_boosts' with duration 601 for specific user (SQL)
start_time = time.time()
pg_cursor.execute("SELECT COUNT(*) FROM \"inGamePurchasedItems\" WHERE game_specific_data->>'duration' > '601'")
pg_results_duration_601 = pg_cursor.fetchone()[0]
end_time = time.time()
print("PostgreSQL Test 4 (duration_601) time:", end_time - start_time)


# Test Case 4: Count 'stat_boosts' with duration 601 for specific user (NoSQL)
start_time = time.time()
mongo_results_duration_601 = mongo_db.InGamePurchasedItems.count_documents({"game_specific_data.duration": {"$gt": 601}})
end_time = time.time()
print("MongoDB Test 4 (duration_601) time:", end_time - start_time)

# Close PostgreSQL connection
pg_cursor.close()
pg_conn.close()




