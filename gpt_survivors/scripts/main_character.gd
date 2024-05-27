class_name Player

extends CharacterBody2D

@onready var center = $Center
@onready var sprite = $Sprite2D

const SPEED = 175.0
var direction : Vector2
var is_flipped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	orient_body()
	process_movement()
	move_and_slide()

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
