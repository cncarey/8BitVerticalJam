class_name PickUp
extends Node2D

var pickedUp = false
@export var game_stats: Game_Stats
@export var move_stats: Move_States
@export var pickUpType: int

@onready var flash_component = $FlashComponent
@onready var hurtbox_component = $HurtboxComponent

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var pickUpSound = $VariablePitchAudioStreamPlayer
@onready var move_component = $MoveComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	if pickUpType == 0:
		move_component.ignore = true
	else:
		move_stats.canScroll_changed.connect(setSrcollable)
		
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(onPickUp)
	pass # Replace with function body.

func setSrcollable(isScrolling):
	if pickUpType != 0:
		move_component.isScrollable = !isScrolling

func onPickUp(hb: HitboxComponent):
	flash_component.flash()
	var pType = pickUpType if pickUpType != 0 else randi_range(1, 3)
	
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
