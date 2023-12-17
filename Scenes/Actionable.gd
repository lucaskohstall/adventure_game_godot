extends Area2D

class_name Actionable

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@export var question_mark_sprite: Sprite2D

func action() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_body_entered(body):
	# TODO: Only show if dialogue is available
	print(body)
	print(body.has_method("player"))
	if body.has_method("player"):
		question_mark_sprite.visible = true

func _on_body_exited(body):
	if body.has_method("player"):
		question_mark_sprite.visible = false
