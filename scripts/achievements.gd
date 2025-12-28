extends Control
@onready var a1 = $Panel/A1
@onready var a2 = $Panel/A2
@onready var a3 = $Panel/A3
@onready var a4 = $Panel/A4
signal a1_reward
signal a2_reward
signal a3_reward
signal a4_reward
func _ready():
	if not Global.a1_claimed:
		a1.disabled = not Global.upg1_achievement_unlocked
	else:
		a1.disabled = true
	if not Global.a2_claimed:
		a2.disabled = not Global.upg2_achievement_unlocked
	else:
		a2.disabled = true
	if not Global.a3_claimed:
		a3.disabled = not Global.upg3_achievement_unlocked
	else:
		a3.disabled = true
	if not Global.a4_claimed:
		a4.disabled = not Global.upg4_achievement_unlocked
	else:
		a4.disabled = true
func _on_back_button_up() -> void:
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)

func _on_a_1_button_up() -> void:
	if not Global.a1_claimed:
		var game = get_tree().get_first_node_in_group("game")
		if game:
			game.tacos += 750
			game.emit_signal("tacos_changed", game.tacos)
			game.save_data()
		Global.a1_claimed = true
		a1.disabled = true


func _on_a_2_button_up() -> void:
	if not Global.a2_claimed:
		var game = get_tree().get_first_node_in_group("game")
		if game:
			game.tacos += 2000
			game.emit_signal("tacos_changed", game.tacos)
			game.save_data()
		Global.a2_claimed = true
		a2.disabled = true

func _on_a_3_button_up() -> void:
	if not Global.a3_claimed:
		var game = get_tree().get_first_node_in_group("game")
		if game:
			game.tacos += 20000
			game.emit_signal("tacos_changed", game.tacos)
			game.save_data()
		Global.a3_claimed = true
		a3.disabled = true

func _on_a_4_button_up() -> void:
	if not Global.a4_claimed:
		var game = get_tree().get_first_node_in_group("game")
		if game:
			game.tacos += 50000
			game.emit_signal("tacos_changed", game.tacos)
			game.save_data()
		Global.a4_claimed = true
		a4.disabled = true
