class_name loot_grabber
extends Area2D

signal loot_grabbed(value : int)

@onready var loot_area = $CollisionShape2D
@onready var sound = $AudioStreamPlayer2D


# the radius of the loot grabber
var radius : float = 0

func _ready():
	radius = loot_area.shape.radius
	self.area_entered.connect(on_area_entered)


## change the radius of the loot grabber
func change_radius(new_radius : float):
	radius = new_radius
	loot_area.shape.radius = radius

## increase the radius of the loot grabber
func increase_radius(val :float):
	change_radius(radius + val)


func on_area_entered(loot : Area2D):
	if not loot is Dead_Bot:
		return
	loot_grabbed.emit(loot.value)
	if sound:
		sound.play()

	# remove the loot from the scene
	loot.queue_free()

	









