extends CanvasLayer

signal done

@onready var grid = $MarginContainer2/ButtonsVBoxContainer/GridContainer


@onready var main_scene = preload("res://scenes/map1.tscn")





# Called when the node enters the scene tree for the first time.
func _ready():

	var buttons = grid.get_children()
	for button in buttons:

		if button is GunButton:
			button.select_gun.connect(select_gun)




func select_gun(gun):
	print("selected gun: ", gun)
	var scene = main_scene.instantiate()
	scene.set_weapon(gun)
	get_tree().get_root().add_child(scene)
	queue_free()
	emit_signal("done")





func _process(_delta):
	pass




	



