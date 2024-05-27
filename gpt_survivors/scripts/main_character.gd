class_name Player

extends CharacterBody2D


signal died

@onready var center = $Center
@onready var sprite = $Sprite2D
@onready var reload_sprite = $Reload_Sprite

@export var loaded_wepon : PackedScene = preload("res://scenes/Test_Scenes/Brandon/weapon.tscn")







const SPEED = 175.0
var direction : Vector2
var is_flipped = false



var my_wepon = null


func _ready():
	# creates an instance of the weapon and adds it to the player
	change_wepon(loaded_wepon)
	my_wepon.reloading.connect(reload)
	my_wepon.done_reloading.connect(reload_done)

	




func _physics_process(delta):
	orient_body()
	process_movement()
	move_and_slide()

	# Shoots the bullet when the shoot action is pressed or held and full_auto is true
	if Input.is_action_just_pressed("shoot") or (Input.is_action_pressed("shoot") and my_wepon.full_auto):
		my_wepon.shoot()
	

	

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



func die():
	var camera = get_node("Camera2D")
	var node = Node2D.new()
	remove_child(camera)
	node.position = global_position
	get_parent().add_child(node)
	node.add_child(camera)

	emit_signal("died")
	
	queue_free()

func change_wepon(new_wepon : PackedScene):
	if my_wepon != null:
		my_wepon.queue_free()
	my_wepon = new_wepon.instantiate()
	center.add_child(my_wepon)

func reload():
	reload_sprite.play("reload")

func reload_done():
	reload_sprite.play("default")

	



