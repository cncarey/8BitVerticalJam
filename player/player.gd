extends CharacterBody2D

enum playerStates { Move, Dashing, Attack, DashingAttack, Dead}
enum worldLocations { Inside, Grass, Sand}


@export var footstepLocation : worldLocations = worldLocations.Grass

@export var acceleration = 250
@export var friction = 450

@export var maxSpeed = 100
@export var dashSpeed = 250
@export var game_stats: Game_Stats
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



func _physics_process(delta):
	#if Global.isTalking:
	#	return
	ani_gun.look_at(get_global_mouse_position())
	
	match state:
		playerStates.Move:
			moveState(delta)
			pass
		playerStates.Dashing:
			#dashState(delta)
			pass
		playerStates.DashingAttack:
			#rollingAttackState(delta)
			pass
		playerStates.Attack:
			#attackState(delta)
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
					
			
		
		dashVector = inputDirection
		#swordHitbox.knockbackVector = inputDirection
		ani_body.play("walk")
		if velocity.x < 0:
			ani_body.flip_h = true
		else:
			ani_body.flip_h = false
		
		
		#if we switch this to an animation tree set teh blend positions
		#aniTree.set("parameters/Idle/blend_position", inputDirection)
		#aniTree.set("parameters/Run/blend_position", inputDirection)
		#aniTree.set("parameters/Attack/blend_position", inputDirection)
		#aniTree.set("parameters/Death/blend_position", inputDirection)
		
		velocity += (inputDirection * maxSpeed * delta)
		velocity = velocity.limit_length(maxSpeed)
	
	#we may not need this because you should be able to run and gun		
	if Input.is_action_just_pressed("shoot"):
		ani_body.play("shoot")
		
	move_and_slide()


func _input(event: InputEvent) -> void:
	if move.canMove:
		if event.is_action_pressed("shoot"):
			if game_stats.tryTakeAmmo(1):
				fireGun()

func fireGun():
	#laserSound.play_with_variance()
	var b = bullet_component.scene.instantiate()
	
	b.global_position = muzzle.global_position
	b.global_rotation = ani_gun.global_rotation
	get_tree().current_scene.add_child(b)
