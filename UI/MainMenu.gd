extends Control
@onready var main_container = %MainContainer
@onready var options_container = $OptionsContainer
@onready var level_transition = $LevelTransition


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func start():
	level_transition.fadeToBlack()
	get_tree().change_scene_to_file("res://UI/opening_scene.tscn")

func hideOptions():
	main_container.show()
	options_container.hide()
	
func showOptions():
	main_container.hide()
	options_container.show()
	
