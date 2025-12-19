extends Node2D

@onready var player = $Player
@onready var cursor = $Cursor
@onready var score_label: Label = $Player/Camera2D/ScoreLabel
@onready var bullet_label: Label = $Player/Camera2D/BulletLabel

const SPAWN_POINTS := [
	Vector2(500, 0),
	Vector2(700, 200)
]
const SPAWN_INTERVAL := 3.0
var spawn_elapsed := 0.0
var score:= 0

func _ready():
	score_label.text = "Score: 0"
	update_bullet_label()
	player.health_depleted.connect(_on_player_died)
	
	cursor.have_bullet.connect(_on_have_bullet)
	cursor.no_bullet.connect(_on_no_bullet)
	
func update_bullet_label():
	bullet_label.text = "Bullet: %d" % cursor.bullets
func _on_have_bullet():
	update_bullet_label()
	
func _on_no_bullet():
	update_bullet_label()
	
func _process(delta: float) -> void:
	spawn_elapsed += delta
	if spawn_elapsed >= SPAWN_INTERVAL:
		spawn_mob()
		spawn_elapsed = 0.0
		
func spawn_mob():
	const mobs = [
		preload("res://scenes/bat.tscn"),
		preload("res://scenes/slime.tscn"),
		preload("res://scenes/rat.tscn")
	]
	var mob = mobs[randi() % mobs.size()].instantiate()
	var spawn_point = SPAWN_POINTS[randi() % SPAWN_POINTS.size()]
	var offset = Vector2(
		randf_range(-20, 20),
		randf_range(-20, 20)
	)

	mob.global_position = spawn_point + offset
	if mob.has_signal("died"):
		mob.died.connect(_on_mob_died)
	add_child(mob)
	
func _on_mob_died():
	score += 1
	score_label.text = 'Score: %d' % score
	
func _on_player_died():
	end_game()

func end_game():
	get_tree().paused = true
	var game_over_layer = CanvasLayer.new()
	game_over_layer.layer = 30
	add_child(game_over_layer)
	
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(400,200)
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -200
	panel.offset_top = -100
	game_over_layer.add_child(panel)
	
	var label = Label.new()
	label.text = "GAME OVER\nScore: %d" % score
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 36)
	label.anchor_left = 0.5
	label.anchor_top = 0.5
	label.anchor_right = 0.5
	label.anchor_bottom = 0.5
	label.offset_left = -150
	label.offset_top = -50
	panel.add_child(label)
	
