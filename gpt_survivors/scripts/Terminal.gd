extends StaticBody2D


@export var player :Player = null
@export var powered : bool = false
@export var spawn_manager :Spawn_Manager = null

@onready var label :Label = $Label
@onready var sprite :AnimatedSprite2D = $AnimatedSprite2D
@onready var button :Button = $Button
@export var uses :int = 0



const upgrade_scene = "res://scenes/UI/upgrade_screen.tscn"
# var upgrade_screen :PackedScene = preload(upgrade_scene)

const DISTANCE_TO_UPGRADE = 50


var upgrade_cost = 10

# Called when the node enters the scene tree for the first time.
func _ready():

	select_animation()
	button.pressed.connect(action)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	select_animation()
	if not powered:
		return


	if player == null:
		get_player()
		print("Player is null")
		return

	#distatnce to the player
	var dis = distance_to_player()




	if dis < 30:
		label.text = "$" + str(get_upgrade_cost())
		if Input.is_action_pressed("interact"):
			action()
	elif distance_to_player() < 100:
		label.visible = true
		label.text = "'E'"
	else:
		label.visible = false


func action():
	if distance_to_player() > DISTANCE_TO_UPGRADE:
		return

	if not player.upgrade_manager.spend_loot(get_upgrade_cost()):
		return

	var scene = load(upgrade_scene)
	var upgrade_scene_instance = scene.instantiate()
	upgrade_scene_instance.player = player

	if uses == 0:
		upgrade_scene_instance.upgrade_boost = 2

	uses += 1

	if spawn_manager != null:
		upgrade_scene_instance.increase_difficulty.connect(spawn_manager.increase_difficulty)






	get_tree().get_root().add_child(upgrade_scene_instance)
	#pause the game
	get_tree().paused = true






func get_player():
	var _player = get_tree().get_root().get_child(0).get_node_or_null("Hero")
	player = _player

func distance_to_player():
	if player == null:
		return 0

	return self.global_position.distance_to(player.global_position)

func select_animation():
	if powered:
		sprite.play("on")
	else:
		sprite.play("off")

func get_upgrade_cost():
	var cost =  upgrade_cost * uses
	return min(cost, 1000)








