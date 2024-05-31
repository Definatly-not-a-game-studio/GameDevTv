class_name Upgrade_Screen

extends CanvasLayer

@export var button_left : Button = null
@export var button_center : Button = null
@export var button_right : Button = null

@export var upgrade_boost : int = 1
@export var luck_boost : int = 0

signal increase_difficulty



#enums for upgrade types

const RARITY_CHANCE = 70

enum Upgrade_Type { 
	CLIP_UPGRADE, # = 0
	DAMAGE_UPGRADE,
	FIRE_RATE_UPGRADE,
	RANGE_UPGRADE,
	PICKUP_UPGRADE,
	RELOAD_UPGRADE
}

const UPGRADE_COUNT = 6

@onready var animated_sprite_2d = $AnimatedSprite2D




#the player who is upgrading
@export var player : Player = null

#upgrade manager of the player
var upgrade_mg : Upgrade_Manager = null


# determin the upgrades 
# display them in boxes 
# then once selected apply the upgrade to the player
# then close the upgrade screen ie queue_free()

## create a update object and return it
## the object will id,value and name
func create_upgrade(start_val = 1, luck = 0):
	var upd = {}

	upd.id = randi() % UPGRADE_COUNT #random upgrade

	upd.rarirty = get_rarity(start_val, luck)

	#random value between 0 and 20 + the rarity * 10
	upd.value = randi() % 4*5 + upd.rarirty * 10 

	upd.name = upgrade_name(upd.id)
	return upd




func upgrade_name(type : int) -> String:
	match type:
		Upgrade_Type.CLIP_UPGRADE:
			return "Clip Size"
		Upgrade_Type.DAMAGE_UPGRADE:
			return "Damage"
		Upgrade_Type.FIRE_RATE_UPGRADE:
			return "Fire Rate"
		Upgrade_Type.RANGE_UPGRADE:
			return "Bullet Range"
		Upgrade_Type.PICKUP_UPGRADE:
			return "Pickup Range"
		Upgrade_Type.RELOAD_UPGRADE:
			return "Reload Speed"
		_:
			return "Unknown Upgrade"

func use_upgrade(type : int, value : int):
	match type:
		Upgrade_Type.CLIP_UPGRADE:
			upgrade_mg.increase_clip_size(value)
		Upgrade_Type.DAMAGE_UPGRADE:
			upgrade_mg.increase_damage(value)
		Upgrade_Type.FIRE_RATE_UPGRADE:
			upgrade_mg.increase_fire_rate(value)
		Upgrade_Type.RANGE_UPGRADE:
			upgrade_mg.increase_range_time(value)
		Upgrade_Type.PICKUP_UPGRADE:
			upgrade_mg.increase_pickup_range(value)
		Upgrade_Type.RELOAD_UPGRADE:
			upgrade_mg.increase_reload_speed(value)
		_:
			pass


func _ready():
	animated_sprite_2d.play()

	player.hud.hide()

	populate_upgrades(upgrade_boost, luck_boost)




func populate_upgrades(start_val = 1, luck = 0):
	# set the upgrade manager to the player
	upgrade_mg = player.upgrade_manager

	var buttons = [button_left, button_center, button_right]
	for i in range(3):
		var upgrade = create_upgrade(start_val, luck)
		buttons[i].update_text(upgrade.id, upgrade.name, upgrade.value, upgrade.rarirty)
		buttons[i].upgrade_selected.connect(selected)
		




func selected(type : int, value : int):
	use_upgrade(type, value)
	get_tree().paused = false
	emit_signal("increase_difficulty")
	player.hud.show()
	queue_free() #close the upgrade screen
	pass




func get_rarity(start_val = 1, luck = 0) -> int:
	var rarity = randi() % 100

	if rarity >= 100:
		return start_val

	# if the rarity is greater than the chance - the luck
	if rarity > RARITY_CHANCE - luck:
		start_val += 1
		return get_rarity(start_val, luck)

	else:
		return start_val

	

