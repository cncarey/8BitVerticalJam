class_name Move_States
extends Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	canMove = true
	canScroll = true
	distance = 0

@export var canMove = true:
	set(value):
		canMove = value
		canMove_changed.emit(canMove)
	get:
		return canMove

signal canMove_changed(canMove) 

@export var canScroll = true:
	set(value):
		canScroll = value
		canScroll_changed.emit(canScroll)
	get:
		return canScroll

signal canScroll_changed(canScroll) 

@export var distance = 0:
	set(value):
		distance = value
		distance_changed.emit(distance)
	get:
		return distance
		
signal  distance_changed(distance)
