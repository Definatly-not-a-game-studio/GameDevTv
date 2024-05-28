class_name LifeState
extends Node2D

signal hit

#the health of the object
@export var health : float = 100
#this will show the health in the console
@export var debug_health : bool = false
#value for invincibility
@export var invincible : bool = false



func take_damage(damage : int) -> void:
	if invincible:
		return


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
			



