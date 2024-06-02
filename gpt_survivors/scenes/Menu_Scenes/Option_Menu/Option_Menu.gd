extends CanvasLayer

signal done

@onready var exit_button = $MarginContainer2/ButtonsVBoxContainer/HBoxContainer/Exit_Button
@onready var sfx_volume :Slider = $MarginContainer2/ButtonsVBoxContainer/GridContainer/SFX_Slider
@onready var music_volume :Slider = $MarginContainer2/ButtonsVBoxContainer/GridContainer/Music_Slider
@onready var reset_button :Button = $MarginContainer2/ButtonsVBoxContainer/score_grid/reset
@onready var unlock_button :Button = $MarginContainer2/ButtonsVBoxContainer/score_grid/max
@onready var full_screen_button :Button = $MarginContainer2/ButtonsVBoxContainer/full_screen


@onready var Music_Bus_ID= AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID= AudioServer.get_bus_index("SFX")

@onready var score_saver : SaveGame = SaveGame.new()



# Called when the node enters the scene tree for the first time.
func _ready():

	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_Bus_ID))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(Music_Bus_ID))
	reset_button.button_up.connect(reset_scores)
	unlock_button.button_up.connect(unlock_all)
	full_screen_button.button_up.connect(toggle_full_screen)

	exit_button.button_up.connect(on_exit_released)
	sfx_volume.value_changed.connect(set_sfx_volume)
	music_volume.value_changed.connect(set_music_volume)




func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		on_exit_released()




	
func on_exit_released() -> void:
	emit_signal("done")
	# queue_free()
	pass

## function to set the volume of a bus
func set_volume(id, volume):
	print("Setting volume of bus ", id, " to ", volume)
	AudioServer.set_bus_volume_db(id, linear_to_db(volume))
	if volume < 0.05:
		AudioServer.set_bus_mute(id, true)
	else:
		AudioServer.set_bus_mute(id, false)


## functions to set the volume of the different buses

func set_music_volume(value):
	set_volume(Music_Bus_ID, value)

func set_sfx_volume(value):
	set_volume(SFX_Bus_ID, value)


func reset_scores():
	score_saver.reset_high_score()
	pass
func unlock_all():
	score_saver.set_high_score(9999)
	pass

func toggle_full_screen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)



