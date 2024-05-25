class_name LifeState
extends Node2D

@export var health : int = 100



func take_damage(damage : int) -> void:
	health -= damage

	if health <= 0:
		#check if the owner has a die method
		if owner.has_method("die"):
			owner.die()
		#else kill the node
		else:
			queue_free()



