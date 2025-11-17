extends MarginContainer
@onready var taco = $tacobutton
@onready var indicator_display = $"../../indicators/display"
@onready var indicators = $"../../indicators"
func _ready() -> void:
	taco.pivot_offset = taco.size / 2

func _on_tacobutton_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(taco, "scale", Vector2(.9,.9), .1)


func _on_tacobutton_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(taco, "scale", Vector2(1,1), .1)


func _on_main_taco_clicked(amount) -> void:
	var indicator = indicator_display.duplicate()
	indicator.text = "+" + str(amount)
	indicator.position = get_global_mouse_position()
	indicator.visible = true
	indicators.add_child(indicator)
	indicator.get_child(0).start()
	
