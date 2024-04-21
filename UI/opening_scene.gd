extends Node2D
@onready var level_transition = $LevelTransition


# Called when the node enters the scene tree for the first time.
func _ready():
	level_transition.fadeFromBlack()
	pass # Replace with function body.

func radioMessage():
	#TODO play the radio message
	pass

func getGun():
	#TODO make gun visible
	pass
