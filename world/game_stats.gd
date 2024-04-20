extends Node


var camera : Camera2D

@onready var shakeSettings : float = .3 : 
	set (value):
		shakeSettings = value
	get:
		return shakeSettings

@onready var isGameOver : bool = false : 
	set (value):
		isGameOver = value
	get:
		return isGameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	isGameOver = false
	score = 0
	ammo = 250
	curHealth = 5
	curHealthMax = 5
	healthPack = 0
	food = 0
	mood = 5
	day = 0
	
@export var dayStart = {
	"ammo" = 250,
	"food" = 0,
	"healthPack" = 0,
	"mood" = 5,
	"score" = 0
}

func setStartOfDayStats():
	day += 1
	dayStart["ammo"] = ammo
	dayStart["healthPack"] = healthPack
	dayStart["food"] = food
	dayStart["mood"] = mood
	dayStart["score"] = score

@export var day = 0:
	set(value):
		day = value
	get:
		return day

@export var score = 0:
	set(value):
		score = value
		score_changed.emit(score)
	get:
		return score
		
@export var ammo = 250 : 
	set(value):
		ammo = value
		
		# Signal out that the health has changed
		ammo_changed.emit(ammo)
		# Signal out when health is at 0
		if ammo <= 0: 
			no_ammo.emit()
	get:
		return ammo
			
func tryTakeAmmo(dec: int) -> bool:
	if ammo - dec < 0:
		return false
	else:
		ammo -= dec
		return true

@export var comboCounter = 1:
	set(value):
		comboCounter = value
		comboCounter_changed.emit(comboCounter)
	get:
		return comboCounter

@export var curHealth = 5:
	set(value):
		curHealth = value
		curHealth_changed.emit(curHealth)
	get:
		return curHealth
		
@export var curHealthMax = 5:
	set(value):
		curHealthMax = value
		curHealthMax_changed.emit(curHealthMax)
	get:
		return curHealthMax
		
@export var healthPack = 0:
	set(value):
		healthPack = value
		healthPack_changed.emit(healthPack)
	get:
		return healthPack
		
func tryTakehealthPack(dec: int) -> bool:
	if healthPack - dec < 0:
		return false
	else:
		healthPack -= dec
		return true
		
@export var food = 0:
	set(value):
		food = value
		food_changed.emit(food)
	get:
		return food
		
@export var mood = 5:
	set(value):
		mood = clamp(value, 1 , 9)
		mood_changed.emit(mood)
	get:
		return mood

#TODO Food and moral

signal score_changed(score) 
signal ammo_changed(ammo)
signal comboCounter_changed(combo)
signal no_ammo()
signal curHealth_changed(health)
signal curHealthMax_changed(maxHealth)
signal food_changed(food)
signal mood_changed(mood)
signal healthPack_changed(healthPacks)
