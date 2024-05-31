class_name enemy

extends CharacterBody2D

signal dead

@onready var pathfinder = $Pathfinder
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hit_Box
@onready var hurtbox = $Hurt_Box
@onready var life = $LifeState
@onready var death_scene = preload("res://scenes/Enemies/dead_bot.tscn")

@export var speed = 100
@export var target_entitie :CharacterBody2D = null
@export var value = 10
@export var damage_multiplier : float = 1
@export var health_multiplier : float = 1

@export var projectile : PackedScene = null
@export var proj_speed : float = 100
@export var proj_spawn_rate : float = 5
@export var ranged : bool = false


var knocking_back = false
var knockback_velocity = Vector2(0,0)

var random_direction = Vector2(0, 0)

## the distace an enemy will stop aproaching the player
var range_distance = 75



func _ready():
	#enable y sorting
	y_sort_enabled = true
	sprite.y_sort_enabled = true
	



	hitbox.damage = hitbox.damage * damage_multiplier
	life.health = life.health * health_multiplier

	# handle code for optional projectile here
	if projectile != null:
		var proj_timer = Timer.new()
		proj_timer.wait_time = proj_spawn_rate
		proj_timer.one_shot = false
		proj_timer.timeout.connect(shoot_projectile)
		add_child(proj_timer)
		proj_timer.start()


	# all enemies will have a walk animation
	sprite.play("walk")

	# find the player node
	random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if target_entitie == null:
		return
	
	# connect the knockback signal from hurtbox
	hurtbox.knock_back.connect(knockBack)



func _process(_delta):

	if knocking_back:
		velocity = knockback_velocity*speed
		return

	# determine the target position
	var target = pathfinder.next_position()

	#check if target is null
	if target == null:
		# generate random direction
		target = random_direction * 100 + global_position
	
	# check if ranged is selected


	var dis = global_position.distance_to(pathfinder.target.global_position)


	if ranged and dis < range_distance:
		return



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
	emit_signal("dead")

	self.call_deferred("queue_free")


func knockBack(_knockback : Vector2 ):

	if knocking_back:
		return

	if target_entitie == null:
		return


	# override the knockback function
	knockback_velocity = global_position.direction_to(target_entitie.global_position) 
	knocking_back = true

	await get_tree().create_timer(0.1).timeout
	knocking_back = false






func shoot_projectile():
	# check if the target is null

	if pathfinder == null:
		return
	target_entitie = pathfinder.target

	if target_entitie == null:
		return

	# get distance to target
	var distance = global_position.distance_to(target_entitie.global_position)

	if distance > 200:
		return




	# spawn the projectile
	var proj = projectile.instantiate()
	proj.speed = proj_speed
	proj.damage_project = int(hitbox.damage *damage_multiplier)
	proj.type = "enemy"
	
	var dir = global_position.direction_to(target_entitie.global_position)
	proj.direction = dir
	proj.rotation = dir.angle()
	proj.global_position = global_position + dir * 10


	get_tree().get_root().add_child(proj)


	






