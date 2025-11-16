extends Control

const saves =  "user://userdata.save"
var tacos = 0
var amount_per_click = 1

signal tacos_changed
func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
	save_data()

func save_data():
	var data = {
		"tacos" : tacos
	}
	var file = FileAccess.open(saves, FileAccess.WRITE)
	file.store_var(data)
	file.close()
	
func load_data():
	if FileAccess.file_exists(saves):
		var file = FileAccess.open(saves,FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			tacos = data.get("tacos",0)
	else:
		save_data()
