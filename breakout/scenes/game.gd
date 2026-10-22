extends Node2D
@onready var score_label: Label = $Score_Label
const BALL = preload("uid://c6x2ib32w3pmd")
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var player: CharacterBody2D = $Player
@onready var combo_label: Label = $Combo

@onready var a_5: AudioStreamPlayer2D = $A5
@onready var c_5: AudioStreamPlayer2D = $C5
@onready var e_5: AudioStreamPlayer2D = $E5
@onready var g_5: AudioStreamPlayer2D = $G5
@onready var d_5: AudioStreamPlayer2D = $D5

# caps because you shout when you say it
var SCORE = 0
var HIGH_SCORE = 0
var LIVES = 3
var MAX_LIVES = 3
var GAME_STATE = "begin" # "begin" || "playing" || "game_over"
var BEAT_HIGH_SCORE = false
var COMBO = 0
var noteArray : Array[AudioStreamPlayer2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	score_label.text = str(SCORE)
	noteArray = [a_5, c_5, d_5, e_5, g_5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("play") && GAME_STATE != "game_over":
		GAME_STATE = "playing"
		player.scale.y = 1
		if !get_tree().root.get_child(0).has_node('Ball'):
			instantiate_ball()
	
		
func end_game():
	if SCORE > HIGH_SCORE:
		HIGH_SCORE = SCORE
		BEAT_HIGH_SCORE = true
		save_game()
	GAME_STATE = "game_over"

func _on_ball_brick_broken() -> void:
	SCORE += 1
	score_label.text = str(SCORE)
	noteArray[COMBO%5].play()
	update_combo(COMBO + 1)
	
func _on_paddle_hit() -> void:
	update_combo(0)

func _on_floor_ball_lost() -> void:
	LIVES -= 1
	h_box_container.update_lives(LIVES)
	if LIVES > 0:
		GAME_STATE = "begin"
		
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#for i in save_nodes:
		#i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		
		var high_score = node_data.high_score
		HIGH_SCORE = high_score
		
		#print(high_score)
		# Firstly, we need to create the object and add it to the tree and set its position.
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		#for i in node_data.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#new_object.set(i, node_data[i])

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var node_data = {
		"high_score": HIGH_SCORE
	}
	var json_string = JSON.stringify(node_data)
	print(save_file)
	save_file.store_line(json_string)


func _on_h_box_container_died() -> void:
	end_game()
	
func instantiate_ball():
	var ball : PhysicsBody2D = BALL.instantiate()
	add_child(ball)
	ball.brick_broken.connect(_on_ball_brick_broken)
	ball.paddle_hit.connect(_on_paddle_hit)

func update_combo(combo):
	COMBO = combo
	combo_label.visible = true if COMBO >= 2 else false
	combo_label.text = "COMBO" + " " + str(COMBO)
