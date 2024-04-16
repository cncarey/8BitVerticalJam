extends Node2D

@onready var pause_menu = $ui/PauseMenu
@export var move = Move_States

@export var stumbleDialogues : DialogueResource
@export var fightDialogues : DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready():
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
	move.canMove = false
	
	DialogueManager.show_dialogue_balloon(fightDialogues, "Start")
	#TODO level complete
	pass # Replace with function body.
