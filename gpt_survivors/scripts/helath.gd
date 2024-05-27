class_name LifeState
extends Node2D

@export var health : float = 100
@export var debug_health : bool = false



func take_damage(damage : int) -> void:
	health -= damage

	#debugging
	if debug_health:
		print("Health: ", health)

	if health <= 0:
		#check if the owner has a die method
		var parent = get_parent()
		if owner.has_method("die"):
			owner.die()
		#else kill the node
		elif parent.has_method("die"):
			parent.die()
		else:
			parent.queue_free() #kill the node
			



