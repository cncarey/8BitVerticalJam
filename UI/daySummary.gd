extends CanvasLayer
@export var Happy: Texture
@export var Neutral: Texture
@export var Sad: Texture

@onready var day_summary = %DaySummary
@onready var food_container = %FoodContainer
@onready var food_increase = %FoodIncrease

@onready var ammo_container = %AmmoContainer
@onready var ammo_increase = %AmmoIncrease

@onready var health_pack_container = %HealthPackContainer
@onready var health_pack_increased = %HealthPackIncreased

@onready var mood_start = %MoodStart
@onready var mood_end = %MoodEnd


@onready var zombie_killed = %ZombieKilled
@onready var success = %Success
@onready var fail = %Fail
@onready var game_over = %GameOver

@onready var end_day = %EndDay
@onready var restart_container = %RestartContainer
@onready var quit = %Quit

signal EndDay()
signal RwOpening()
signal RwoOpening()
signal Quit()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if GameStats.dayStart.has("food") && GameStats.dayStart["food"] != GameStats.food:
		food_container.visible = true
		food_increase.text = str(GameStats.dayStart["food"]) + " -> " + str(GameStats.food)
	if GameStats.dayStart.has("ammo") && GameStats.dayStart["ammo"] != GameStats.ammo:
		ammo_container.visible = true
		ammo_increase.text = str(GameStats.dayStart["ammo"]) + " -> " + str(GameStats.ammo)
	if GameStats.dayStart.has("healthPack") && GameStats.dayStart["healthPack"] != GameStats.healthPack:
		health_pack_container.visible = true
		health_pack_increased.text = str(GameStats.dayStart["healthPack"]) + " -> " + str(GameStats.healthPack)
	if GameStats.dayStart.has("mood"):
		setMood(GameStats.dayStart["mood"], mood_start)
	setMood(GameStats.mood, mood_end)
	zombie_killed.text = str(GameStats.score) + " Zombies killed"
	day_summary.text = "Day " + str(GameStats.day) + " Summary"
	
	setSuccessFail()
	pass # Replace with function body.

func EndDayPressed():
	EndDay.emit()
	
func QiutPressed():
	Quit.emit()
	
func RwOpeningPressed():
	RwOpening.emit()
	
func RwoOpeningPressed():
	RwoOpening.emit()
	
func setMood(mood: int, moodRect: TextureRect):
	match mood:
		1, 2, 3:
			moodRect.texture = Sad
			pass
		4, 5, 6:
			moodRect.texture = Neutral
			pass
		7, 8, 9:
			moodRect.texture = Happy

func setSuccessFail():
	if !GameStats.isGameOver:
		end_day.visible = true
	else:
		game_over.visible = true
		restart_container.visible = true
		quit.visible = true
		if GameStats.curHealth >= 1 && GameStats.day >= 3:
			success.visible = true
		else:
			fail.visible = true
	pass
	
