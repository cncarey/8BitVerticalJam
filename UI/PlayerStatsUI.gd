extends MarginContainer

@export var Happy: Texture
@export var Neutral: Texture
@export var Sad: Texture
@export var heartTexture: Texture

@onready var mood_sprite = %MoodSprite
@onready var ammo_value = %AmmoValue
@onready var food_value = %FoodValue
@onready var health_pack_value = %HealthPackValue
@onready var hearts_container = %HeartsContainer
@onready var heart = %Heart
@onready var empty_heart = %EmptyHeart


# Called when the node enters the scene tree for the first time.
func _ready():
	mood_sprite.texture = Neutral
	
	updateHealth(GameStats.curHealth)
	updateAmmo(GameStats.ammo)
	updateFood(GameStats.food)
	updateMood(GameStats.mood)
	updateHealthPacks(GameStats.healthPack)
	
	GameStats.ammo_changed.connect(updateAmmo)
	GameStats.curHealthMax_changed.connect(updateMaxHealth)
	GameStats.curHealth_changed.connect(updateHealth)
	GameStats.food_changed.connect(updateFood)
	GameStats.mood_changed.connect(updateMood)
	GameStats.healthPack_changed.connect(updateHealthPacks)
	pass # Replace with function body.

func updateHealth(health: int):
	updateHeartContainer(health, GameStats.curHealthMax)
	
func updateMaxHealth(maxHealth: int):
	updateHeartContainer(GameStats.curHealth, maxHealth)
	
func updateHeartContainer(health:int, maxHealth: int):
	hearts_container.columns = maxHealth
	for hc in hearts_container.get_children():
		hc.free()
		
	for i in range(health):
		var h :TextureRect = heart.duplicate()
		
		h.visible = true
		hearts_container.add_child(h)
		pass
	
	var emptys = clampi(maxHealth - health, 0 , maxHealth)
	for i in range(emptys):
		var eh :TextureRect = empty_heart.duplicate()
		
		eh.visible = true
		hearts_container.add_child(eh)
		pass
	
func updateAmmo(ammo: int):
	ammo_value.text = str(ammo)
	
func updateFood(food: int):
	food_value.text = str(food)
	
func updateHealthPacks(healthPacks: int):
	health_pack_value.text = str(healthPacks)
	
func updateMood(mood: int):
	#TODO
	pass

