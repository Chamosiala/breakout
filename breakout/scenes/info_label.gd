extends Label
@onready var game: Node2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match(game.GAME_STATE):
		'begin':
			text = "PRESS SPACE TO LAUNCH BALL"
		'playing':
			text = ''
		'game_over':
			if game.BEAT_HIGH_SCORE:
				text = "NEW HIGH SCORE: " + str(game.HIGH_SCORE) + '\n' + "PRESS ENTER TO PLAY AGAIN :D"
			else:
				text = "HIGH SCORE: " + str(game.HIGH_SCORE) + '\n' + "PRESS ENTER TO PLAY AGAIN"
		'game_won':
			text = "YOU WON, CONGRATS!! "
			if game.BEAT_HIGH_SCORE:
				text += '\n' + "NEW HIGH SCORE: " + str(game.HIGH_SCORE) + '\n' + "PRESS ENTER TO PLAY AGAIN :D"
			else:
				text += "HIGH SCORE: " + str(game.HIGH_SCORE) + '\n' + "PRESS ENTER TO PLAY AGAIN :D"
