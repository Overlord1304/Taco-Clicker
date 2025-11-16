extends VBoxContainer

@onready var taco_label = $tacocount

func _on_main_tacos_changed(amount) -> void:
	taco_label.text =  str(amount) + " Tacos"
