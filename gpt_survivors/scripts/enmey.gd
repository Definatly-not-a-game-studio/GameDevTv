class_name enemy

extends CharacterBody2D

@onready var pathfinder = $Pathfinder
@onready var sprite = $AnimatedSprite2D

@export var speed = 100
@export var target_entitie :CharacterBody2D = null
var random_direction = Vector2(0, 0)


func _ready():
	sprite.play("walk")
	# find the player node
	random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if target_entitie == null:
		return



func _process(delta):
	delta = delta

	var target = pathfinder.next_position()

	#check if target is null
	if target == null:
		# generate random direction
		target = random_direction * 100 + global_position

	# get the current position of the agent
	var current_agent_position = global_position


	# set the velocity of the agent to move towards the target
	velocity = current_agent_position.direction_to(target)

	velocity = velocity * speed

	var direction = velocity.normalized()

	# get the angle of the direction to determine the direction of the sprite
	sprite.flip_v = abs(direction.angle()) > 90

	move_and_slide()

func die():
	print("Enemy died")
	queue_free()




