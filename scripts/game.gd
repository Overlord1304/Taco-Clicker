extends Control

const saves =  "user://userdata.save"
var tacos = 0
var amount_per_click = 1
var passive_gains = 0
var upg1cost:int = 35
var upg2cost:int = 100
var upg3cost: int = 750
var golden_taco_bought = false
var golden_taco_activated = false
signal tacos_changed
signal taco_clicked
func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
	$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
	$right/autoclickupg1/autoclickupgsprite1.text = str(upg2cost)+" Tacos"
	$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
	$"right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
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
		"upg2cost" : upg2cost,
		"upg3cost" : upg3cost,
		"gtacodisabled" : $"right/golden taco".disabled,
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
		amount_per_click += 1
		tacos -= upg1cost
		upg1cost *= 1.25
		$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_autoclickupg_1_button_down() -> void:
	if tacos >= upg2cost: 
		$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
		passive_gains += 1
		tacos -= upg2cost
		upg2cost *= 1.25
		$right/autoclickupg2/autoclickupgsprite2.text = str(upg2cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_timer_timeout() -> void:
	emit_signal("tacos_changed",tacos)
	tacos += passive_gains
	save_data()


func _on_golden_taco_button_down() -> void:
	if tacos >= upg3cost: 
		golden_taco_bought = true
		tacos -= upg3cost
		$"right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 
		$"right/golden taco".disabled = true
