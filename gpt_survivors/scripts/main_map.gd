extends Node2D

@onready var Hero = $Hero


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_weapon(weapon):
	$Hero.loaded_weapon = weapon
