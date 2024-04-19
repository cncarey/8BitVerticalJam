extends AnimatedSprite2D

func _ready():
	play("default")
	#GameStats.camera.shake(5.0, 10.0)
	pass
	
func explosionEnd():
	queue_free()
