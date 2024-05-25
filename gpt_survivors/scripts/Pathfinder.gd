class_name Pathfinder
extends Node2D

@export var target : Node2D = null
@export var Find_target_rate = 0.5

@onready var pathfinding_atgent= $NavigationAgent2D

func _ready():

	if target == null:
		# find the player
		target = get_node("/root/Player")



	if target == null:
		print("No target found")
		return

	# create a timer to find the target
	var timer = Timer.new()
	timer.set_wait_time(Find_target_rate)
	timer.set_one_shot(false)
	timer.timeout.connect("find_target")
	add_child(timer)


func find_target():
	pathfinding_atgent.target_position = target.global_position


# return the next position to move to or null if the navigation is finished
func next_position():
	if pathfinding_atgent.is_navigation_finished():
		return null



	return pathfinding_atgent.get_next_path_position()







