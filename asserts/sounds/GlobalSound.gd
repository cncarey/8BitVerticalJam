extends Node2D

var rainVol = -2
@onready var rain = $Rain
@onready var ambiance = $Ambiance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startRain():
	rain.play(0.0)
	pass

func stopRain():
	#if vol is
	rain.stop()
	pass
