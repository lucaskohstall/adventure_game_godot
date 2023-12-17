extends StaticBody2D

class_name Obstacle

func hide_obstacle():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	
func show_obstacle():
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = false
