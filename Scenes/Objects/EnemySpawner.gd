extends Node2D

class_name EnemySpawner

var started = false
var max_waves = 3
var current_wave = 0
var dead_enemy_counter = 0
var enemy = preload("res://Scenes/Slime.tscn")

signal wave_cleared

func enemy_died():
	dead_enemy_counter += 1
	print("Death: ", dead_enemy_counter)
	if dead_enemy_counter == 3:
		start_wave()

func start():
	if started:
		return
		
	started = true
	start_wave()

func start_wave():
	
	current_wave += 1
	dead_enemy_counter = 0
	
	print("Wave: ", current_wave)	
	if current_wave == max_waves:
		wave_cleared.emit()
		return
	
	add_enemy($Marker2D)
	add_enemy($Marker2D2)
	add_enemy($Marker2D3)

func add_enemy(marker: Marker2D):
	var enemy_instance: Enemy = enemy.instantiate()
	enemy_instance.connect("enemy_death", enemy_died)
	add_child(enemy_instance)
	enemy_instance.position = marker.position
