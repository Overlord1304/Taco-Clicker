extends Control

var tacos = 0
var amount_per_click = 1

signal tacos_changed

func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
