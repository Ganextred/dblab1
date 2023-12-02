CREATE TABLE "users" (
  "id" integer,
  "username" varchar,
  "email" varchar,
  "password" varchar,
  "created_at" timestamp,
  "region_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "games" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "description" text,
  "release_date" date,
  "developer_id" integer,
  "publisher_id" integer,
  "platform_id" integer,
  "price" float,
  "rating" float,
  "engine_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "developers" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "founded_date" date,
  "website" varchar,
  "country" varchar,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "publishers" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "founded_date" date,
  "website" varchar,
  "country" varchar,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "platforms" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "manufacturer" varchar,
  "release_date" date,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "genres" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "reviews" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "body" text,
  "rating" integer,
  "user_id" integer,
  "game_id" integer,
  "created_at" timestamp,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "game_platforms" (
  "game_id" integer,
  "platform_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "game_genres" (
  "game_id" integer,
  "genre_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "favorite_games" (
  "user_id" integer,
  "game_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "game_purchases" (
  "user_id" integer,
  "game_id" integer,
  "purchase_date" date,
  "price" float,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "engine" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "developer_id" integer,
  "release_date" date,
  "version" varchar,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "engine_platforms" (
  "engine_id" integer,
  "platform_id" integer,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "region" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "code" varchar,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "game_publishing" (
  "id" integer PRIMARY KEY,
  "game_id" integer,
  "publisher_id" integer,
  "platform_id" integer,
  "region_id" integer,
  "release_date" date,
  "updated_at" timestamp,
  "updated_by" integer
);

CREATE TABLE "inGamePurchasedItems" (
  "id" integer PRIMARY KEY,
  "user_id" integer,
  "game_id" integer,
  "item_id" integer,
  "item_name" varchar,
  "item_description" varchar,
  "item_price" float,
  "purchase_date" date,
  "purchase_time" timestamp,
  "game_specific_data" json
);

ALTER TABLE "games" ADD FOREIGN KEY ("developer_id") REFERENCES "developers" ("id");

ALTER TABLE "games" ADD FOREIGN KEY ("publisher_id") REFERENCES "publishers" ("id");

ALTER TABLE "games" ADD FOREIGN KEY ("platform_id") REFERENCES "platforms" ("id");

ALTER TABLE "games" ADD FOREIGN KEY ("engine_id") REFERENCES "engine" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "game_platforms" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "game_platforms" ADD FOREIGN KEY ("platform_id") REFERENCES "platforms" ("id");

ALTER TABLE "game_genres" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "game_genres" ADD FOREIGN KEY ("genre_id") REFERENCES "genres" ("id");

ALTER TABLE "favorite_games" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "favorite_games" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "game_purchases" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "game_purchases" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "engine_platforms" ADD FOREIGN KEY ("engine_id") REFERENCES "engine" ("id");

ALTER TABLE "engine_platforms" ADD FOREIGN KEY ("platform_id") REFERENCES "platforms" ("id");

ALTER TABLE "engine" ADD FOREIGN KEY ("developer_id") REFERENCES "developers" ("id");

ALTER TABLE "game_publishing" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

ALTER TABLE "game_publishing" ADD FOREIGN KEY ("publisher_id") REFERENCES "publishers" ("id");

ALTER TABLE "game_publishing" ADD FOREIGN KEY ("platform_id") REFERENCES "platforms" ("id");

ALTER TABLE "game_publishing" ADD FOREIGN KEY ("region_id") REFERENCES "region" ("id");

ALTER TABLE "users" ADD FOREIGN KEY ("region_id") REFERENCES "region" ("id");

ALTER TABLE "inGamePurchasedItems" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "inGamePurchasedItems" ADD FOREIGN KEY ("game_id") REFERENCES "games" ("id");

CREATE INDEX inGamePurchasedItems_user_id_idx ON inGamePurchasedItems (user_id);