extends Area2D
class_name SnakeSegment

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var is_head: bool = false
var segment_index: int = 0
var snake_parent: Snake = null

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Bullet:
		hit_by_bullet(body)

func hit_by_bullet(bullet: Bullet):
	bullet.queue_free()
	snake_parent.hit_by_bullet()