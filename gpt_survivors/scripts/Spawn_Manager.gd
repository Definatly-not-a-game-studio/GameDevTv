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
		dificulty += 1
		spawn_rate -= 0.1
		spawn_timer.set_wait_time(spawn_rate)
		spawn_timer.start()




func spawn_enemies():
	var spawners = self.get_children()
	for  spawner in spawners:
		#check if the node is a spawner
		if spawner is Spawner:
			print("spawning")
			spawner.active = false
			spawner.spawn()
			enemies_spawned += 1



