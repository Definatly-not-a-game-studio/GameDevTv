class_name loot_grabber
extends Area2D

signal loot_grabbed(value : int)

@onready var loot_area = $CollisionShape2D

# the radius of the loot grabber
var radius = 0

func _ready():
	radius = loot_area.shape.radius
	self.area_entered.connect(on_area_entered)


func change_radius(new_radius : int):
	radius = new_radius
	loot_area.shape.radius = radius

func on_area_entered(loot : Dead_Bot):
	if loot == null:
		return
	print("Loot grabbed")
	loot_grabbed.emit(loot.value)

	# remove the loot from the scene
	loot.queue_free()

	









