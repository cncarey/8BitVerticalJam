class_name  building
extends Node2D

signal startBuilding()
signal leaveBuilding()

var margin = 8
var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")

@export var move : Move_States
@onready var spawner_component = $SpawnerComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var enemy_timer = $EnemyTimer
@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO when we make an enemy
	#enemy_timer.timeout.connect(onSpawn.bind(enemy_scene, enemy_timer,2))
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_inside_body_entered(body):
	move.canScroll = false
	startBuilding.emit()
	pass # Replace with function body.


func _on_inside_body_exited(body):
	move.canScroll = true
	leaveBuilding.emit()
	pass # Replace with function body.

func startTimers():
	pass

func onSpawn(enemy: PackedScene, timer: Timer, timeOffset: float = 1.0):
	if move.canMove:
		spawner_component.scene = enemy
		#TODO spawn closer to the building/ collision layer
		spawner_component.spawn(Vector2(randf_range(margin, screenWidth - margin), -16))
		
				
	var spawnRate = timeOffset # / (0.5 + (game_stats.score *0.01))	
	
	timer.start(spawnRate + randf_range(0.25, 0.5))
