class_name Upgrade_Screen

extends CanvasLayer



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
			return "Clip Upgrade"
		Upgrade_Type.DAMAGE_UPGRADE:
			return "Damage Upgrade"
		Upgrade_Type.FIRE_RATE_UPGRADE:
			return "Fire Rate Upgrade"
		Upgrade_Type.RANGE_UPGRADE:
			return "Range Upgrade"
		Upgrade_Type.PICKUP_UPGRADE:
			return "Pickup Upgrade"
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
	# create 3 upgrades
	animated_sprite_2d.play("default")
	pass





	

	



