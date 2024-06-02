extends Node


var score = 0
var selected_weapon : PackedScene = null


func _ready():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.close()
	set_high_score(0)



func get_high_score():
	if not FileAccess.file_exists("user://savegame.save"):
		return 0

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if save_file == null:
		return 0
	var data = save_file.get_as_text()
	var json = JSON.new()


	var save_dict = json.parse(data)
	score = save_dict["high_score"]
	return save_dict["high_score"]


func set_high_score(new_score):
	if new_score < score:
		return


	var save_dict = {
		"high_score": new_score
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	var data = JSON.stringify(save_dict)
	save_file.store_line(data)
	score = new_score




