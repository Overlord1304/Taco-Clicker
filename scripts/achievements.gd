extends Control

@onready var achievement_buttons := [
	$scroll/hbox/Panel/A1,
	$scroll/hbox/Panel/A2,
	$scroll/hbox/Panel/A3,
	$scroll/hbox/Panel/A4,
	$scroll/hbox/Panel/A5,
	$scroll/hbox/Panel/A6,
	$scroll/hbox/Panel/A7,
	$scroll/hbox/Panel/A8,
	$scroll/hbox/Panel/A9,
	$scroll/hbox/Panel/A10,
	$scroll/hbox/Panel/A11,
	$scroll/hbox/Panel/A12,
	$scroll/hbox/Panel/A13,
	$scroll/hbox/Panel/A14,
	$scroll/hbox/Panel/A15,
	$scroll/hbox/Panel/A16,
	$scroll/hbox/Panel/A17,
	$scroll/hbox/Panel/A18,
]

const rewards := [
	{"type": "tacos", "amount": 750},
	{"type": "tacos", "amount": 2000},
	{"type": "tacos", "amount": 20000},
	{"type": "tacos", "amount": 50000},
	{"type": "tacos", "amount": 100000},
	{"type": "tacos", "amount": 200000},
	{"type": "entropy", "amount": 5000},
	{"type": "entropy", "amount": 50000},
	{"type": "tacos", "amount": 15000000},
	{"type": "tacos", "amount": 30000000},
	{"type": "entropy", "amount": 500000},
	{"type": "entropy", "amount": 500000},
	{"type": "tacos", "amount": 30000000},
	{"type": "tacos", "amount": 15000000},
	{"type": "tacos", "amount": 5000000},
	{"type": "tacos", "amount": 30000000},
	{"type": "tacos", "amount": 100000000},
	{"type": "key_to_tree","amount": 1}
]

func _ready():
	for i in achievement_buttons.size():
		update_button_state(i)

func update_button_state(index: int):
	var claimed = Global.get("a%d_claimed" % (index + 1))
	var unlocked = Global.get("a%d_unlocked" % (index + 1))
	var achievement_button = achievement_buttons[index]
	achievement_button.disabled = claimed or not unlocked
	var coverlay = achievement_button.get_node_or_null("ClaimOverlay")
	coverlay.visible = claimed
func claim_reward(index: int):
	var claim_no = "a%d_claimed" % (index + 1)
	if Global.get(claim_no):
		return

	var game = get_tree().get_first_node_in_group("game")
	if not game:
		return

	var reward = rewards[index]

	game.set(reward.type,game.get(reward.type) + reward.amount)
	
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

func _on_a_9_button_up(): claim_reward(8)


func _on_a_10_button_up(): claim_reward(9)
func _on_a_11_button_up(): claim_reward(10)


func _on_a_12_button_up(): claim_reward(11)

func _on_a_13_button_up(): claim_reward(12)

func _on_a_14_button_up(): claim_reward(13)
func _on_a_15_button_up(): claim_reward(14)


func _on_a_16_button_up(): claim_reward(15)


func _on_a_17_button_up(): claim_reward(16)


func _on_a_18_button_up(): claim_reward(17)
