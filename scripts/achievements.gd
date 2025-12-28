extends Control
@onready var a1 = $Panel/A1
signal a1_reward
func _ready():
	if not Global.a1_claimed:
		a1.disabled = not Global.upg1_achievement_unlocked
		
	else:
		a1.disabled = true
	
func _on_back_button_up() -> void:
	var transition = preload("res://scenes/swipe.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.swipe_to("res://scenes/main.tscn", -1)

func _on_a_1_button_up() -> void:
	if not Global.a1_claimed:
		Global.pending_taco_reward += 1000000
		Global.a1_claimed = true
		a1.disabled = true
