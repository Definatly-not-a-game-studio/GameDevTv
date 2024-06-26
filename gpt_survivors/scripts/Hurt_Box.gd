class_name Hurt_Box
extends Area2D

signal knock_back( knockback:Vector2)


@export var damage_taker : LifeState = null
@export var type : String = "enemy"

var invincible : bool = false

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
	damage_me(hurt_area)





func damage_me(hurt_area :Hit_Box):
	if hurt_area == null:
		return
	if invincible:
		return

	if hurt_area.type == type:
		return



	if damage_taker == null:
		return

	var parent = get_parent()

	if hurt_area.get_parent() == parent:
		return

	var dmg = hurt_area.damage

	if damage_taker.has_method("take_damage"):
		damage_taker.take_damage(dmg)

	# claculate knockback
	var my_pos = global_position
	var hit_pos = hurt_area.global_position

	var knockback = my_pos.direction_to(hit_pos)


	# emit knockback signal with the direction oposite the knockback
	knock_back.emit(knockback)





func _on_timer_timeout():
	if invincible:
		return

	if damage_taker == null:
		queue_free()
		return


	var areas = get_overlapping_areas()
	for area in areas:
		if area.owner == owner:
			continue
		damage_me(area)



func set_invincible(value:bool):
	invincible = value
	

