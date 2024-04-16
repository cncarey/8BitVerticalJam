extends Control
@onready var main_container = %MainContainer
@onready var options_container = $OptionsContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func start():
	#TODO opening cut scene
	get_tree().change_scene_to_file("res://world/world.tscn")

func hideOptions():
	main_container.show()
	options_container.hide()
	
func showOptions():
	main_container.hide()
	options_container.show()
	
