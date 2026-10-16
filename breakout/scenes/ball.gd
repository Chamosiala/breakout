extends RigidBody2D
@onready var player: CharacterBody2D = $"../Player"
@onready var bricks: Node = $"../Bricks"

const initial_speed = 500

var max_x_speed = initial_speed 
var max_y_speed = initial_speed 

var has_hit_ceiling_after_paddle_hit = false
signal brick_broken

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # to change this to stick to paddle
	position = Vector2(324, 576)
	linear_velocity = Vector2(initial_speed, initial_speed)
	
func speed_change() -> void:
	max_x_speed *= 1.05
	max_y_speed *= 1.05
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var pos = state.get_contact_collider_position(0) # ball
	var obj = state.get_contact_collider_object(0)
	if obj != null:
		if obj.name == "Player":
			has_hit_ceiling_after_paddle_hit = false
			var shape :RectangleShape2D = obj.get_node("CollisionShape2D").shape
			print(shape.size.y)
			
			var relative : float = pos.x - player.position.x
			print(relative)
			var speed := state.linear_velocity.length()
			state.linear_velocity = Vector2.RIGHT.rotated(-funky_trans_moment(relative)) * speed
			
			
func funky_trans_moment(x):
	return PI/2 - x * PI/240
func _on_body_entered(body: Node) -> void:
	for brickGroup in bricks.get_children():
		if body in brickGroup.get_children():
			body.queue_free()
			speed_change()
			brick_broken.emit()
	if body.name == "Ceiling":
		if player.scale.y && !has_hit_ceiling_after_paddle_hit > 0.30:
			player.scale.y -= 0.10
		has_hit_ceiling_after_paddle_hit = true
	linear_velocity *= 1.05
	if abs(linear_velocity.x) > max_x_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_x_speed
	if abs(linear_velocity.y) > max_y_speed:
		linear_velocity.y = sign(linear_velocity.y) * max_y_speed
