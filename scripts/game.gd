extends Control

const saves =  "user://userdata.save"
var tacos = 0
var amount_per_click = 1
var passive_gains = 0

signal tacos_changed
signal taco_clicked
func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
	
func _process(_delta):
	await get_tree().create_timer(1.0).timeout
	tacos += passive_gains
	save_data()
func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
	emit_signal("taco_clicked",amount_per_click)
	save_data()

func save_data():
	var data = {
		"tacos" : tacos,
		"amount_per_click": amount_per_click,
		"passive_gains" : passive_gains
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
			amount_per_click = data.get("amount_per_click",1)
			passive_gains = data.get("passive_gains",0)
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= 35: 
		amount_per_click += 1
		tacos -= 35
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_autoclickupg_1_button_down() -> void:
	if tacos >= 100: 
		passive_gains += 1
		tacos -= 100
		emit_signal("tacos_changed",tacos)
		save_data() 
