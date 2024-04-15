# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

# Create the health variable and connect a setter
@export var activeShield : bool = false:
	set (value):
		activeShield = value
		activeShieldChange.emit(activeShield)
	get:
		return activeShield

@export var maxHealth : float = 0:
	set (value):
		maxHealth = value
		maxHealthChange.emit(maxHealth)
	get:
		return maxHealth
		
@export var health = maxHealth : 
	set(value):
		health = value
		
		# Signal out that the health has changed
		health_changed.emit(health)
		# Signal out when health is at 0
		if health <= 0: 
			no_health.emit()
	get:
		return health
		
		
func tryAddHealth(increase) -> bool:
	if health == maxHealth || health + increase > maxHealth:
		return false
	else:
		health += 1
		return true
		
func tryActiveateShield() -> bool:
	if activeShield:
		return false
	else:
		activeShield = true
		return true		
# Create our signals for health
signal health_changed(health) # Emit when the health value has changed
signal no_health() # Emit when there is no health left
signal maxHealthChange(health)
signal activeShieldChange(activeShield)

func resetPlayerHealth():
	self.health = 0
	self.maxHealth = 0
	
