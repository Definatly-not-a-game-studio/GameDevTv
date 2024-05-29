class_name Pathfinder
extends Node2D

@export var target : Node2D = null
@export var Find_target_rate = 0.5

var pathfinding_agent : NavigationAgent2D = null


func _ready():

	if target == null:
		# find the player
		target = owner.target_entitie
	
	#find the NavigationAgent2D child
	pathfinding_agent = get_node_or_null("NavigationAgent2D")
	if pathfinding_agent == null:
		pathfinding_agent = NavigationAgent2D.new()
		add_child(pathfinding_agent)

	find_new_target()


	if target == null:
		print("No target found")
		return

	# create a timer to find the target
	var timer = Timer.new()
	timer.set_wait_time(Find_target_rate)
	timer.set_one_shot(false)
	timer.timeout.connect(find_target)
	add_child(timer)
	timer.start()


func find_target():
	find_new_target()
	if target == null:
		return null
	pathfinding_agent.target_position = target.global_position


# return the next position to move to or null if the navigation is finished
func next_position():
	find_new_target()
	if target == null:
		return null
	# if pathfinding_agent.is_navigation_finished():
	# 	return null

	var pos = pathfinding_agent.get_next_path_position()


	return pos



func find_new_target():
	if target != null:
		return


	var new_target = get_tree().get_root().get_children()[0].get_node("Hero")
	print(new_target)

	if new_target == null:
		return
	target = new_target




