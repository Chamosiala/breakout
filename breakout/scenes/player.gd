extends CharacterBody2D


const SPEED = 1000.0


func _physics_process(delta: float) -> void:
	position.x = get_viewport().get_mouse_position().x

	move_and_slide()
