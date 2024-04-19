extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var scale_component = $ScaleComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	var frameI = randi_range(0, 15)
	animated_sprite_2d.frame = frameI
	scale_component.tween_scale()
	pass # Replace with function body.


func onTimeout():
	#fadeout
	queue_free()
	pass
