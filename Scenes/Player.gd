extends CharacterBody2D

class_name Player

const SPEED = 150.0
const ROLL_SPEED = 400.0
const JUMP_VELOCITY = -400.0

var anim = ""
var new_anim = ""

var health = 100
var state = PLAYER_STATE.STATE_IDLE
var roll_direction = Vector2.DOWN

var enemy_in_hitbox = false
var damage_cooldown = false
var follow_traget = false
var target: CollisionShape2D

@onready var actionable_finder: Area2D = get_node("ActionableFinder")

func _physics_process(_delta):
	
	if follow_traget:

		position += (target.global_position - position)
		new_anim = "walking"
		move_and_slide()
		return
	
	taken_damage()
	
	## PROCESS STATES
	match state:
		PLAYER_STATE.STATE_BLOCKED:
			new_anim = "idle"
			pass
		PLAYER_STATE.STATE_IDLE:
			if (
					Input.is_action_pressed("move_down") or
					Input.is_action_pressed("move_left") or
					Input.is_action_pressed("move_right") or
					Input.is_action_pressed("move_up")
				):
					state = PLAYER_STATE.STATE_WALKING
			if Input.is_action_just_pressed("attack"):
				state = PLAYER_STATE.STATE_ATTACK
			if Input.is_action_just_pressed("roll"):
				state = PLAYER_STATE.STATE_ROLL
				roll_direction = Vector2(
						-int( Input.is_action_pressed("move_left") ) + int( Input.is_action_pressed("move_right") ),
						-int( Input.is_action_pressed("move_up") ) + int( Input.is_action_pressed("move_down") )
					).normalized()
				_update_facing()
			new_anim = "idle"
			pass
		PLAYER_STATE.STATE_WALKING:
			if Input.is_action_just_pressed("attack"):
				state = PLAYER_STATE.STATE_ATTACK
			if Input.is_action_just_pressed("roll"):
				state = PLAYER_STATE.STATE_ROLL
			
			var target_speed = Vector2()
			
			if Input.is_action_pressed("move_down"):
				target_speed += Vector2.DOWN
			if Input.is_action_pressed("move_left"):
				target_speed += Vector2.LEFT
			if Input.is_action_pressed("move_right"):
				target_speed += Vector2.RIGHT
			if Input.is_action_pressed("move_up"):
				target_speed += Vector2.UP
			
			target_speed *= SPEED
			# velocity = velocity.linear_interpolate(target_speed, 0.9)
			velocity = target_speed
			roll_direction = velocity.normalized()
			
			_update_facing()
			
			if velocity.length() > 5:
				new_anim = "walking" # For more directions add "walking_direction"
			else:
				goto_idle()
			pass
		PLAYER_STATE.STATE_ATTACK:
			new_anim = "slash_" + facing

		PLAYER_STATE.STATE_ROLL:
			if roll_direction == Vector2.ZERO:
				state = PLAYER_STATE.STATE_IDLE
			else:
 
				var target_speed = Vector2()
				target_speed = roll_direction
				target_speed *= ROLL_SPEED
				#velocity = velocity.linear_interpolate(target_speed, 0.9)
				velocity = target_speed
				#new_anim = "roll"
		PLAYER_STATE.STATE_DIE:
			new_anim = "die"
		PLAYER_STATE.STATE_HURT:
			new_anim = "hurt"
	
	## UPDATE ANIMATION
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite2D.play(anim)
	pass

	move_and_slide()

var facing = "down"
func _update_facing():
	if Input.is_action_pressed("move_left"):
		facing = "left"
	if Input.is_action_pressed("move_right"):
		facing = "right"
	if Input.is_action_pressed("move_up"):
		facing = "up"
	if Input.is_action_pressed("move_down"):
		facing = "down"
		
## HELPER FUNCS
func goto_idle():
	velocity = Vector2.ZERO
	new_anim = "idle"
	state = PLAYER_STATE.STATE_IDLE

func _on_animated_sprite_2d_animation_finished():
	# Reset after attack animation
	if state == PLAYER_STATE.STATE_ATTACK:
		goto_idle()

func _unhandled_input(_event):
	
	if Input.is_action_just_pressed("interact"):
		print("Test")
		var acionables = actionable_finder.get_overlapping_areas()
		for acionable in acionables:
			if acionable.has_method("action"):
				acionable.action()
				return
				
	if Input.is_action_just_pressed("attack"):
		$AudioStreamAttack.play(0.2)

func _on_area_2d_hitbox_body_entered(body):
	print("entered")
	if body.has_method("enemy"):
		enemy_in_hitbox = true

func taken_damage():
	if enemy_in_hitbox && !damage_cooldown:
		print("Damage")
		health = health - 10
		damage_cooldown = true
		$DamageBlink.play("hit_flash")
		$AudioStreamDamage.play(0.1)
		$"Timer-Damage".start()

func _on_area_2d_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_hitbox = false

func player():
	pass

func _on_timer_damage_timeout():
	damage_cooldown = false
	
func follow_target(following: CollisionShape2D):
	target = following
	follow_traget = true

func stop_following_target():
	
	target = null
	velocity = Vector2()
	follow_traget = false
	state = PLAYER_STATE.STATE_IDLE
