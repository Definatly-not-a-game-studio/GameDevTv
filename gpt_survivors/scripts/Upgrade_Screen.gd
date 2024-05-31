class_name Upgrade_Screen

extends CanvasLayer

@export var button_left : Button = null
@export var button_center : Button = null
@export var button_right : Button = null



#enums for upgrade types

enum Upgrade_Type { 
	CLIP_UPGRADE, # = 0
	DAMAGE_UPGRADE,
	FIRE_RATE_UPGRADE,
	RANGE_UPGRADE,
	PICKUP_UPGRADE,
}

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
func create_upgrade():
	var upd = {}
	upd.id = randi() % 5 #random upgrade
	upd.value = randi() % 5 + 1 #random value between 1 and 5
	upd.name = upgrade_name(upd.id)
	upd.rarirty = randi() % 5 + 1 #random value between 1 and 5
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
		_:
			pass


func _ready():
	# set the upgrade manager to the player
	upgrade_mg = player.upgrade_manager

	var buttons = [button_left, button_center, button_right]
	for i in range(3):
		var upgrade = create_upgrade()
		buttons[i].update_text(upgrade.id, upgrade.name, upgrade.value, upgrade.rarirty)
		buttons[i].upgrade_selected.connect(selected)

func selected(type : int, value : int):
	use_upgrade(type, value)
	get_tree().paused = false
	queue_free() #close the upgrade screen





	pass




