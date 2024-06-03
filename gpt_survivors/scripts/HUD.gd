extends CanvasLayer

@export var upgrade_manager: Upgrade_Manager
@export var life : LifeState
@export var weapon :Weapon = null

@onready var healthbar : ProgressBar = $HealthBar
@onready var score_lbl : Label = $Score
@onready var cash_lbl : Label = $Cash
@onready var ammo_lbl : Label = $lbl_ammo


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score_lbl.text = "Score  "+str(upgrade_manager.score)
	cash_lbl.text = " "+str(upgrade_manager.loot)
	healthbar.value = life.health

	if weapon != null:
		ammo_lbl.text = ": "+ str(weapon.amunition)+"/"+str(weapon.clip_size)
	else:
		ammo_lbl.text = ""



	
