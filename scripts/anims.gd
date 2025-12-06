extends MarginContainer
@onready var taco = $tacobutton
@onready var indicator_display = $"../../indicators/display"
@onready var indicators = $"../../indicators"
func _ready() -> void:
	taco.pivot_offset = taco.size / 2
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
func _on_tacobutton_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(taco, "scale", Vector2(.9,.9), .1)


func _on_tacobutton_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(taco, "scale", Vector2(1,1), .1)


func _on_main_taco_clicked(amount) -> void:
	var indicator = indicator_display.duplicate()
	indicator.text = "+" + format_number(amount)
	indicator.position = get_global_mouse_position()
	indicator.visible = true
	indicators.add_child(indicator)
	indicator.get_child(0).start()
	
