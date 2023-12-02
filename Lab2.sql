{
  _id: ObjectID,
  user_id: integer,
  game_id: integer,
  item_id: integer,
  item_name: string,
  item_description: string,
  item_price: float,
  purchase_date: timestamp,
  purchase_time: timestamp,

}

// Example of an RPG in-game purchase
{
  _id: new ObjectId(),
  user_id: 1,
  game_id: 100,
  item_id: 101,
  item_name: "Strength Boost Potion",
  item_description: "Increase your character's strength by 50% for 30 minutes.",
  item_price: 5.99,
  purchase_date: new Date("2022-08-01"),
  purchase_time: new Date("2022-08-01T15:30:00"),
  game_specific_data: {
    stat_boost: "strength",
    duration: 1800, // 30 minutes in seconds
    level_requirement: 10,
  },
}

// Example of a Farm Simulator in-game purchase
{
  _id: new ObjectId(),
  user_id: 2,
  game_id: 200,
  item_id: 201,
  item_name: "Super Fertilizer",
  item_description: "Make your crops grow 25% faster and increase your machine's durability.",
  item_price: 9.99,
  purchase_date: new Date("2022-08-02"),
  purchase_time: new Date("2022-08-02T10:15:00"),
  game_specific_data: {
    crop_growth_speed: 1.25,
    machine_durability: 1.1,
    animal_friendly: true,
  },
}