extends building


# Called when the node enters the scene tree for the first time.
func _ready():
	placeCollectables()
	
	pass # Replace with function body.

func placeCollectables():
	
	var items = pick_rand_number(collectables.get_children(), 4)
	for iP in items :
		var iType = randi_range(1,4)
		
		match iType:
			4: 
				spawner_component.scene = pickUp
				pass
			3:
				spawner_component.scene = barrel
				pass
			2: 
				spawner_component.scene = box
				pass
			1:
				spawner_component.scene = vase
				pass
		
		spawner_component.spawn(iP.global_position, self)
		pass
	
