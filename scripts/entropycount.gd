extends Node2D

@onready var entropy_label = $entropycount
func format_number(n: float) -> String:
	if n < 1000:
		return str(n)
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var tier = int(floor(log(n) / log(1000)))
	if tier >= suffixes.size():
		tier = suffixes.size() - 1
	var scaled = n / pow(1000, tier)
	var text = str(round(scaled * 10) / 10.0)
	if text.ends_with(".0"):
		text = text.trim_suffix(".0")
	return text + suffixes[tier]

func _on_main_entropy_changed(amount) -> void:
	entropy_label.text = format_number(amount)
