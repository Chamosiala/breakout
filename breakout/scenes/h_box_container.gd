extends HBoxContainer
@onready var game: Node2D = $"../../"
const HEART = preload("uid://dtw8qxrhusfaa")
const GAME = preload("uid://ke2hp3sfwf4")

func update_lives(lives: int) -> void:
	for i in range(get_child_count()):
		get_child(i).visible = i < lives - 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(game.MAX_LIVES):
		var heart = HEART.instantiate()
		print(heart.scale)
		add_child(heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
