class_name Bullet

extends RigidBody2D

@export var speed = 1000
@export var damage_type :String = "physical"
@export var damage_project = 100
@export var direction = Vector2(0, 0)
@export var die_time = 1
@export var peircing = false

@onready var hitbox = $Hit_Box
@onready var sprite = $Sprite2D

var type = "projectile"

var timer = null


func _ready():
	hitbox.damage = damage_project
	hitbox.damage_type = damage_type
	hitbox.type = type


	# deleat bulet after a certain amount of time
	timer = Timer.new()
	timer.set_wait_time(die_time)
	timer.timeout.connect(queue_free)
	timer.one_shot = true
	add_child(timer)
	timer.start()

	self.body_entered.connect(on_body_entered)
	hitbox.area_entered.connect(on_body_entered)


	if abs(direction.angle()) > 1.5:

		var angle = direction.angle()

		angle = 3 if angle < 0 else 3

		sprite.flip_h = true

		rotation = (direction.angle()+angle)
		pass

		pass

		


	



func _physics_process(_delta):
	linear_velocity = direction * speed

func on_body_entered(body):
	if not body is Hurt_Box or peircing:
		return

	if body.type == type:
		return
	queue_free()



	
	
	 


