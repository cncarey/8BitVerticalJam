extends BreakableObject
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D
@onready var explosion_affect = $ExplosionAffect
@onready var explosionSound = $VariablePitchAudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox_component.hurt.connect(onBreak)
	animation_player.play("default")
	animation_player.animation_finished.connect(animtionFinished)
	pass # Replace with function body.

func onBreak(hb):
	super.onBreak(hb)
	explosionSound.play_with_variance()
	GameStats.camera.shake(6.0, 2)
	collision_shape_2d.set_deferred("disabled", false)
	explosion_affect.visible = true
	explosion_affect.play("default")
	
func explosionEnd():
	collision_shape_2d.set_deferred("disabled", true)
	explosion_affect.visible = false
