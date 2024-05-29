extends Control


# @onready var start_level = preload("res://scenes/Test_Scenes/Brandon/ricky_test.tscn") as PackedScene
@onready var start_button = $MarginContainer2/ButtonsHBoxContainer/ButtonsVBoxContainer/Start_Button
@onready var options_button = $MarginContainer2/ButtonsHBoxContainer/ButtonsVBoxContainer/HBoxContainer/Options_Button
@onready var exit_button = $MarginContainer2/ButtonsHBoxContainer/ButtonsVBoxContainer/HBoxContainer/Exit_Button



# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.button_up.connect(on_start_released)
	options_button.button_up.connect(on_options_released)
	exit_button.button_up.connect(on_exit_released)
	
	pass # Replace with function body.

func on_start_released() -> void:
	var scene = load("res://scenes/Test_Scenes/Brandon/ricky_test.tscn")
	get_tree().paused = false
	var kids = get_tree().root.get_children()
	for kid in kids:
		kid.queue_free()
	get_tree().change_scene_to_packed(load("res://scenes/Menu_Scenes/Death_menu/Death_Menu.tscn"))
	get_tree().change_scene_to_packed(scene)
	# queue_free()


	pass


func on_options_released() -> void:
	pass
	
func on_exit_released() -> void:
	get_tree().quit()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
