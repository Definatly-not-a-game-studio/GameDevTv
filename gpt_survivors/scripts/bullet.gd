class_name Bullet

extends Hit_Box

@export var speed = 50
@export var damage_type = "physical"
@export var direction = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	position += direction * speed * delta
	
	
	 


