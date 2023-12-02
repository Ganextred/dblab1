from pymongo import MongoClient
from datetime import datetime
import random
print("Start")
# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client.game

# Function to generate a random float between two numbers
def random_float(min_val, max_val):
    return random.uniform(min_val, max_val)

# Generate test data
num_users = 1000
num_games_per_user = 3
num_purchases_per_game = 50

for user_id in range(1, num_users + 1):
    for game_id in range(1, num_games_per_user + 1):
        for _ in range(num_purchases_per_game):
            purchase_data = {
                'user_id': user_id,
                'game_id': game_id,
                'item_id': random.randint(1, 1000),
                'item_name': f"Item_{random.randint(1, 1000)}",
                'item_description': f"Description for Item_{random.randint(1, 1000)}",
                'item_price': round(random_float(0.99, 99.99), 2),
                'purchase_date': datetime.now(),
                'purchase_time': datetime.now(),
                'game_specific_data': {
                    'stat_boost': random.choice(['strength', 'agility', 'intelligence']),
                    'duration': random.randint(600, 3600),
                    'level_requirement': random.randint(1, 50),
                },
            }

            # Insert the test data into the inGamePurchases collection
            db.InGamePurchasedItems.insert_one(purchase_data)

print("Test data inserted successfully!")

