extends Node2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent
@onready var hitbox_component = $HitboxComponent

@export var knockback = Vector2.ZERO
@export var speed = 750

# Called when the node enters the scene tree for the first time.
func _ready():
	
	match GameStats.mood:
		1, 2, 3:
			hitbox_component.damage = 1
			pass
		4, 5, 6:
			hitbox_component.damage = 2
			pass
		7, 8, 9:
			hitbox_component.damage = 3
			
	hitbox_component.knockBack = knockback
	scale_component.tween_scale()
	flash_component.flash()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_2d_body_entered(body):
	if body is TileMap:
		queue_free()
	pass # Replace with function body.

