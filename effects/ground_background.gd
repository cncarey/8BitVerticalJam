extends ParallaxBackground

@onready var ground_layer = $GroundLayer
@export var move : Move_States

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void:
	if move.canScroll:
		ground_layer.motion_offset.y += 20 * delta
		move.distance += 1.5 * delta
