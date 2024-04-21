extends CharacterBody2D

enum playerStates { Move, Dead}
enum worldLocations { Inside, Grass, Sand}


@export var footstepLocation : worldLocations = worldLocations.Grass

@export var acceleration = 250
@export var friction = 300

var KickbackVel = Vector2.ZERO
#TODO move to gun stats
@export var curKickbackSpeed = 50
@export var curKnockbackSpeed = 10
@export var curFireScreenShake = 5.0
@export var maxSpeed = 150

@export var move : Move_States

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var state = playerStates.Move
var dashVector = Vector2.DOWN

signal playerDeath()
var isDead: bool = false

@onready var ani_body = %AniBody
@onready var ani_gun = %AniGun
@onready var bullet_component = $bulletComponent
@onready var muzzle = %Muzzle
@onready var hurtbox_component = $HurtboxComponent
@onready var stats_component = $StatsComponent
@onready var invisibility_timer = $invisibilityTimer
@onready var flash_component = $FlashComponent
@onready var pistol_fire = $PistolFire

func _ready():
	stats_component.maxHealth = GameStats.curHealthMax
	stats_component.health = GameStats.curHealth
	
	stats_component.health_changed.connect(syncHealth)
	stats_component.maxHealthChange.connect(syncMaxHealth)
	stats_component.no_health.connect(onNoHealth)
	GameStats.mood_changed.connect(onMoodChange)
	hurtbox_component.hurt.connect(onHurt)
	invisibility_timer.timeout.connect(turnOffInvisibility)

func _physics_process(delta):
	if !move.canMove: return
	
	ani_gun.look_at(get_global_mouse_position())
	
	match state:
		playerStates.Move:
			moveState(delta)
			pass
		playerStates.Dead:
			#deathState(delta)
			pass

func moveState(delta):
	var inputDirection = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if  inputDirection == Vector2.ZERO:
		ani_body.play("idle")
		velocity = Vector2.ZERO
		addKickback()
		
		# stop playing footsteps based on ground type
		#grassSteps.stop()
		#floorSteps.stop()
		#stepTimer.stop()
	else:
		#if stepTimer.time_left <= 0:
			#match footstepLocation:
				#worldLocations.Grass:
					#grassSteps.pitch_scale = randf_range(0.8, 1.2)
					#grassSteps.play(0.5)
					#stepTimer.start(2)
					#pass
				#worldLocations.Inside, _:
					#floorSteps.pitch_scale = randf_range(0.8, 1.2)
					#floorSteps.play(0.8)
					#stepTimer.start(1.3)
					#pass
					
		ani_body.play("walk")
		if velocity.x < 0:
			ani_body.flip_h = true
		else:
			ani_body.flip_h = false
		
		velocity += (inputDirection * maxSpeed * delta)
		if addKickback():
			velocity = velocity.limit_length(maxSpeed/3)
		else:
			velocity = velocity.limit_length(maxSpeed/2)
		
	#we may not need this because you should be able to run and gun		
	if Input.is_action_just_pressed("shoot"):
		ani_body.play("shoot")
	move_and_slide()


func _input(event: InputEvent) -> void:
	if move.canMove:
		if event.is_action_pressed("shoot"):
			if GameStats.tryTakeAmmo(1):
				KickbackVel= (global_position - get_global_mouse_position()).normalized() * curKickbackSpeed
				fireGun()
				pistol_fire.play_with_variance()
				GameStats.camera.shake(5.0, curFireScreenShake)
		if event.is_action_pressed("healthPack"):
			if GameStats.tryTakehealthPack(1):
				if !stats_component.tryAddHealth(1):
					GameStats.healthPack += 1
func addKickback() -> bool:
	if KickbackVel != Vector2.ZERO:
		velocity += KickbackVel
		KickbackVel = lerp(KickbackVel, Vector2.ZERO, 0.1)
		return true
	else:
		return false

func fireGun():
	#laserSound.play_with_variance()
	var b = bullet_component.scene.instantiate()
	#ani_gun.global_rotation is the knockback Vector
	b.knockback = (get_global_mouse_position() - global_position).normalized() * curKnockbackSpeed
	b.global_position = muzzle.global_position
	b.global_rotation = ani_gun.global_rotation
	get_tree().current_scene.add_child(b)

func onHurt(hb):
	flash_component.flash()
	stats_component.health -= hb.damage
	hurtbox_component.is_invincible = true
	invisibility_timer.start()
	
	pass

func turnOffInvisibility():
	hurtbox_component.is_invincible = false	
	
func syncHealth(health):
	GameStats.curHealth = health
	
func syncMaxHealth(maxHealth):
	GameStats.curHealthMax = maxHealth

func onNoHealth():
	playerDeath.emit()	
	
func onMoodChange(mood):
	match mood:
		1, 2, 3:
			stats_component.maxHealth = 4
			pass
		4, 5, 6:
			stats_component.maxHealth = 5
			pass
		7, 8, 9:
			stats_component.maxHealth = 6
	pass
