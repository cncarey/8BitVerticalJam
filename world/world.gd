extends Node2D

@onready var camera : Camera2D= $Camera2D
@onready var pause_menu = $ui/PauseMenu
@onready var pause_sound = %PauseSound
@onready var unpause_sound = $UnpauseSound

@export var move = Move_States

@export var stumbleDialogues : DialogueResource
@export var fightDialogues : DialogueResource
@export var dialogueTemplate : PackedScene
@export var daySummary : PackedScene

@export var randEventCount : int = 1
@export var curEventCount : int = 0
@onready var level_transition = $LevelTransition

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.startRain()
	GameStats.setStartOfDayStats()
	level_transition.fadeFromBlack()
	randomize()
	
	randEventCount = randi_range(2, 4)
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("pause"):
		pause()
		pause_sound.play()
		
func pause():
	get_tree().paused = !get_tree().paused 
	pause_menu.visible = !pause_menu.visible
	
func resumePressed():
	get_tree().paused = false
	unpause_sound.play()
	pause_menu.visible = !pause_menu.visible
	pass


func _on_progress_bar_total_distance_covered():
	startRandEvent()
	
func startRandEvent():
	move.canMove = false
	move.canScroll = false
	randomize()
	var randEvent = randi_range(1, 10)
	var event = ""
	
	match randEvent:
		1: event = "FightBandits"
		2: event = "FarmTrip"
		3: event = "GroceryTrip"
		4: event = "DesertedBaracade" #TODO
		5: event = "DerelictTown" #TODO
		6: event = "SurvivorHealthPacks" #TODO
		_: event = "RandomSimple"
		
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon_scene(dialogueTemplate, fightDialogues, event)
	
func _on_dialogue_ended(_resource: DialogueResource):
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	await get_tree().create_timer(1).timeout
	
	curEventCount += 1
	
	if move.distance >= 100 && curEventCount >= randEventCount :
		move.distance = 0
		
		if GameStats.day >= 3:
			onGameOver()
		else:
			endOfDay()
	else:
		startRandEvent()

func endOfDay():
	DialogueManager.dialogue_ended.connect(endOfDayDialogeEnd)
	DialogueManager.show_dialogue_balloon_scene(dialogueTemplate, fightDialogues, "EndOfDay")
	
	#eat too food
	#add extra mood
	pass	
func endOfDayDialogeEnd(_resource: DialogueResource):
	level_transition.fadeToBlack()
	var ds = daySummary.instantiate()
	get_tree().current_scene.add_child(ds)
	ds.EndDay.connect(closeDaySummary)
	
func closeDaySummary():
	move.canMove = true
	move.canScroll = true
	await get_tree().create_timer(1).timeout
	
	get_tree().reload_current_scene()
	pass

func onGameOver():
	
	if GameStats.isGameOver:
		return
	
	move.canMove = false
	move.canScroll = false
	GameStats.isGameOver = true
	
	level_transition.fadeToBlack()
	var ds = daySummary.instantiate()
	get_tree().current_scene.add_child(ds)
	ds.EndDay.connect(closeDaySummary)
	ds.RwOpening.connect(restartWithOpening)
	ds.RwoOpening.connect(restartWithoutOpening)
	ds.Quit.connect(backToMainMenu)
	pass

func onResetGame():
	GameStats.reset()
	move.canMove = true
	move.canScroll = true
	move.distance = 0

func backToMainMenu():
	GlobalSound.stopRain()
	onResetGame()
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	pass
	
func restartWithOpening():
	onResetGame()
	get_tree().change_scene_to_file("res://UI/opening_scene.tscn")
	pass
	
func restartWithoutOpening():
	onResetGame()
	get_tree().reload_current_scene()
	pass
