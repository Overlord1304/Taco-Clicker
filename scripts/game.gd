extends Control

const saves =  "user://userdata.save"
var tacos = 0
var amount_per_click = 1
var passive_gains = 0
var upg1cost:int = 35
var upg2cost:int = 100
signal tacos_changed
signal taco_clicked
func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
	$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
	$right/autoclickupg2/autoclickupgsprite2.text = str(upg2cost)+" Tacos"

func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
	emit_signal("taco_clicked",amount_per_click)
	save_data()

func save_data():
	var data = {
		"tacos" : tacos,
		"amount_per_click": amount_per_click,
		"passive_gains" : passive_gains,
		"upg1cost" : upg1cost,
		"upg2cost" : upg2cost
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
			upg1cost = data.get("upg1cost",35)
			upg2cost = data.get("upg2cost",100)
			
			
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= upg1cost: 
		upg1cost *= 1.25
		$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
		amount_per_click += 1
		tacos -= 35
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_autoclickupg_1_button_down() -> void:
	if tacos >= 100: 
		upg2cost *= 1.25
		$right/autoclickupg2/autoclickupgsprite2.text = str(upg2cost)+" Tacos"
		passive_gains += 1
		tacos -= 100
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_timer_timeout() -> void:
	emit_signal("tacos_changed",tacos)
	tacos += passive_gains
	save_data()
