extends Node2D
@export var openingDialogues : DialogueResource
@export var dialogueTemplate : PackedScene

@onready var level_transition = $LevelTransition
@onready var radio = $radio
@onready var flash_component = $FlashComponent
@onready var ani = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	level_transition.fadeFromBlack()
	ani.play("RadioCall")
	pass # Replace with function body.

func radioMessage():
	ani.play("Idle")
	#TODO play the radio message
	pass

func flashRadio():
	flash_component.flash()
	radio.play()
	
	await get_tree().create_timer(1).timeout
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon_scene(dialogueTemplate, openingDialogues, "Start")
	pass

func _on_dialogue_ended(_resource: DialogueResource):
	level_transition.fadeToBlack()
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://world/world.tscn")

func getGun():
	#TODO make gun visible
	pass
