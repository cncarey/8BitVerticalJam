class_name  building
extends Node2D

signal startBuilding()
signal leaveBuilding()

var margin = 8
var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")

@export var barrel : PackedScene
@export var box : PackedScene
@export var vase : PackedScene
@export var pickUp : PackedScene

@export var move : Move_States
@onready var spawner_component = $SpawnerComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var enemy_timer = $EnemyTimer
@export var enemy_scene : PackedScene
@onready var collectables = $collectables


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

func pick_rand_number(list: Array, amount: int) -> Array:
	randomize()
	list.shuffle()
	var new_list: Array = []

	assert(amount <= list.size(), "The number cannot be greater than the size of the Array")

	for i in range(amount):
		if new_list.size() <= amount:
			new_list.append(list[i])
	return new_list


func placeCollectables(collectableCount):
	
	var items = pick_rand_number(collectables.get_children(), collectableCount)
	for iP in items :
		var iType = randi_range(1,4)
		
		match iType:
			4: 
				spawner_component.scene = pickUp
				pass
			3:
				spawner_component.scene = barrel
				pass
			2: 
				spawner_component.scene = box
				pass
			1:
				spawner_component.scene = vase
				pass
		
		#set the scroll to the created child to that of the parent
		var newItem = spawner_component.spawn(iP.global_position, self)
		pass
