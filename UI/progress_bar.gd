extends ProgressBar

@export var move : Move_States

@export var maxDistance : float = 100 :
	set (value):
		maxDistance = max(value, 1)
		if self != null:
			self.max_value = maxDistance

@onready var curDistance = 0 : 
	set (value):
		
		curDistance = value
		#curDistance = clamp(value, 0, maxHealth)
		if self != null:
			self.value = curDistance
		
		if(curDistance >= maxDistance):
			totalDistanceCovered.emit()
			pass
	get:
		return curDistance

signal totalDistanceCovered()

# Called when the node enters the scene tree for the first time.
func _ready():
	move.connect("distance_changed",setCurDistance)
	pass # Replace with function body.

func setCurDistance(d):
	curDistance = d
