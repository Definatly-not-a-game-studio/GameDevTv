class_name Weapon
extends Marker2D


# the reloading signal
signal reloading
signal done_reloading

@export var bullet : PackedScene = preload("res://scenes/Bullets/bullet.tscn")


# properties of a weopn
@export var damage = 10
@export var damage_type = "Physical"
@export var bullet_speed = 1000
@export var fire_rate = 0.3
@export var range_time = 0.1
@export var clip_size = 10
@export var reload_time = 2.0
@export var bullet_scale : float = 1.0
@export var full_auto = false



@onready var barrel = $Barrel_End


# The center of the player
var center = null
var reload_timer = null
var fire_timer = null


# keep track of amo
var amunition = clip_size

# enable fireing
var can_fire = true



# Called when the node enters the scene tree for the first time.
func _ready():
	center = get_parent()
	# create a timer for reloading
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.timeout.connect(reload_complete)
	add_child(reload_timer)
	

	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true
	fire_timer.timeout.connect(cooldown_finished)
	add_child(fire_timer)


func _process(_delta):
	fire_timer.wait_time = fire_rate
	reload_timer.wait_time = reload_time




func shoot():
	# check if the player can fire
	if not can_fire:
		return

	amunition -= 1


	var bullet_instance = bullet.instantiate()
	
	# Set the bullet's position to the center of the player
	bullet_instance.global_position = barrel.global_position 
	
	# Set the bullet's direction to the center's rotation
	bullet_instance.rotation = center.rotation

	bullet_instance.direction = center.global_position.direction_to(global_position)
	bullet_instance.global_position += bullet_instance.direction * 15
	bullet_instance.damage_project = damage
	bullet_instance.damage_type = damage_type
	bullet_instance.speed = bullet_speed
	bullet_instance.die_time = range_time
	bullet_instance.scale = bullet_instance.scale * bullet_scale


	
	# Add the bullet to the scene
	get_tree().get_root().add_child(bullet_instance)

	# disable fireing until the cooldown is finished or the player reloads
	can_fire = false

	# if the player is out of amunition, start the reload timer
	if amunition <= 0:
		reload()

	# else start the fire timer
	else:
		fire_timer.start()


func reload_complete():
	amunition = clip_size
	can_fire = true
	emit_signal("done_reloading")

func cooldown_finished():
	can_fire = true


func reload():
		reload_timer.start()
		can_fire = false
		emit_signal("reloading")


