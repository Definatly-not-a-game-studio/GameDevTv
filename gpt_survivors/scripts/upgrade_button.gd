extends Button


@onready var title : Label = $lbl_Title
@onready var body : Label = $lbl_body







# Called when the node enters the scene tree for the first time.
func _ready():
	update_text("Health", 10, 1)
	pass # Replace with function body.


func update_text(ability : String, increase : int, rarity : int):
	title.text = "upgrade " + ability
	body.text = "Increase " + ability + " by " + str(increase) +"\r" + "Rarity: " + str(rarity)

