extends Button


@onready var title : Label = $lbl_Title
@onready var body : Label = $lbl_body

signal upgrade_selected(ability : int, increase : int)

var ability : int
var increase : int
var rarity : int
var up_name : String






# Called when the node enters the scene tree for the first time.
func _ready():
	update_text(1, "Health", 10, 1)
	self.pressed.connect(on_pressed)

	pass # Replace with function body.


func update_text(_ability : int, _name :String ,_increase : int, _rarity : int):
	ability = _ability
	increase = _increase
	rarity = _rarity
	up_name = _name
	title.text = "upgrade " + _name
	body.text = "Increase " + _name + " by " + str(_increase) +"%\r" + "Rarity: " + str(_rarity)

func on_pressed():
	print("pressed")
	upgrade_selected.emit(ability, increase)

