''' 
the spawner class spawns enemies at a set rate
'''

class_name Spawner

extends Node2D

# the enemy to spawn
@export var spawn_enemy : PackedScene = null
# the rate at which to spawn the enemy
@export var spawn_rate : float = 1.0
# the target for the enemy to attack
@export var target : CharacterBody2D = null
# whether the spawner is active
@export var active : bool = true
# the damage multiplier for the spawned enemy
@export var damage_multiplier : float = 1.0
# the health multiplier for the spawned enemy
@export var health_multiplier : float = 1.0

# limit spawns
@export var max_spawns : int = 0
# current spawns
var current_spawns : int = 0

var timer : Timer = null

func _ready():
	# create a timer to spawn the enemy
	timer = Timer.new()
	timer.set_wait_time(spawn_rate)
	timer.set_one_shot(false)
	timer.timeout.connect(spawn)
	add_child(timer)


	# start the timer if the spawner is active
	if active:
		timer.start()
		

func _process(_delta):

	if timer == null:
		return


	if active:
		if timer.is_stopped():
			timer.start()
	else:
		if not timer.is_stopped():
			timer.stop()
	pass



func spawn( _enemy : PackedScene = spawn_enemy):
	if max_spawns > 0 and current_spawns >= max_spawns:
		return

	# spawn the enemy
	var made_enemy = _enemy.instantiate()
	# apply the damage and health multipliers
	made_enemy.position = global_position
	made_enemy.target_entitie = target
	made_enemy.damage_multiplier = damage_multiplier
	made_enemy.health_multiplier = health_multiplier
	made_enemy.dead.connect(child_die)
	current_spawns += 1

	# add the enemy to the scene
	# get_parent().add_child(made_enemy)
	get_tree().get_root().get_children()[0].call_deferred("add_child", made_enemy)

func child_die():
	current_spawns -= 1


