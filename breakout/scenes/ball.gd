extends RigidBody2D

var average_speed = Vector2(300,300)
var max_x_speed = 300
var max_y_speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2(300, 300)
	
func _on_body_entered(body: Node) -> void:
	linear_velocity *= 1.05
	if abs(linear_velocity.x) > max_x_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_x_speed
	if abs(linear_velocity.y) > max_y_speed:
		linear_velocity.y = sign(linear_velocity.y) * max_y_speed
	max_x_speed *= 1.05
	max_y_speed *= 1.05
	print("collided")
	print(linear_velocity)
