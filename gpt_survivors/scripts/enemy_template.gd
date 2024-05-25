extends CharacterBody2D
@export var health : int = 100



const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta):
	# Handle the movement.
	delta = delta # this is so the lsp doesn't complain about the unused variable


	# input pathfinding here

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func take_damage(dmg):
	# Handle the damage.
	health -= dmg
	if health <= 0:
		die()



func die():
	# Handle the death.
	queue_free()

