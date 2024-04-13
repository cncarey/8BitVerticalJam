class_name MoveComponent
extends Node

@export var move : Move_States
@export var actor: Node2D
@export var velocity: Vector2

@export var isScrollable: bool = false

func _process(delta: float) -> void:
	if move.canMove && (move.canScroll if isScrollable else true):
		actor.translate(velocity * delta)
