class_name Upgrade_Manager

extends Area2D


@export var player : Player = null
@export var lifestate : LifeState = null
@export var weapon : Weapon = null
@export var lootgrabber : loot_grabber = null
@export var amo_bar : TextureProgressBar = null

var loot : int = 100
var score : int = 0

func _ready():
	if player == null:
		player = get_parent()
	if lifestate == null:
		lifestate = player.get_node("LifeState")
	if lootgrabber == null:
		lootgrabber = player.get_node("loot_grabber")
	if amo_bar == null:
		amo_bar = player.get_node("TextureProgressBar")

	#check if all nodes are present
	if player == null or lifestate == null  or lootgrabber == null:
		print("Upgrade_Manager: missing nodes")
		print("player: ", player)
		print("lifestate: ", lifestate)
		print("weapon: ", weapon)
		print("lootgrabber: ", lootgrabber)
		return

	#connect signals
	lootgrabber.loot_grabbed.connect(loot_collected)

func _process(_delta):
	update_amo_bar(weapon.amunition, weapon.clip_size)


func loot_collected(value: int):
	loot += value
	score += value
	print("loot: ", loot)

func spend_loot(value: int):
	if loot >= value:
		loot -= value
		return true
	else:
		return false

## sets the amo bar to value/max_value
func update_amo_bar(value: int, max_value: int):
	amo_bar.value = value
	amo_bar.max_value = max_value

## increases the clip size by value and resets the amunition
func increase_clip_size(value: int):
	#increase clip size and reset amunition
	weapon.clip_size += floor((weapon.clip_size* value/100.0))
	weapon.amunition = weapon.clip_size
	update_amo_bar(weapon.amunition, weapon.clip_size)
	print("clip size: ", weapon.clip_size)

## increases the wepon value by value
func increase_damage(value: int):
	weapon.damage += floor((weapon.damage* value/100.0))
	print("damage: ", weapon.damage)

## decrease fire_timer by value
func increase_fire_rate(value: int):
	weapon.fire_rate -= (weapon.fire_rate* value/100.0)
	weapon.fire_rate = max(weapon.fire_rate, 0.01)
	if weapon.fire_rate <= 0.01:
		weapon.full_auto = true

	print("fire rate: ", weapon.fire_rate)

## increase range_time(time till the bullet is destroyed) by value
func increase_range_time(value: float):
	# weapon.range_time += ((weapon.range_time*100 * value)/1000.00)*2
	weapon.range_time += value
	print("range time: ", weapon.range_time)


## increase the pickup range by value
func increase_pickup_range(value: float):
	var increase = floor((lootgrabber.radius* value/100.0))
	lootgrabber.increase_radius(increase)
	print("pickup range: ", lootgrabber.radius)

func increase_reload_speed(value: int):
	weapon.reload_time -= (weapon.reload_time* value/100.0)
	weapon.reload_time = max(weapon.reload_time, 0.1)
	print("reload speed: ", weapon.reload_time)



