class_name MainMenu
extends Control


# @onready var start_level = preload("res://scenes/Test_Scenes/Brandon/ricky_test.tscn") as PackedScene
@onready var start_level = preload("res://scenes/map1.tscn") as PackedScene
@onready var start_button = $MarginContainer/ButtonsHBoxContainer/ButtonsVBoxContainer/Start_Button
@onready var options_button = $MarginContainer/ButtonsHBoxContainer/ButtonsVBoxContainer/Options_Button
@onready var exit_button = $MarginContainer/ButtonsHBoxContainer/ButtonsVBoxContainer/Exit_Button


var options: PackedScene = preload("res://scenes/Menu_Scenes/Option_Menu/Option_Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.button_up.connect(on_start_released)
	options_button.button_up.connect(on_options_released)
	exit_button.button_up.connect(on_exit_released)
	
	pass # Replace with function body.

func on_start_released() -> void:
	get_tree().change_scene_to_packed(start_level)


func on_options_released() -> void:
	visible = false
	var option = options.instantiate()
	add_child(option)
	await  option.done
	option.queue_free()
	visible = true

	pass
	
func on_exit_released() -> void:
	get_tree().quit()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
