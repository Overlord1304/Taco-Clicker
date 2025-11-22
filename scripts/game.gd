extends Control

const saves =  "user://userdata.save"
var tacos = 0
var base_amount_per_click = 1
var amount_per_click = 1
var passive_gains = 0
var upg1cost:int = 35
var upg2cost:int = 100
var upg3cost: int = 750
var golden_taco_bought = false
var golden_taco_activated = false
var gtaco_texture = preload("res://sprites/gtaco.png")
var taco_texture = preload("res://sprites/taco.png")
@onready var gtaco_timer = $gtacotimer
signal tacos_changed
signal taco_clicked
func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
	$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
	$right/autoclickupg1/autoclickupgsprite1.text = str(upg2cost)+" Tacos"
	$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
	$"right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
	if golden_taco_bought == true:
		$"right/golden taco".disabled = true
func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
	emit_signal("taco_clicked",amount_per_click)
	save_data()
func _process(float):
	if golden_taco_bought and golden_taco_activated == false:
		var rand = randi() % 2000
		print(rand)
		match rand:
			!1999:
				pass
			1999:
				print("hi")
				$left/MarginContainer/tacobutton.texture_normal = gtaco_texture
				golden_taco_activated = true
				amount_per_click = base_amount_per_click * 10
				gtaco_timer.start(10.0)
	print(golden_taco_bought)
func save_data():
	var data = {
		"tacos" : tacos,
		"base_amount_per_click": base_amount_per_click,
		"passive_gains" : passive_gains,
		"upg1cost" : upg1cost,
		"upg2cost" : upg2cost,
		"upg3cost" : upg3cost,
		"golden_taco_bought": golden_taco_bought
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
			base_amount_per_click = data.get("base_amount_per_click",1)
			amount_per_click = base_amount_per_click
			passive_gains = data.get("passive_gains",0)
			upg1cost = data.get("upg1cost",35)
			upg2cost = data.get("upg2cost",100)
			upg3cost = data.get("upg3cost",750)
			golden_taco_bought = data.get("golden_taco_bought")
			
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= upg1cost: 
		base_amount_per_click += 1
		amount_per_click = base_amount_per_click
		tacos -= upg1cost
		upg1cost *= 1.25
		$right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_autoclickupg_1_button_down() -> void:
	if tacos >= upg2cost: 
		passive_gains += 1
		$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"

		tacos -= upg2cost
		upg2cost *= 1.25
		$right/autoclickupg1/autoclickupgsprite1.text = str(upg2cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 


func _on_timer_timeout() -> void:
	emit_signal("tacos_changed",tacos)
	tacos += passive_gains
	save_data()


func _on_golden_taco_button_down() -> void:
	if tacos >= upg3cost and golden_taco_bought == false: 
		golden_taco_bought = true
		tacos -= upg3cost
		$"right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data() 



func _on_gtacotimer_timeout() -> void:
	golden_taco_activated = false
	amount_per_click = base_amount_per_click
	$left/MarginContainer/tacobutton.texture_normal = taco_texture
	
