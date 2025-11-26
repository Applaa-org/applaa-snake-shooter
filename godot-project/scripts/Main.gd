extends Node2D

@onready var player: Player = $Player
@onready var score_label: Label = $UI/ScoreLabel
@onready var high_score_label: Label = $UI/HighScoreLabel
@onready var snakes_label: Label = $UI/SnakesLabel

var snake_scene = preload("res://scenes/Snake.tscn")
var snakes: Array[Snake] = []
var snake_spawn_timer: float = 0.0
var snake_spawn_interval: float = 2.0
var snake_id_counter: int = 0

func _ready():
	Global.start_game()
	update_ui()

func _process(delta: float):
	if Global.game_active:
		update_ui()
		spawn_snakes(delta)
		check_victory()

func spawn_snakes(delta: float):
	snake_spawn_timer += delta
	
	if snake_spawn_timer >= snake_spawn_interval:
		snake_spawn_timer = 0.0
		
		# Spawn new snake
		var snake = snake_scene.instantiate()
		add_child(snake)
		
		var start_x = randf_range(100, 700)
		var snake_length = randi_range(4, 8)
		
		snake.create_snake(snake_length, start_x, -50, snake_id_counter)
		snakes.append(snake)
		Global.total_snakes += 1
		snake_id_counter += 1
		
		# Randomize next spawn time
		snake_spawn_interval = randf_range(1.5, 3.0)

func check_victory():
	# Victory after destroying 10 snakes
	if Global.snakes_destroyed >= 10:
		Global.end_game()
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func update_ui():
	score_label.text = "SCORE: %04d" % Global.score
	high_score_label.text = "HIGH: %04d" % Global.high_score
	snakes_label.text = "SNAKES: %d/10" % Global.snakes_destroyed