extends Node2D

@export var move : Move_States

@export var zombieScene : PackedScene
@export var pickupScene : PackedScene

@export var building1Scene: PackedScene
@export var building2Scene: PackedScene
@export var building3Scene: PackedScene
@export var building4Scene: PackedScene
@export var building5Scene: PackedScene

@onready var spawner_component = $SpawnerComponent
@onready var enemy_timer = $EnemyTimer
@onready var ammo_timer = $AmmoTimer

var margin = 13
var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")

var hasBuilding1Swaned = false
signal building1Swaned()

var hasBuilding2Swaned = false
signal building2Swaned()

var hasBuilding3Swaned = false
signal building3Swaned()

# Called when the node enters the scene tree for the first time.
func _ready():
	move.canMove_changed.connect(pauseMoveTimers)
	move.canScroll_changed.connect(pauseScrollTimers)
	move.distance_changed.connect(onDistance)
	enemy_timer.timeout.connect(onEnemySpawn.bind(zombieScene, enemy_timer,2))
	ammo_timer.timeout.connect(onAmmoSpawn.bind(ammo_timer, 8))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pauseMoveTimers(state: bool):
	if state:
		enemy_timer.start()
		ammo_timer.start()
	else:
		enemy_timer.stop()
		ammo_timer.stop()

func pauseScrollTimers(state: bool):
	if state:
		ammo_timer.start()
	else:
		ammo_timer.stop()


func onDistance(distance):
	if distance >= 75:
		if !hasBuilding3Swaned:
				hasBuilding3Swaned = true
				onBuildingSpawn()
				building3Swaned.emit()
	elif distance >= 50:
		if !hasBuilding2Swaned:
				hasBuilding2Swaned = true
				onBuildingSpawn()
				building2Swaned.emit()
	elif distance >= 25:
		if !hasBuilding1Swaned:
				hasBuilding1Swaned = true
				onBuildingSpawn()
				building1Swaned.emit()

func onBuildingSpawn():
	#TODO pick a building and do on spawn
	
	if move.canMove:
		var bType = randi_range(1, 2)
		
		match bType:
			1:
				spawner_component.scene = building1Scene
				pass
			2: 
				spawner_component.scene = building2Scene
				pass
		
		#TODO back it up based on the size of the scence
		#we could cheat and keep a cheat sheet instead of calulating it
		spawner_component.spawn(Vector2( 5, -200))
	
	pass		
		
func onEnemySpawn(scene: PackedScene, timer: Timer, timeOffset: float = 1.0):
	if move.canMove:
		spawner_component.scene = scene
		spawner_component.spawn(Vector2(randf_range(margin, screenWidth - margin), -16))
		
	respawn(timer, timeOffset)
	
func onAmmoSpawn(timer: Timer, timeOffset: float = 1.0):
	if move.canMove:
		var ammo = pickupScene.instantiate()
		ammo.pickUpType = 1
		get_tree().current_scene.add_child(ammo)
		ammo.global_position = Vector2(randf_range(margin+12, screenWidth - (margin +12)), -16)
		
	respawn(timer, timeOffset)
	
func respawn(timer: Timer, timeOffset: float = 1.0):	
	var spawnRate = timeOffset / (0.5 + (move.distance *0.01))	
	
	timer.start(spawnRate + randf_range(0.25, 0.5))
