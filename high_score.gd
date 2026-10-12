extends Node2D
@onready var game: Node2D = $".."

var HIGH_SCORES

func update_high_score(highScore: int):
	HIGH_SCORES = highScore

func save():
	var save_dict = {
		"high_score": HIGH_SCORES
	}
	
	return save_dict
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
