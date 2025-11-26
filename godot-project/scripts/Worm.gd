extends Node2D
class_name Worm

const SEGMENT_SIZE: float = 20.0
const SEGMENT_SPACING: float = 25.0
const MOVE_SPEED: float = 100.0
const TURN_CHANCE: float = 0.02

@onready var segment_scene = preload("res://scenes/WormSegment.tscn")

var segments: Array[WormSegment] = []
var direction: Vector2 = Vector2.DOWN
var target_direction: Vector2 = Vector2.DOWN
var move_timer: float = 0.0
var move_interval: float = 0.5

func _ready():
	create_worm(8) # Start with 8 segments

func _process(delta: float):
	if not Global.game_active:
		return
	
	move_timer += delta
	if move_timer >= move_interval:
		move_timer = 0.0
		move_worm()
		decide_direction()

func create_worm(length: int):
	# Clear existing segments
	for segment in segments:
		segment.queue_free()
	segments.clear()
	
	# Create new segments
	for i in range(length):
		var segment = segment_scene.instantiate()
		add_child(segment)
		segment.segment_index = i
		segment.worm_parent = self
		
		if i == 0:
			segment.is_head = true
			segment.sprite.modulate = Color.LIME_GREEN
		else:
			segment.sprite.modulate = Color.GREEN
		
		segment.position = Vector2(400, 100 + i * SEGMENT_SPACING)
		segments.append(segment)

func move_worm():
	if segments.is_empty():
		return
	
	# Move head first
	var head = segments[0]
	var old_head_pos = head.position
	head.position += direction * SEGMENT_SPACING
	
	# Move body segments to follow
	for i in range(1, segments.size()):
		var segment = segments[i]
		var prev_segment = segments[i - 1]
		var old_pos = segment.position
		segment.position = old_head_pos
		old_head_pos = old_pos
	
	# Check boundaries and reverse if needed
	if head.position.x < 50 or head.position.x > 750:
		direction.x *= -1
		head.position.x = clamp(head.position.x, 50, 750)
	
	if head.position.y > 550:
		# Worm reached bottom - player loses
		Global.end_game()
		get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func decide_direction():
	if randf() < TURN_CHANCE:
		# Randomly change horizontal direction
		if direction == Vector2.DOWN:
			target_direction = [Vector2.LEFT, Vector2.RIGHT].pick_random()
		elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
			target_direction = Vector2.DOWN
		
		direction = target_direction

func split_at_segment(index: int):
	if index >= segments.size():
		return
	
	# Remove segment and all after it
	var segments_to_remove = segments.size() - index
	for i in range(segments_to_remove):
		var segment = segments.pop_back()
		segment.queue_free()
	
	# Create new smaller worm from removed segments if more than 1 was removed
	if segments_to_remove > 1:
		var new_worm = preload("res://scenes/Worm.tscn").instantiate()
		get_parent().add_child(new_worm)
		new_worm.create_worm(segments_to_remove - 1)
		new_worm.position = segments[index].position

func remove_segment(index: int):
	if index >= segments.size():
		return
	
	var segment = segments[index]
	segments.erase(segment)
	segment.queue_free()
	
	# Update indices
	for i in range(segments.size()):
		segments[i].segment_index = i
	
	# Check victory condition
	if segments.size() <= 1:
		Global.add_score(100) # Bonus for destroying worm
		Global.end_game()
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")