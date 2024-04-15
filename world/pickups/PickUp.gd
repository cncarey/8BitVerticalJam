class_name PickUp
extends Node2D

var pickedUp = false
@export var game_stats: Game_Stats

@onready var flash_component = $FlashComponent
@onready var hurtbox_component = $HurtboxComponent

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var pickUpSound = $VariablePitchAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(onPickUp)
	pass # Replace with function body.

func onPickUp(hb: HitboxComponent):
	flash_component.flash()
	var pType = randi_range(1, 3)
	
	match pType:
		1:
			game_stats.ammo += 10
			pass
		2: 
			game_stats.food += 1
			pass
		3:
			game_stats.healthPack += 1
			pass
		
	await get_tree().create_timer(.5).timeout
	queue_free()
	#await pickUpSound.play_with_variance()
	#TODO pick a random type to be and update the correstponding stat
