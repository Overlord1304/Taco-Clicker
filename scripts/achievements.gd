extends Control

@onready var achievement_buttons := [
	$scroll/hbox/Panel/A1,
	$scroll/hbox/Panel/A2,
	$scroll/hbox/Panel/A3,
	$scroll/hbox/Panel/A4,
	$scroll/hbox/Panel/A5,
	$scroll/hbox/Panel/A6,
	$scroll/hbox/Panel/A7,
	$scroll/hbox/Panel/A8
]

const REWARDS := [
	{ "type": "tacos", "amount": 750 },
	{ "type": "tacos", "amount": 2000 },
	{ "type": "tacos", "amount": 20000 },
	{ "type": "tacos", "amount": 50000 },
	{ "type": "tacos", "amount": 100000 },
	{ "type": "tacos", "amount": 200000 },
	{ "type": "entropy", "amount": 5000 },
	{ "type": "entropy", "amount": 5000 }
]

func _ready():
	for i in achievement_buttons.size():
		update_button_state(i)

func update_button_state(index: int):
	var claimed = Global.get("a%d_claimed" % (index + 1))
	var unlocked = Global.get("a%d_unlocked" % (index + 1))
	achievement_buttons[index].disabled = claimed or not unlocked

func claim_reward(index: int):
	var claim_no = "a%d_claimed" % (index + 1)
	if Global.get(claim_no):
		return

	var game = get_tree().get_first_node_in_group("game")
	if not game:
		return

	var reward = REWARDS[index]

	game.set(
		reward.type,
		game.get(reward.type) + reward.amount
	)
	
	game.emit_signal("%s_changed" % reward.type, game.get(reward.type))
	game.save_data()
	
	Global.set(claim_no, true)
	achievement_buttons[index].disabled = true
	var coverlay = achievement_buttons[index].get_node_or_null("ClaimOverlay")
	coverlay.show()


func _on_back_button_up():
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)

func _on_a_1_button_up(): claim_reward(0)
func _on_a_2_button_up(): claim_reward(1)
func _on_a_3_button_up(): claim_reward(2)
func _on_a_4_button_up(): claim_reward(3)
func _on_a_5_button_up(): claim_reward(4)
func _on_a_6_button_up(): claim_reward(5)
func _on_a_7_button_up(): claim_reward(6)
func _on_a_8_button_up(): claim_reward(7)
