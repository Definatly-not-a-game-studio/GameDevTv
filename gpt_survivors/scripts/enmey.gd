class_name enemy

extends CharacterBody2D

@onready var pathfinder = $Pathfinder
@onready var sprite = $AnimatedSprite2D

@export var SPEED = 100


func _ready():
	sprite.play("walk")

func _process(delta):
	delta = delta

	var target = pathfinder.next_position()

	#check if target is null
	if target == null:
		return

	# get the current position of the agent
	var current_agent_position = global_position

	# set the velocity of the agent to move towards the target
	velocity = current_agent_position.direction_to(target) * SPEED

	var direction = velocity.normalized()

	# get the angle of the direction to determine the direction of the sprite
	sprite.flip_v = abs(direction.angle()) > 90

	move_and_slide()

func die():
	print("Enemy died")
	queue_free()




