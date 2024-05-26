class_name Spawner

extends Node2D

@export var spawn_enemy : PackedScene = null
@export var spawn_rate : float = 1.0
@export var target : CharacterBody2D = null
@export var active : bool = true

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(spawn_rate)
	timer.set_one_shot(false)
	timer.timeout.connect(spawn)
	add_child(timer)
	timer.start()


func spawn():
	if target == null:
		return



	var made_enemy = spawn_enemy.instantiate()
	made_enemy.position = position
	made_enemy.target_entitie = target
	get_parent().add_child(made_enemy)

