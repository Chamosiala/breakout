extends RigidBody2D
@onready var player: CharacterBody2D = $"../Player"
@onready var bricks: Node = $"../Bricks"
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var brick_break: AudioStreamPlayer2D = $BrickBreak

const initial_speed = 500

var max_x_speed = initial_speed 
var max_y_speed = initial_speed 

var has_hit_ceiling_after_paddle_hit = false
signal brick_broken
signal paddle_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # to change this to stick to paddle
	has_hit_ceiling_after_paddle_hit = false
	position = Vector2(324, 576)
	linear_velocity = Vector2(initial_speed, initial_speed)
	
func speed_change() -> void:
	if (Vector2(max_x_speed, max_y_speed).length() <= 2000):
		max_x_speed *= 1.05
		max_y_speed *= 1.05
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var pos = state.get_contact_collider_position(0) # ball
	var obj = state.get_contact_collider_object(0)
	if obj != null:
		if obj.name == "Player":
			paddle_hit.emit()
			has_hit_ceiling_after_paddle_hit = false
			var relative : float = pos.x - player.position.x
			var speed := state.linear_velocity.length()
			state.linear_velocity = Vector2.RIGHT.rotated(-funky_trans_moment(relative)) * speed
			
			
func funky_trans_moment(x):
	return PI/2 - x * PI/240
func _on_body_entered(body: Node) -> void:
	print(linear_velocity.length())
	hit_sound.pitch_scale = max_y_speed / 500
	print(hit_sound.pitch_scale)
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
	brick_break.play()
	speed_change()
	body.get_node("CollisionShape2D").queue_free()
	var breakAnimation = body.get_node("AnimationPlayer")
	breakAnimation.play("break")
	await breakAnimation.animation_finished
	body.queue_free()
	
