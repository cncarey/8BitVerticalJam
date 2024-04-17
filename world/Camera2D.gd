extends Camera2D

@export var tilemap :TileMap

#@export var randStrength: float = 30.0
@export var shakeFade : float = 5.0

var rng = RandomNumberGenerator.new()
var shakeStrength: float = 0.0

func _ready():
	GameStats.camera = self
	
func _process(delta):
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0 , shakeFade * delta)
		
		offset = getRandOffset()
	pass	

func getRandOffset():
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))	


func shake(time : float, amount : float):
	shakeStrength = amount * GameStats.shakeSettings
	shakeFade = time
	
	pass
