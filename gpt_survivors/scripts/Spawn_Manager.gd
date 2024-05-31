class_name Spawn_Manager
extends Node

@export var dificulty : int = 1
@export var spawn_rate : float = 1.0

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



func _process(_delta):
	if enemies_spawned > dificulty * 10:
		spawn_timer.stop()

		dificulty += 1
		spawn_rate -= 0.1
		spawn_timer.set_wait_time(spawn_rate)
		spawn_timer.start()






func spawn_enemies():
	wave_one_spawn()




## spawn all enemies on all child spawners
func spawn_enemies_all():
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			spawner.active = false
			spawner.damage_multiplier += dificulty*0.1
			spawner.health_multiplier += dificulty*0.1
			spawner.spawn()
			enemies_spawned += 1



## wave one spawn
func wave_one_spawn():
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			spawner.active = false

			# determin based off chance which spawner will spawn
			if randi() % 4 == 0:
				spawner.spawn()
				enemies_spawned += 1




## spawn a custom wave of enemies based off a list of enemies
func custom_wave_spawn(chance_to_spawn : int, list_of_enemies : Array):
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			spawner.active = false

			# determin based off chance which spawner will spawn
			if randi() % chance_to_spawn == 0:
				var enemy_node = load_enemy_nodes(list_of_enemies)
				spawner.spawn(enemy_node)
				enemies_spawned += 1




## load a random enemy node from a list of enemies
func load_enemy_nodes(list_of_enemies : Array):
	var enemy_node = null
	var enemy_loc = list_of_enemies[randi() % list_of_enemies.size()]
	enemy_node = load(enemy_loc)
	return enemy_node
	

func increase_difficulty():
	dificulty += 1
	print("Difficulty increased to: ", dificulty)









