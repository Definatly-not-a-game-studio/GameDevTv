class_name Bullet

extends RigidBody2D

@export var speed = 1000
@export var damage_type :String = "physical"
@export var damage_project = 100
@export var direction = Vector2(0, 0)
@export var die_time = 1

@onready var hitbox = $Hit_Box
@onready var sprite = $Sprite2D


func _ready():
	hitbox.damage = damage_project
	hitbox.damage_type = damage_type


	# deleat bulet after a certain amount of time
	var timer = Timer.new()
	timer.set_wait_time(die_time)
	timer.timeout.connect(queue_free)
	timer.one_shot = true
	add_child(timer)
	timer.start()

	self.body_entered.connect(on_body_entered)
	hitbox.area_entered.connect(on_body_entered)

	if direction.angle() > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


	



func _physics_process(_delta):
	linear_velocity = direction * speed

func on_body_entered(body):
	if not body is Hurt_Box:
		return
	queue_free()



	
	
	 


