extends Node2D

@onready var player: Player = $Player
@onready var worm: Worm = $Worm
@onready var score_label: Label = $UI/ScoreLabel
@onready var high_score_label: Label = $UI/HighScoreLabel

func _ready():
	Global.start_game()
	update_ui()

func _process(delta: float):
	if Global.game_active:
		update_ui()

func update_ui():
	score_label.text = "SCORE: %04d" % Global.score
	high_score_label.text = "HIGH: %04d" % Global.high_score