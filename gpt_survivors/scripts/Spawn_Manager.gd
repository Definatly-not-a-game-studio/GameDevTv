class_name Spawn_Manager
extends Node

@export var dificulty : int = 1
@export var spawn_rate : float = 1.0

@export var debug : bool = false

var enemies_killed : int = 0
var spawn_timer :Timer = null
var enemies_spawned :int  = 0

func _ready():
	#start the spawn loop
	spawn_enemies()
	set_process(true)

	spawn_timer = Timer.new()
	spawn_timer.set_wait_time(spawn_rate)
	spawn_timer.set_one_shot(false)
	spawn_timer.timeout.connect(spawn_enemies)
	add_child(spawn_timer)
	spawn_timer.start()

	# connect the enemie_died signal to the enemie_killed function
	var children = self.get_children()
	for child in children:
		if child is Spawner:
			child.enemie_died.connect(enemie_killed)

	



func _process(_delta):
	# if enemies_spawned > factorial(dificulty) *10:
	# 	increase_difficulty()
	pass


func factorial(n):
	if n == 0:
		return 1
	else:
		return n * factorial(n-1)




func spawn_enemies():
	# wave_one_spawn()
	custom_wave_spawn(4-floor(dificulty/10.0), get_enemy_nodes())




## spawn all enemies on all child spawners
func spawn_enemies_all():
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			spawner.active = false
			spawner.health_multiplier += 0.01
			spawner.spawn()
			enemies_spawned += 1



## wave one spawn
func wave_one_spawn():
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			spawner.active = false
			spawner.health_multiplier += 0.01
			spawner.active = false

			# determin based off chance which spawner will spawn
			if randi() % 4  == 0:
				spawner.spawn()
				enemies_spawned += 1




## spawn a custom wave of enemies based off a list of enemies
func custom_wave_spawn(chance_to_spawn : int, list_of_enemies : Array):
	# get all the spawners
	var spawners = self.get_children()

	for  spawner in spawners:

		#check if the node is a spawner
		if spawner is Spawner:
			# set the spawner to be inactive
			spawner.active = false
			spawner.damage_multiplier += spawner.damage_multiplier*0.1
			spawner.health_multiplier += dificulty*0.01
			spawner.active = false

			# check if the max number of enemies have been spawned
			if enemies_spawned >= get_enmemies_max():
				return

			# determin based off chance which spawner will spawn
			if randi() % max(chance_to_spawn,1) == 0:
				var enemy_node = load_enemy_nodes(list_of_enemies)
				spawner.spawn(enemy_node)
				enemies_spawned += 1



## load a random enemy node from a list of enemies
func load_enemy_nodes(list_of_enemies : Array):
	var enemy_node = null
	var enemy_loc = list_of_enemies[randi() % list_of_enemies.size()]
	enemy_node = load(enemy_loc)
	return enemy_node


func get_enemy_nodes():
	var enemy_nodes = []
	var enemy_dir = "res://scenes/Enemies/"
	var enemy_files = [
		"controler_bot.tscn",
		"rob_bot.tscn",
		"skull_bot.tscn",
		"zombie_bot.tscn",
		]


	for file in enemy_files:
		if file.ends_with("dead_bot.tscn"):
			continue
		enemy_nodes.append(enemy_dir+  file)
	return enemy_nodes
	

func increase_difficulty():
	spawn_timer.stop()

	dificulty += 1
	spawn_rate -=  spawn_rate * 0.05
	spawn_timer.set_wait_time(spawn_rate)
	spawn_timer.start()
	if debug:
		print("Difficulty increased to: ", dificulty)
		print("Spawn rate: ", spawn_rate)
		print("Max enemies: ", get_enmemies_max())

func get_enemies_alive():
	var enemies :int = 0

	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			enemies += spawner.current_spawns
	return enemies

## return the max number of enemies that can be spawned
func get_enmemies_max():
	return max(dificulty * 20, 300)



func enemie_killed():
	if debug:
		print("Enemies killed: ", enemies_killed)

	enemies_killed += 1
	if enemies_killed % 10*dificulty == 0:
		increase_difficulty()





