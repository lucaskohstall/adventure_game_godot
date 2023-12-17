extends CharacterBody2D

@export var player: Player
@export var obstacle: Obstacle
@export var actionable: Actionable

@onready var path: PathFollow2D = get_parent()
@onready var collisio_2d: CollisionShape2D = $Actionable/CollisionShape2D

var should_follow_path: bool = false

func _ready():

	$AnimatedSprite2D.play("idle")
	DialogueManager.dialogue_ended.connect(dialogue_ended)
	
func dialogue_ended(resource: DialogueResource):

	if resource != actionable.dialogue_resource:
		return

	should_follow_path = true
	player.follow_target(collisio_2d)
	
	if obstacle != null:
		obstacle.hide_obstacle()
	
func _physics_process(delta):
	handle_path(delta)

func handle_path(delta):
	
	if !should_follow_path || path == null:
		return

	path.set_progress(path.get_progress() + 50 * delta)
	
	if path.progress_ratio == 1:
		should_follow_path = false
		player.stop_following_target()
