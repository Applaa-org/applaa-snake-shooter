extends Node

var score: int = 0
var high_score: int = 0
var game_active: bool = false

func add_score(points: int):
	score += points
	if score > high_score:
		high_score = score

func reset_score():
	score = 0

func start_game():
	game_active = true
	reset_score()

func end_game():
	game_active = false