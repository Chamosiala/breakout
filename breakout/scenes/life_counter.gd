extends CanvasLayer
@onready var game: Node2D = $"."
const HEART = preload("uid://dtw8qxrhusfaa")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(game.MAX_LIVES):
		var heart = HEART.instantiate()
		add_child(heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
