extends Area2D
class_name Bullet

const SPEED: float = 500.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var direction: Vector2 = Vector2.UP
var lifetime: float = 2.0
var trail: Array[Vector2] = []

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta: float):
	position += direction * SPEED * delta
	lifetime -= delta
	
	# Add to trail
	trail.append(position)
	if trail.size() > 5:
		trail.pop_front()
	
	if lifetime <= 0:
		queue_free()
	
	# Remove if out of bounds
	if position.x < 0 or position.x > 800 or position.y < 0 or position.y > 600:
		queue_free()

func _on_body_entered(body):
	if body is SnakeSegment:
		# Let the segment handle the hit
		pass