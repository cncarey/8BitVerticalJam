class_name Enemy
extends CharacterBody2D

@onready var ani = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var stats_component = $StatsComponent as StatsComponent
#@onready var move_component = $MoveComponent as MoveComponent
@onready var flash_component = $FlashComponent
@onready var shake_component = $ShakeComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var hitbox_component = $HitboxComponent
@onready var hurt_component = $HurtComponent
@onready var hitSound = $VariablePitchAudioStreamPlayer
@onready var player_detection = $PlayerDetection

@export var move : Move_States
@export var origVelocity : Vector2

func _ready():
	stats_component.no_health.connect(onNoHealth)
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(onHurt)
	#hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
	pass # Replace with function body.

func onHurt(hb):
	flash_component.flash()
	shake_component.tween_shake()
	#TODO when i find a good sounds
	#hitSound.play_with_variance()
	pass

func onNoHealth():
	#change to blood splatter/play zombie death
	#turn off collisions hurt/hit boxes
	
	queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !move.canMove: return
	
	var player = player_detection.player
	if player != null:
		moveToPoint(player.global_position, delta)
	elif move.canMove:
		#translate(origVelocity * delta)
		velocity = velocity.move_toward(origVelocity, 100 * delta)
	
	
	if velocity.x < 0:
		ani.flip_h = true
	else:
		ani.flip_h = false
		
	move_and_slide()

func moveToPoint(point: Vector2, delta):
	var direction = (self.global_position).direction_to(point).normalized()
	velocity = velocity.move_toward(direction * origVelocity.y, 100 * delta)
	pass
