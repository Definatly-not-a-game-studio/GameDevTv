extends CanvasLayer

@export var upgrade_manager: Upgrade_Manager
@export var life : LifeState
@export var weapon :Weapon = null

@onready var healthbar : ProgressBar = $HealthBar
@onready var score_lbl : Label = $Score
@onready var cash_lbl : Label = $Cash
@onready var ammo_lbl : Label = $lbl_ammo
@onready var inst_contrl : Control = $instuctions

@onready var score_getter = SaveGame.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	fade_instructions()
	if score_getter.get_high_score() == 0:
		fade_instructions()
	else:
		kill_controlls()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score_lbl.text = "Score  "+str(upgrade_manager.score)
	cash_lbl.text = " "+str(upgrade_manager.loot)
	healthbar.value = life.health

	if weapon != null:
		ammo_lbl.text = ": "+ str(weapon.amunition)+"/"+str(weapon.clip_size)
	else:
		ammo_lbl.text = ""


func fade_instructions():
	await get_tree().create_timer(10.0).timeout
	kill_controlls()

func kill_controlls():
	inst_contrl.hide()
	inst_contrl.queue_free()
