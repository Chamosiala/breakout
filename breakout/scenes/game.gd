extends Node2D
@onready var score_label: Label = $Score_Label
const BALL = preload("uid://c6x2ib32w3pmd")
@onready var h_box_container: HBoxContainer = $LifeCounter/HBoxContainer

# caps because you shout when you say it
var SCORE = 0
var LIVES = 3
var MAX_LIVES = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str(SCORE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Reset"):
		get_tree().reload_current_scene()


func _on_ball_brick_broken() -> void:
	SCORE += 1
	print(SCORE)
	score_label.text = str(SCORE)

func _on_floor_ball_lost() -> void:
	h_box_container.update_lives(LIVES)
	LIVES -= 1
	if LIVES > 0:
		print('INSTANTIATE')
		var ball : PhysicsBody2D = BALL.instantiate()
		add_child(ball)
		ball.brick_broken.connect(_on_ball_brick_broken) # this isn't done automatically and needs to be explicit on instantiate
		print(ball.position)
