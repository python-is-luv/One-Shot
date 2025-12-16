extends Area2D

@export var speed := 350
@export var max_distance := 300

var current_enemy: Node = null
@onready var player := get_parent()

func _physics_process(delta):
	var dir := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1

	position += dir.normalized() * speed * delta

	# keep cursor near player (VERY IMPORTANT)
	position = position.clamp(
		Vector2(-max_distance, -max_distance),
		Vector2(max_distance, max_distance)
	)
