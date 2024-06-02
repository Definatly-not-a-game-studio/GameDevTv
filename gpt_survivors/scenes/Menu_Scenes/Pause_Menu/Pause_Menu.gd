extends CanvasLayer

@export var score: int = 0
# @onready var start_level = preload("res://scenes/Test_Scenes/Brandon/ricky_test.tscn") as PackedScene

@onready var start_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Start_Button
@onready var exit_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Exit_Button
@onready var option_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Option_Button

var options: PackedScene = preload("res://scenes/Menu_Scenes/Option_Menu/Option_Menu.tscn")

# determine if the menu is fresh opened
var fresh_opened = true

# Called when the node enters the scene tree for the first time.
func _ready():
	fresh_timer()
	start_button.button_up.connect(on_start_released)
	exit_button.button_up.connect(on_exit_released)
	option_button.button_up.connect(option_released)
	pass # Replace with function body.

func on_start_released() -> void:
	# @onready var start_level = preload("res://scenes/map1.tscn") as PackedScene
	var scene = load("res://scenes/map1.tscn")
	get_tree().paused = false
	var kids = get_tree().root.get_children()
	for kid in kids:
		kid.queue_free()
	get_tree().change_scene_to_packed(load("res://scenes/Menu_Scenes/Death_menu/Death_Menu.tscn"))
	get_tree().change_scene_to_packed(scene)
	# queue_free()
	pass


func option_released() -> void:
	visible = false
	var option = options.instantiate()
	add_child(option)
	await  option.done
	fresh_opened = true
	fresh_timer()
	option.queue_free()
	visible = true

	pass


	
func on_exit_released() -> void:
	get_tree().paused = false
	queue_free()


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause") and not fresh_opened:
		on_exit_released()

func fresh_timer() -> void:
	await get_tree().create_timer(0.5).timeout
	fresh_opened = false

func set_score(new_score: int) -> void:
	score = new_score
	$ScoreLabel.text = "SCORE  " + str(score)
