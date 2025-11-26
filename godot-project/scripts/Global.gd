extends Node

var score: int = 0
var high_score: int = 0
var game_active: bool = false
var snakes_destroyed: int = 0
var total_snakes: int = 0

func add_score(points: int):
	score += points
	if score > high_score:
		high_score = score

func snake_destroyed():
	snakes_destroyed += 1
	add_score(50) # 50 points per snake destroyed

func reset_game():
	score = 0
	snakes_destroyed = 0
	total_snakes = 0

func start_game():
	game_active = true
	reset_game()

func end_game():
	game_active = false