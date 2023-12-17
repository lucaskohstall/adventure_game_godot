extends Area2D

@export var obstacles: Array[Obstacle]
@export var enemy_spawner: EnemySpawner

func _ready():
	enemy_spawner.connect("wave_cleared", disable_obstacles)

func disable_obstacles():
	for obstacle in obstacles:
		obstacle.hide_obstacle()

func _on_body_entered(body):
	if !body.has_method("player"):
		return

	for obstacle in obstacles:
		obstacle.show_obstacle()

	enemy_spawner.start()
	
func _on_body_exited(_body):
	pass # Replace with function body.
