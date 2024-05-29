class_name Player

extends CharacterBody2D


signal died

@onready var center = $Center
@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $Hurt_Box
@onready var reload_sprite = $Reload_Sprite
@onready var lifestate = $LifeState
@onready var upgrade_manager = $Upgrade_Manager

@export var loaded_weapon : PackedScene = preload("res://scenes/Test_Scenes/Brandon/weapon.tscn")

var death_scene : PackedScene = preload("res://scenes/Menu_Scenes/Death_Menu/Death_Menu.tscn")







const SPEED = 175.0
const DASH_SPEED = 300.0


var dash_time = 0.5
var is_dashing = false
var direction : Vector2
var is_flipped = false



var my_weapon = null


func _ready():
	# creates an instance of the weapon and adds it to the player
	change_weapon(loaded_weapon)
	my_weapon.reloading.connect(reload)
	my_weapon.done_reloading.connect(reload_done)
	# sets the weapon to the upgrade manager
	$Upgrade_Manager.weapon = my_weapon

	lifestate.hit.connect(damage_taken)

	hurtbox.knock_back.connect(knockBack)

	sprite.play("idle")

	




func _physics_process(_delta):
	orient_body()
	process_movement()
	move_and_slide()

	# Shoots the bullet when the shoot action is pressed or held and full_auto is true
	if Input.is_action_just_pressed("shoot") or (Input.is_action_pressed("shoot") and my_weapon.full_auto):
		my_weapon.shoot()

	if Input.is_action_just_pressed("reoload"):
		my_weapon.reload()
	
	if Input.is_action_just_pressed("dash"):
		dash()
	

	

func process_movement():
	# Get direction based on inputs
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
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
	
	# Rotates the center point node to aim weapon
	center.look_at(mousePos)
	
	var position_diff = global_position.x - mousePos.x
	
	# Determines if the cursor goes behind the player
	if position_diff > 0 and not is_flipped:
		# If cursor is behind, flip character by scaling by -1
		apply_scale(Vector2(-1,1))
		is_flipped = true
		
	# Determines if the cursor goes behind the player (when already flipped)
	elif position_diff < 0 and is_flipped:
		# If cursor is behind, flip character by scaling by -1
		apply_scale(Vector2(-1,1))
		is_flipped = false 



func die():
	var camera = get_node("Camera2D")
	var node = Node2D.new()
	remove_child(camera)
	node.position = global_position
	get_parent().add_child(node)
	node.add_child(camera)

	emit_signal("died")

	get_tree().call_deferred("change_scene_to_packed",death_scene)
	call_deferred("queue_free")
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


func knockBack(knockback : Vector2 , knockback_value : float = 10):
	position += -knockback * knockback_value

func dash():

	if is_dashing:
		return
	var ani = "roll"



	is_dashing = true
	velocity = DASH_SPEED * direction.normalized()
	sprite.play(ani)
	hurtbox.set_invincible(true)

	await get_tree().create_timer(dash_time).timeout
	is_dashing = false
	#enable hitcolision
	hurtbox.set_invincible(false)
	sprite.play("idle")

	










