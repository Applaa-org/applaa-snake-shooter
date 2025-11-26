extends Node2D
class_name Explosion

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var color: Color = Color.WHITE
var scale_amount: float = 1.0

func _ready():
	sprite.modulate = color
	timer.wait_time = 0.5
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _process(delta: float):
	scale_amount += delta * 3
	sprite.scale = Vector2(scale_amount, scale_amount)
	sprite.modulate.a = max(0, 1.0 - scale_amount / 3.0)

func _on_timer_timeout():
	queue_free()