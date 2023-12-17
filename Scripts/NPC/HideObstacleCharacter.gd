extends CharacterBody2D

@onready var actionable: Area2D = $Actionable1

@export var obstacle: Obstacle
#TODO: Obstacle script maybe

func _ready():
	$AnimatedSprite2D.play("idle")
	DialogueManager.dialogue_ended.connect(dialogue_ended)

func dialogue_ended(resource: DialogueResource):

	print("Dialogue endet")
	print(resource)
	print(actionable.dialogue_resource)
	if resource != actionable.dialogue_resource:
		return
	
	print("Test")
	print(obstacle)
	obstacle.hide_obstacle()
