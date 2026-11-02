extends RigidBody2D
@onready var player: CharacterBody2D = $"../Player"
@onready var bricks: Node = $"../Bricks"
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var brick_break: AudioStreamPlayer2D = $BrickBreak
@onready var disable_collision_timer: Timer = $DisableCollision
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const initial_speed = 500

var max_x_speed = initial_speed 
var max_y_speed = initial_speed 

const states = ["sticky", "bounce"]

var currentState = "sticky"

var has_hit_ceiling_after_paddle_hit = false
signal brick_broken
signal paddle_hit

var randomPos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # to change this to stick to paddle
	freeze = true
	disable_collision_timer.stop()
	has_hit_ceiling_after_paddle_hit = false
	linear_velocity = Vector2()
	randomPos = randi_range(-10, 10)
	position = Vector2(player.position.x + randomPos, player.position.y - 16)

func speed_change() -> void:
	if (Vector2(max_x_speed, max_y_speed).length() <= 2000):
		max_x_speed *= 1.05
		max_y_speed *= 1.05
		
func _physics_process(_delta: float):
	if freeze:
		global_position = Vector2(player.global_position.x + randomPos, player.global_position.y - 15)
		if Input.is_action_just_pressed("play"):
			freeze = false
			apply_central_impulse(Vector2(initial_speed, initial_speed))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if freeze: return
	var pos = state.get_contact_collider_position(0) # ball
	var obj = state.get_contact_collider_object(0)
	if obj != null:
		if obj.name == "Player":
			disable_collision_timer.start()
			collision_mask = 2
			paddle_hit.emit()
			has_hit_ceiling_after_paddle_hit = false
			var relative_x: float = pos.x - player.position.x
			var relative_y: float = pos.y - player.position.y
		
			var speed := state.linear_velocity.length()
			if relative_y == -9.0:
				state.linear_velocity = Vector2.RIGHT.rotated(-funky_trans_moment(relative_x)) * speed

func hit_stop(duration: float = 0.03, time_scale_value: float = 0.03) -> void:
	Engine.time_scale = time_scale_value
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

			
func funky_trans_moment(x):
	return PI/2 - x * PI/240

func _on_body_entered(body: Node) -> void:
	hit_stop()
	hit_sound.pitch_scale = max_y_speed / 500
	if !freeze:
		hit_sound.play()
	for brickGroup in bricks.get_children():
		if body in brickGroup.get_children():
			break_brick(body)
	if body.name == "Ceiling":
		if !has_hit_ceiling_after_paddle_hit:
			player.shrink_player()
		has_hit_ceiling_after_paddle_hit = true
	linear_velocity *= 1.05
	if abs(linear_velocity.x) > max_x_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_x_speed
	if abs(linear_velocity.y) > max_y_speed:
		linear_velocity.y = sign(linear_velocity.y) * max_y_speed
		
func break_brick(body: Node2D):
	brick_broken.emit()
	speed_change()
	body.get_node("CollisionShape2D").queue_free()
	var breakAnimation = body.get_node("AnimationPlayer")
	breakAnimation.play("break")
	await breakAnimation.animation_finished
	body.queue_free()
	


func _on_disable_collision_timeout() -> void:
	collision_mask = 1
	disable_collision_timer.stop()
