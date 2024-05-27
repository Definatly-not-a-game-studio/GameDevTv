class_name Player

extends CharacterBody2D

@onready var center = $Center
@onready var sprite = $Sprite2D
@onready var barrel = $Center/Weapon/Barrel_End

const SPEED = 175.0
var direction : Vector2
var is_flipped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var bullet : PackedScene = preload("res://scenes/Test_Scenes/Brandon/bullet.tscn")



func _physics_process(delta):
	orient_body()
	process_movement()
	move_and_slide()

	# Shoots the bullet when the shoot action is pressed
	if Input.is_action_just_pressed("shoot"):
		shoot()

	

func process_movement():
	# Get direction based on inputs
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction:
		# Keeps movement speed consistent by normalizing vector
		velocity = SPEED * direction.normalized()
	else:
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


func shoot():
	var bullet_instance = bullet.instantiate()
	
	# Set the bullet's position to the center of the player
	bullet_instance.global_position = barrel.global_position 
	
	# Set the bullet's direction to the center's rotation
	bullet_instance.rotation = center.rotation

	bullet_instance.direction = center.global_position.direction_to(barrel.global_position)
	bullet_instance.global_position += bullet_instance.direction * 15

	print(bullet_instance.direction)
	
	# Add the bullet to the scene
	get_parent().add_child(bullet_instance)
