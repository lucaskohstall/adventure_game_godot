extends CharacterBody2D

class_name Enemy

const SPEED = 200.0

var health = 100
var damage = 5
var dead = false

var damage_timeout = false
var player_in_area = false
var player_in_hitbox = false

var player
var knock_back_force = 10

signal enemy_death

@onready var hitbox: Area2D = $"Area2D-Hitbox"

func _ready():
	pass
	
func _physics_process(_delta):

	if dead:
		$AnimatedSprite2D.play("death")
		$"Area2D-Hitbox/CollisionShape2D".disabled = true
		$"Area2D-SeekArea/CollisionShape2D2".disabled = true

		# TODO: React on finished animation instead
		await get_tree().create_timer(1.0).timeout
		enemy_death.emit()
		queue_free()
		return

	process_damage()
	
	if !dead:
	
		$"Area2D-SeekArea/CollisionShape2D2".disabled = false
		if player_in_area && !damage_timeout:
			position += (player.global_position - global_position) / SPEED
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
		
	move_and_slide()

func process_damage():
	
	if damage_timeout:
		return
	
	if player_in_hitbox && player.state == PLAYER_STATE.STATE_ATTACK:
		$"Timer-Damage".start()
		$DamageBlink.play("hit_flash")
		
		damage_timeout = true
		health = health - 40
		
		if health < 1:
			dead = true
		
		knockback()

func _on_area_2d_seek_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_area_2d_seek_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	
	await get_tree().create_timer(1).timeout
	queue_free()

func knockback():
	# Calc player direction
	# Physics code
	# Stop movement for 1 sec of.
	if player == null:
		return
		
	var direction = (player.global_position - global_position).normalized()
	position += -direction * knock_back_force

func enemy():
	pass

func _on_timer_timeout():
	damage_timeout = false

func _on_timer_damage_timeout():
	damage_timeout = false

func _hitbox_area_entered(area: Area2D):
	if area.get_parent().get_name() == "Player":
		player = area.get_parent()
		player_in_hitbox = true

func _hitbox_area_exited(area):
	if area.get_parent().get_name() == "Player":
		player_in_hitbox = false
