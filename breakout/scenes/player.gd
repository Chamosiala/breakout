extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite


const SPEED = 1000.0


func _physics_process(delta: float) -> void:
	position.x = get_viewport().get_mouse_position().x - sprite.texture.get_size().x / 2

	move_and_slide()
