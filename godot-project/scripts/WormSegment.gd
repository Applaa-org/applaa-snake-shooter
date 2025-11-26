extends Area2D
class_name WormSegment

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var is_head: bool = false
var segment_index: int = 0
var worm_parent: Node = null

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Bullet:
		hit_by_bullet(body)
	elif body is Player:
		body.take_damage()

func hit_by_bullet(bullet: Bullet):
	bullet.queue_free()
	
	if is_head:
		# Head destroyed - split worm
		worm_parent.split_at_segment(segment_index)
	else:
		# Body segment destroyed - remove this segment
		worm_parent.remove_segment(segment_index)
	
	Global.add_score(10)