class_name Hurt_Box
extends Area2D


@export var damage_taker : LifeState = null


func _init():
	collision_layer = 1
	collision_mask = 2

func _ready():
	# Connect to the area_entered signal
	self.area_entered.connect(_on_Hurt_Box_area_entered)

	var timer :Timer = Timer.new()
	timer.set_wait_time(0.5)
	timer.set_one_shot(false)
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	






func _on_Hurt_Box_area_entered(hurt_area:Hit_Box) -> void:
	if hurt_area == null:
		return

	if damage_taker == null:
		return

	var parent = get_parent()

	if hurt_area.get_parent() == parent:
		return

	var dmg = hurt_area.damage

	if damage_taker.has_method("take_damage"):
		damage_taker.take_damage(dmg)




func _on_timer_timeout():

	if damage_taker == null:
		queue_free()
		return


	var areas = get_overlapping_areas()
	for area in areas:
		if area.owner == owner:
			continue
		if damage_taker.has_method("take_damage"):
			var damage = area.damage
			damage_taker.take_damage(damage)

	

