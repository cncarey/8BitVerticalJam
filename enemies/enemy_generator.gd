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
	move.canMove_changed.connect(pauseTimers)
	move.distance_changed.connect(onDistance)
	enemy_timer.timeout.connect(onSpawn.bind(zombieScene, enemy_timer,2))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func pauseTimers(state: bool):
	if state:
		enemy_timer.start()
	else:
		enemy_timer.stop()

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
		
func onSpawn(scene: PackedScene, timer: Timer, timeOffset: float = 1.0):
	if move.canMove:
		spawner_component.scene = scene
		spawner_component.spawn(Vector2(randf_range(margin, screenWidth - margin), -16))
		
	var spawnRate = timeOffset / (0.5 + (move.distance *0.01))	
	
	timer.start(spawnRate + randf_range(0.25, 0.5))
