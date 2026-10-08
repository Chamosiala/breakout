extends RigidBody2D
@onready var brick_group: Node = $"../BrickGroup"
@onready var player: CharacterBody2D = $"../Player"

const initial_speed = 500

var max_x_speed = initial_speed 
var max_y_speed = initial_speed 
signal brick_broken

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(324, 576)
	linear_velocity = Vector2(initial_speed, initial_speed)
	
func speed_change() -> void:
	max_x_speed *= 1.05
	max_y_speed *= 1.05
	
func _on_body_entered(body: Node) -> void:
	if body in brick_group.get_children():
		body.queue_free()
		speed_change()
		brick_broken.emit()
	if body.name == "Player":
		#TODO: do better next time
		print(linear_velocity.y)
		linear_velocity.y = - abs(linear_velocity.y)
		print(linear_velocity.y)
	linear_velocity *= 1.05
	if abs(linear_velocity.x) > max_x_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_x_speed
	if abs(linear_velocity.y) > max_y_speed:
		linear_velocity.y = sign(linear_velocity.y) * max_y_speed
