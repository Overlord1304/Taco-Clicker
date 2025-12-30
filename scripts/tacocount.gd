extends VBoxContainer
@onready var entropy_label = $"../../entropy/entropycount"
@onready var taco_label = $tacocount
func format_number(n) -> String:
	if n < 1000:
		return str(int(n))  
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var tier = int(floor(log(n) / log(1000)))
	if tier >= suffixes.size():
		tier = suffixes.size() - 1
	var scaled = n / pow(1000, tier)
	var rounded = round(scaled * 10) / 10.0
	var text = str(rounded if rounded != int(rounded) else int(rounded))
	return text + suffixes[tier]
func _on_main_tacos_changed(amount) -> void:
	taco_label.text =  format_number(amount) + " Tacos"
func _on_main_entropy_changed(amount) -> void:
	entropy_label.text = format_number(amount)
func _on_main_key_to_tree_changed(amount):
	if amount == 1:
		$"../../skilltreebutton".show()
