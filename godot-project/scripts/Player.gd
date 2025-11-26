extends CharacterBody2D
class_name Player

const SPEED: float = 300.0
const BULLET_SPEED: float = 500.0
const SHOOT_COOLDOWN: float = 0.2

@onready var sprite: Sprite2D = $Sprite2D
@onready var shoot_timer: Timer = $ShootTimer

var bullet_scene = preload("res://scenes/Bullet.tscn")
var can_shoot: bool = true

func _ready():
	shoot_timer.wait_time = SHOOT_COOLDOWN
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta: float):
	# Handle movement
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		# Rotate sprite to face movement direction
		sprite.rotation = direction.angle()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta)
	
	move_and_slide()
	
	# Handle shooting
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and can_shoot:
		shoot()

func shoot():
	if not can_shoot or not Global.game_active:
		return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = Vector2.UP.rotated(sprite.rotation)
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage():
	Global.end_game()
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")