class_name PickUp
extends Node2D

var pickedUp = false
@export var game_stats: Game_Stats

@onready var animation_player = $AnimationPlayer
@onready var flash_component = $FlashComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var hitbox_component = $HitboxComponent

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var pickUpSound = $VariablePitchAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	pass # Replace with function body.

func onPickUp():
	flash_component.flash()
	await pickUpSound.play_with_variance()
