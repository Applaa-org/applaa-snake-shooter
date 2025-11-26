extends Node2D
class_name Snake

const SEGMENT_SIZE: float = 15.0
const SEGMENT_SPACING: float = 18.0
const FALL_SPEED: float = 80.0
const HORIZONTAL_SPEED: float = 60.0

@onready var segment_scene = preload("res://scenes/SnakeSegment.tscn")

var segments: Array[SnakeSegment] = []
var velocity: Vector2 = Vector2.DOWN * FALL_SPEED
var snake_color: Color
var snake_id: int
var is_destroyed: bool = false

func _ready():
	# Random snake color
	snake_color = [
		Color.LIME_GREEN,
		Color.CYAN,
		Color.MAGENTA,
		Color.YELLOW,
		Color.ORANGE
	].pick_random()

func create_snake(length: int, start_x: float, start_y: float, id: int):
	snake_id = id
	
	# Clear existing segments
	for segment in segments:
		segment.queue_free()
	segments.clear()
	
	# Create new segments
	for i in range(length):
		var segment = segment_scene.instantiate()
		add_child(segment)
		segment.segment_index = i
		segment.snake_parent = self
		
		if i == 0:
			segment.is_head = true
			segment.sprite.modulate = snake_color.lightened(0.3)
		else:
			segment.sprite.modulate = snake_color
		
		segment.position = Vector2(start_x, start_y + i * SEGMENT_SPACING)
		segments.append(segment)
	
	# Random horizontal movement
	if randf() < 0.5:
		velocity.x = (randf() < 0.5 ? -1 : 1) * HORIZONTAL_SPEED

func _process(delta: float):
	if not Global.game_active or is_destroyed or segments.is_empty():
		return
	
	# Update position
	position += velocity * delta
	
	# Bounce off walls
	if position.x < 50 or position.x > 750:
		velocity.x *= -1
		position.x = clamp(position.x, 50, 750)
	
	# Check if snake fell off screen
	if position.y > 650:
		destroy_snake()

func hit_by_bullet():
	if is_destroyed:
		return
	
	Global.snake_destroyed()
	destroy_snake()

func destroy_snake():
	if is_destroyed:
		return
	
	is_destroyed = true
	
	# Create explosion effect
	for segment in segments:
		var explosion = preload("res://scenes/Explosion.tscn").instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = segment.global_position
		explosion.color = snake_color
	
	# Remove snake
	queue_free()

func check_player_collision(player_pos: Vector2) -> bool:
	if is_destroyed or segments.is_empty():
		return false
	
	for segment in segments:
		var dist = segment.global_position.distance_to(player_pos)
		if dist < 25:
			return false # Player hit snake, but don't end game - just destroy snake
	
	return false