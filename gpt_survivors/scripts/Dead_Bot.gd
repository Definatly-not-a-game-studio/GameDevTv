class_name Dead_Bot
extends Area2D

@onready var sprite = $AnimatedSprite2D
@export var death_timer = 10
@export var value = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("death")
	var timer = Timer.new()
	timer.set_wait_time(death_timer)
	timer.one_shot = true
	timer.timeout.connect(death_timer_timeout)
	add_child(timer)
	timer.start()

	

func death_timer_timeout():
	queue_free()

