extends Area2D

@export var speed := 300.0

signal have_bullet
signal no_bullet

var bullets := 1
var enemies_in_range: Array = []

func _ready() -> void:
	emit_bullet_signal()

func _process(delta: float) -> void:
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("c_left"):
		dir.x -= 1
	if Input.is_action_pressed("c_right"):
		dir.x += 1
	if Input.is_action_pressed("c_up"):
		dir.y -= 1
	if Input.is_action_pressed("c_down"):
		dir.y += 1

	if dir != Vector2.ZERO:
		global_position += dir.normalized() * speed * delta

	handle_shoot()

func handle_shoot() -> void:
	if Input.is_action_just_pressed("shoot") and bullets > 0:
		if enemies_in_range.size() > 0:
			var enemy = enemies_in_range[0]
			if enemy.has_method("take_damage"):
				enemy.take_damage()
		else:
			bullets -= 1
			emit_bullet_signal()

func emit_bullet_signal() -> void:
	if bullets > 0:
		have_bullet.emit()
	else:
		no_bullet.emit()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		print("CURSOR DETECTED:", body.name)

func _on_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)
		print("CURSOR DETECTED:", body.name)
