extends Node2D

@onready var camera : Camera2D= $Camera2D
@onready var pause_menu = $ui/PauseMenu
@export var move = Move_States

@export var stumbleDialogues : DialogueResource
@export var fightDialogues : DialogueResource
@export var dialogueTemplate : PackedScene

@export var randEventCount : int = 1
@export var curEventCount : int = 0
@onready var level_transition = $LevelTransition

# Called when the node enters the scene tree for the first time.
func _ready():
	level_transition.fadeFromBlack()
	randomize()
	
	randEventCount = randi_range(2, 4)
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pause"):
		pause()
		
func pause():
	get_tree().paused = !get_tree().paused 
	pause_menu.visible = !pause_menu.visible
	
func resumePressed():
	get_tree().paused = false
	pause_menu.visible = !pause_menu.visible
	pass


func _on_progress_bar_total_distance_covered():
	startRandEvent()
	
func startRandEvent():
	move.canMove = false
	move.canScroll = false
	var randEvent = randi_range(1, 6)
	var event = ""
	
	match randEvent:
		1: event = "FightBandits"
		2: event = "FarmTrip"
		3: event = "GroceryTrip"
		_: event = "RandomSimple"
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon_scene(dialogueTemplate, fightDialogues, event)
	
func _on_dialogue_ended(_resource: DialogueResource):
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	await get_tree().create_timer(1).timeout
	
	move.canMove = true
	move.canScroll = true
	curEventCount += 1
	
	if move.distance >= 100 && curEventCount >= randEventCount :
		move.distance = 0
		
		#TODO navigate to the between scene
		level_transition.fadeToBlack()
		get_tree().reload_current_scene()
	else:
		startRandEvent()
