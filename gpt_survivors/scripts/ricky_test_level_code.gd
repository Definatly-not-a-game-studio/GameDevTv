extends Node2D

@onready var hero = $Hero

# Called when the node enters the scene tree for the first time.
func _ready():
	hero.died.connect(reboot)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reboot():
	pass
	



