extends Node2D
@onready var score_label: Label = $Score_Label
@onready var life_label: Label = $Life_Label
const BALL = preload("uid://c6x2ib32w3pmd")

# caps because you shout when you say it
var SCORE = 0
var LIVES = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str(SCORE)
	life_label.text = str(LIVES)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Reset"):
		get_tree().reload_current_scene()


func _on_ball_brick_broken() -> void:
	SCORE += 1
	print(SCORE)
	score_label.text = str(SCORE)

func _on_floor_ball_lost() -> void:
	LIVES -= 1
	if LIVES > 0:
		print('INSTANTIATE')
		var ball : PhysicsBody2D = BALL.instantiate()
		add_child(ball)
		print(ball.position)
	life_label.text = str(LIVES)
