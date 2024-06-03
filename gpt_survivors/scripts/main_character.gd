class_name Player

extends CharacterBody2D


signal died

@onready var center = $Center
@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $Hurt_Box
@onready var reload_sprite = $Reload_Sprite
@onready var lifestate = $LifeState
@onready var upgrade_manager = $Upgrade_Manager
@onready var camera = $Camera2D
@onready var hud = $HUD
@onready var audio = $AudioStreamPlayer2D

@export var loaded_weapon : PackedScene = null

var death_scene : PackedScene = load("res://scenes/Menu_Scenes/Death_menu/Death_Menu.tscn")
var pause_scene : PackedScene = load("res://scenes/Menu_Scenes/Pause_Menu/Pause_Menu.tscn")


var knocking_back = false
var knockback_velocity = Vector2(0,0)

var weapons_list = [
	preload("res://scenes/Weapons/ak.tscn"),
	preload("res://scenes/Weapons/laser_cannon.tscn"),
	preload("res://scenes/Weapons/water_gun.tscn"),
	preload("res://scenes/Weapons/weapon.tscn"),
	]





const SPEED = 75.0
const DASH_SPEED = 120.0


var dash_time = 0.5
var is_dashing = false
var direction : Vector2
var is_flipped = false



var my_weapon = null



func _init():
	pass

func _ready():
	if loaded_weapon == null:
		loaded_weapon = random_weapon(weapons_list)
		setup_weapon(loaded_weapon)
	else:
		setup_weapon(loaded_weapon)
	
	hud.weapon = my_weapon







	hud.show()

	lifestate.hit.connect(damage_taken)

	hurtbox.knock_back.connect(knockBack)

	sprite.play("idle")

	# set hit and hurtbox to player
	hurtbox.type = "player"

	

func setup_weapon(weapon : PackedScene):
	change_weapon(loaded_weapon)
	my_weapon.reloading.connect(reload)
	my_weapon.done_reloading.connect(reload_done)
	# sets the weapon to the upgrade manager
	$Upgrade_Manager.weapon = my_weapon



func _physics_process(_delta):
	orient_body()
	process_movement()
	move_and_slide()

	if is_dashing:
		set_collision_mask_value(1, false)
		set_collision_layer_value(1, false)
	else:
		set_collision_mask_value(1, true)
		set_collision_layer_value(1, true)

	if Input.is_action_just_pressed("pause"):
		var _scene = pause_scene.instantiate()
		_scene.score = upgrade_manager.score
		get_tree().get_root().add_child(_scene)
		get_tree().paused = true
	



	# Shoots the bullet when the shoot action is pressed or held and full_auto is true
	if Input.is_action_just_pressed("shoot") or (Input.is_action_pressed("shoot") and my_weapon.full_auto) and not is_dashing:
		my_weapon.shoot()

	if Input.is_action_just_pressed("reoload"):
		my_weapon.reload()
	
	if Input.is_action_just_pressed("dash"):
		dash()
	

	

func process_movement():
	# Get direction based on inputs
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if knocking_back:
		velocity = knockback_velocity*SPEED
		return

	
	if direction and not is_dashing:
		# Keeps movement speed consistent by normalizing vector
		velocity = SPEED * direction.normalized()
		sprite.play("walk")
	elif is_dashing:
		velocity = DASH_SPEED * direction.normalized()
	else:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x * direction.x, 0, SPEED)
		velocity.y = move_toward(velocity.y * direction.y, 0, SPEED)


func orient_body():
	var mousePos = get_global_mouse_position()
	camera.offset = Vector2((mousePos.x - global_position.x)/10, (mousePos.y - global_position.y)/10)
	
	# Rotates the center point node to aim weapon
	center.look_at(mousePos)
	
	var position_diff = global_position.x - mousePos.x
	
	# Determines if the cursor goes behind the player
	if position_diff > 0 and not is_flipped:
		# If cursor is behind, flip character by scaling by -1
		center.apply_scale(Vector2(1,-1))
		sprite.flip_h = true
		is_flipped = true
		
	# Determines if the cursor goes behind the player (when already flipped)
	elif position_diff < 0 and is_flipped:
		# If cursor is behind, flip character by scaling by -1
		center.apply_scale(Vector2(1,-1))
		sprite.flip_h = false
		is_flipped = false 



func die():
	var node = Node2D.new()
	remove_child(camera)
	node.position = global_position
	get_parent().add_child(node)
	node.add_child(camera)

	emit_signal("died")
	
	hud.hide()
	var _scene = death_scene.instantiate()
	get_tree().get_root().add_child(_scene)
	_scene.set_score(upgrade_manager.score)

	get_tree().paused = true


	# set the death scene


	

func change_weapon(new_weapon : PackedScene):
	if my_weapon != null:
		my_weapon.queue_free()
	my_weapon = new_weapon.instantiate()
	center.add_child(my_weapon)

func reload():
	reload_sprite.play("reload")

func reload_done():
	reload_sprite.play("default")

	
# this is called when the player takes damage
func damage_taken():
	pass


func knockBack(knockback : Vector2 ):
	if knocking_back or is_dashing:
		return

	if audio != null:
		if not audio.is_playing():
			audio.play()


	# position += -knockback * knockback_value
	knockback_velocity = -knockback
	
	knocking_back = true
	await get_tree().create_timer(0.1).timeout
	knocking_back = false

func dash():

	if is_dashing:
		return

	is_dashing = true
	my_weapon.is_dashing = true
	velocity = DASH_SPEED * direction.normalized()
	if direction.x < 0 and not is_flipped or direction.x > 0 and is_flipped:
		sprite.play("roll_back")
	else:
		sprite.play("roll_fwd")
	hurtbox.set_invincible(true)

	await get_tree().create_timer(dash_time).timeout
	is_dashing = false
	my_weapon.is_dashing = false
	#enable hitcolision
	hurtbox.set_invincible(false)
	sprite.play("idle")


func random_weapon(weapon_list : Array):
	var weapon = weapon_list[randi() % weapon_list.size()]
	loaded_weapon = weapon
	return weapon









