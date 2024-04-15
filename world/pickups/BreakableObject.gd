extends Node2D

@export var state = 1

@onready var animation_player = $AnimatedSprite2D
@onready var flash_component = $FlashComponent
@onready var breakSound = $VariablePitchAudioStreamPlayer
@onready var hurtbox_component = $HurtboxComponent
@onready var spawner_component = $SpawnerComponent



# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox_component.hurt.connect(onBreak)
	animation_player.play("default")
	animation_player.animation_finished.connect(animtionFinished)
	pass # Replace with function body.

func onBreak(hb):
	state = 2
	flash_component.flash()
	if breakSound != null:
		breakSound.play_with_variance()
	
	animation_player.play("break")

func animtionFinished():
	match state:
		1:
			pass
		2:
			state = 3
			animation_player.play("broken")
			pass
		3:
			hurtbox_component.is_invincible = true
			if randi_range(1,2) == 1:
				spawner_component.spawn(global_position, get_parent())
			pass
