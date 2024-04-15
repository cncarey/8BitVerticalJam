extends Node2D

@export var move : Move_States

@export var zombieScene : PackedScene
@export var ammoScene : PackedScene
@export var healthScene : PackedScene
@export var building1Scene: PackedScene
@export var building2Scene: PackedScene
@export var building3Scene: PackedScene
@export var building4Scene: PackedScene
@export var building5Scene: PackedScene

@onready var spawner_component = $SpawnerComponent
@onready var enemy_timer = $EnemyTimer
@onready var building_timer = $BuildingTimer
@onready var ammo_timer = $AmmoTimer

var margin = 8
var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")


# Called when the node enters the scene tree for the first time.
func _ready():
	move.canScroll_changed.connect(pauseTimers)
	enemy_timer.timeout.connect(onSpawn.bind(zombieScene, enemy_timer,2))
	building_timer.timeout.connect(onBuildingSpawn.bind(building_timer, 8))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pauseTimers(state: bool):
	if state:
		enemy_timer.start()
		building_timer.start()
		ammo_timer.start()
	else:
		enemy_timer.stop()
		building_timer.stop()
		ammo_timer.stop()

func onBuildingSpawn(timer: Timer, timeOffset: float = 1.0):
	#TODO pick a building and do on spawn
	
	if move.canMove:
		spawner_component.scene = building1Scene
		#TODO back it up based on the size of the scence
		#we could cheat and keep a cheat sheet instead of calulating it
		spawner_component.spawn(Vector2( 5, -200))
		
	var spawnRate = timeOffset / (0.5 + (move.distance *0.01))	
	
	timer.start(spawnRate + randf_range(0.25, 0.5))
	pass		
		
func onSpawn(scene: PackedScene, timer: Timer, timeOffset: float = 1.0):
	if move.canMove:
		spawner_component.scene = scene
		spawner_component.spawn(Vector2(randf_range(margin, screenWidth - margin), -16))
		
	var spawnRate = timeOffset / (0.5 + (move.distance *0.01))	
	
	timer.start(spawnRate + randf_range(0.25, 0.5))
