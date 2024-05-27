class_name Bullet

extends RigidBody2D

@export var speed = 1000
@export var damage_type :String = "physical"
@export var damage_project = 100
@export var direction = Vector2(0, 0)

@onready var hitbox = $Hit_Box
@onready var sprite = $Sprite2D

func _ready():
	hitbox.damage = damage_project
	hitbox.damage_type = damage_type



func _physics_process(delta):
	delta = delta
	apply_central_force(direction * speed)

	# Destroy bullet if it goes off screen
	# if !get_viewport_rect().has_point(global_position):
	# 	print("Bullet went off screen")
	# 	queue_free()

	
	
	 


