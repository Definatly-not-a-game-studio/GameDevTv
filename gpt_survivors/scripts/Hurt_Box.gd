class_name Hurt_Box
extends Area2D


func _init():
	collision_layer = 1
	collision_mask = 2

func _ready():
	# Connect to the area_entered signal
	self.area_entered.connect(_on_Hurt_Box_area_entered)



func _on_Hurt_Box_area_entered(hurt_area:Hit_Box) -> void:
	if hurt_area == null:
		return
	var dmg = hurt_area.damage

	if owner.has_method("take_damage"):
		owner.take_damage(dmg)

	

