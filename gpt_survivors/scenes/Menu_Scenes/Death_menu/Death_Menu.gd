extends CanvasLayer

@export var score: int = 0
# @onready var start_level = preload("res://scenes/Test_Scenes/Brandon/ricky_test.tscn") as PackedScene

@onready var start_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Start_Button
@onready var exit_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Exit_Button


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.button_up.connect(on_start_released)
	exit_button.button_up.connect(on_exit_released)
	pass # Replace with function body.

func on_start_released() -> void:
	# send the player to the gun menu
	var scene = load("res://scenes/Menu_Scenes/Gun_Menu/Gun_Menu.tscn")
	get_tree().paused = false
	var kids = get_tree().root.get_children()
	for kid in kids:
		kid.queue_free()
	get_tree().change_scene_to_packed(load("res://scenes/Menu_Scenes/Death_menu/Death_Menu.tscn"))
	
	get_tree().change_scene_to_packed(scene)
	# queue_free()
	pass


	
func on_exit_released() -> void:
	get_tree().quit()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_score(new_score: int) -> void:
	score = new_score
	$ScoreLabel.text = "SCORE  " + str(score)
