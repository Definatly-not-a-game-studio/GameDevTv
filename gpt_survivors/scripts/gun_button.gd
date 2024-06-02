class_name  GunButton

extends Button


signal select_gun(gun : PackedScene)

@export var _name = "Button"
@export var gun : PackedScene = null
@export var score_required = 0

@onready var lbl = $Label
@onready var gun_instance = gun.instantiate()
@onready var control = $VBoxContainer

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.button_up.connect(_on_Button_pressed)


	gun_instance.scale = Vector2(5,5)
	control.add_child(gun_instance)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score < score_required:
		lbl.text =  str(score) + "/" + str(score_required)
		self.disabled = true
	else:
		lbl.text = _name


func _on_Button_pressed():
	if score >= score_required:
		emit_signal("select_gun", gun)
