extends MarginContainer

@export var game_stats: Game_Stats

@export var Happy: Texture
@export var Neutral: Texture
@export var Sad: Texture

@onready var mood_sprite = %MoodSprite
@onready var health_value = %HealthValue
@onready var ammo_value = %AmmoValue
@onready var food_value = %FoodValue
@onready var health_pack_value = %HealthPackValue


# Called when the node enters the scene tree for the first time.
func _ready():
	mood_sprite.texture = Neutral
	updateHealth(game_stats.curHealth)
	updateAmmo(game_stats.ammo)
	updateFood(game_stats.food)
	updateMood(game_stats.mood)
	updateHealthPacks(game_stats.healthPack)
	
	game_stats.ammo_changed.connect(updateAmmo)
	game_stats.curHealth_changed.connect(updateHealth)
	game_stats.food_changed.connect(updateFood)
	game_stats.mood_changed.connect(updateMood)
	game_stats.healthPack_changed.connect(updateHealthPacks)
	pass # Replace with function body.

func updateHealth(health: int):
	health_value.text = str(health)
	
func updateAmmo(ammo: int):
	ammo_value.text = str(ammo)
	
func updateFood(food: int):
	food_value.text = str(food)
	
func updateHealthPacks(healthPacks: int):
	health_pack_value.text = str(healthPacks)
	
func updateMood(mood: int):
	#TODO
	pass

