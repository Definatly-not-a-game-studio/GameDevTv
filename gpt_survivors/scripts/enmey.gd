class_name enemy

extends CharacterBody2D

@onready var pathfinder = $Pathfinder
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hit_Box
@onready var hurtbox = $Hurt_Box
@onready var life = $LifeState
@onready var death_scene = preload("res://scenes/Test_Scenes/Brandon/dead_bot.tscn")

@export var speed = 100
@export var target_entitie :CharacterBody2D = null
@export var value = 10
@export var damage_multiplier : float = 1
@export var health_multiplier : float = 1

@export var projectile : PackedScene = null



var random_direction = Vector2(0, 0)


func _ready():
	hitbox.damage = hitbox.damage * damage_multiplier
	life.health = life.health * health_multiplier

	# handle code for optional projectile here
	if projectile != null:
		pass

	# all enemies will have a walk animation
	sprite.play("walk")

	# find the player node
	random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if target_entitie == null:
		return
	
	# connect the knockback signal from hurtbox
	hurtbox.knock_back.connect(knockBack)



func _process(_delta):

	# determine the target position
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
	sprite.flip_h = direction.x < 0

	move_and_slide()

func die():
	# spawn the death scene
	var dead_bot = death_scene.instantiate()
	dead_bot.global_position = global_position
	dead_bot.value = value
	# defer this call
	get_parent().call_deferred("add_child", dead_bot)

	self.call_deferred("queue_free")


func knockBack(knockback : Vector2 , knockback_value : float = 20):
	# override the knockback function
	knockback = global_position.direction_to(target_entitie.global_position)

	position += -knockback * knockback_value
