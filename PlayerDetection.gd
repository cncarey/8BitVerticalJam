class_name PlayerDetectionComponent
extends Area2D

var player = null
@onready var shape = $CollisionShape2D

func _ready():
	pass

func canSeePlayer():
	return player != null
	
func _on_body_entered(body: Node2D):
	if body as CharacterBody2D:
		player = body
	pass # Replace with function body.

func _on_body_exited(body: Node2D):
	if body as CharacterBody2D:
		player = null
	pass # Replace with function body.

func changeShape():
	var s : Shape2D = shape.shape
	
	if s is CircleShape2D:
		s.radius = 200

