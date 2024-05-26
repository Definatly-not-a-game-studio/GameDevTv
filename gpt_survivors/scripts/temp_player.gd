extends CharacterBody2D


func die():
	print("I'm dead")
	queue_free()
