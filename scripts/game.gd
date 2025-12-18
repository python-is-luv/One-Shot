extends Node2D
@onready var player = $Player
@onready var score_label: Label = $Player/Camera2D/ScoreLabel
const SPAWN_CENTER := Vector2(500, 400)
const SPAWN_RADIUS := 80.0  # adjust for spread


const SPAWN_INTERVAL = 1.5
const MIN_SPAWN_DISTANCE = 300.0  # Minimum distance from player to spawn

var spawn_elapsed := 0.0
var score := 0

func _ready():
	score_label.text = "Score: 0"
	player.health_depleted.connect(_on_player_died)

func spawn_mob():
	const slime = preload("res://scenes/slime.tscn")
	const bat = preload("res://scenes/bat.tscn")
	const rat = preload("res://scenes/rat.tscn")
	var mobs = [slime, bat, rat]
	
	var mob_scene = mobs[randi() % mobs.size()]
	var mob = mob_scene.instantiate()

	# Random position around (500, 400)
	var angle = randf() * TAU
	var radius = randf() * SPAWN_RADIUS
	var offset = Vector2(cos(angle), sin(angle)) * radius
	mob.global_position = SPAWN_CENTER + offset

	# Listen for mob death
	if mob.has_signal("died"):
		mob.died.connect(_on_mob_died)

	add_child(mob)

func _process(delta: float) -> void:
	spawn_elapsed += delta
	if spawn_elapsed >= SPAWN_INTERVAL:
		spawn_mob()
		spawn_elapsed = 0.0

func _on_mob_died():
	score += 1
	score_label.text = "Score: %d" % score

func _on_player_died():
	end_game()

func end_game():
	get_tree().paused = true
	var game_over_layer = CanvasLayer.new()
	game_over_layer.layer = 30
	add_child(game_over_layer)
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(400, 200)
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
