extends StaticBody2D


@export var player :Player = null
@export var powered : bool = false

@onready var label :Label = $Label
@onready var sprite :AnimatedSprite2D = $AnimatedSprite2D

const upgrade_scene = "res://scenes/UI/upgrade_screen.tscn"
# var upgrade_screen :PackedScene = preload(upgrade_scene)


var upgrade_cost = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	select_animation()
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



	if dis < 10:
		label.text = "$" + str(upgrade_cost)

		if Input.is_action_pressed("interact"):
			#try to spend the loot
			if not player.upgrade_manager.spend_loot(upgrade_cost):
				return
			var scene = load(upgrade_scene)
			var upgrade_scene_instance = scene.instantiate()
			upgrade_scene_instance.player = player
			get_tree().get_root().add_child(upgrade_scene_instance)
			#pause the game
			get_tree().paused = true

			




	
	elif distance_to_player() < 100:
		label.visible = true
		label.text = "'E'"
	else:
		label.visible = false





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

