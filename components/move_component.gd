class_name MoveComponent
extends Node

@export var move : Move_States
@export var actor: Node2D
@export var velocity: Vector2
@export var origVelocity: Vector2

@export var isScrollable: bool = false

func resetVelocity():
	velocity = Vector2(origVelocity.x, origVelocity.y)

func _process(delta: float) -> void:
	if move.canMove && (move.canScroll if isScrollable else true):
		actor.translate(velocity * delta)
