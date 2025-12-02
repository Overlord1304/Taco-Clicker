extends Control

const saves =  "user://userdata.save"
var entropy = 0
var tacos = 0
var base_amount_per_click = 1
var amount_per_click = 1
var base_passive_gains = 0
var passive_gains = 0
var base_entropy_gains = 1
var entropy_gains = 1
var upg1cost:int = 35
var upg2cost:int = 100
var upg3cost:int = 750
var upg4cost:int = 1500
var upg5cost:int = 3000
var upg6cost:int = 10000
var upg7cost:int = 100000
var golden_taco_bought = false
var golden_taco_activated = false
var disco_sauce_bought = false
var disco_sauce_activated = false
var TACO_bought = false
var TACO_click_multiplier = 1.0
var TACO_gains_multiplier = 1.0
var TACO_entropy_multiplier = 1.0
var gtaco_multiplier = 5.0
var gtaco_texture = preload("res://sprites/gtaco.png")
var taco_texture = preload("res://sprites/taco.png")
@onready var gtaco_timer = $gtacotimer
@onready var dsauce_timer = $dsaucetimer
signal tacos_changed
signal taco_clicked
signal entropy_changed

func _ready():
	load_data()
	emit_signal("tacos_changed", tacos)
	emit_signal("entropy_changed",entropy)
	$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = str(upg2cost)+" Tacos"
	$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
	$left/entropy/entropypersecondcount.text = str(entropy_gains)+" PER SECOND"
	$"scroller/VBoxContainer/right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
	$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = str(upg4cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = str(upg5cost)+" Tacos"
	$scroller/VBoxContainer/right/disco_sauce/disco_sauce_label.text = str(upg6cost)+" Tacos"
	$scroller/VBoxContainer/right/T_A_C_O_BUTTON/T_A_C_O_LABEL.text = str(upg7cost)+" Tacos"
	$T_A_C_O/amountsperclickslider.value = TACO_click_multiplier
	$T_A_C_O/passivegainsperclickslider.value = TACO_gains_multiplier
	_on_h_slider_value_changed(TACO_click_multiplier)
	_on_passivegainsperclickslider_value_changed(TACO_gains_multiplier)

func update_amount_per_click() -> void:
	var click_mult = TACO_click_multiplier
	if golden_taco_activated:
		click_mult *= gtaco_multiplier
	amount_per_click = base_amount_per_click * click_mult
func update_passive_gains() -> void:
	var gains_mult = TACO_gains_multiplier
	if disco_sauce_activated:
		gains_mult *= 50
	passive_gains = base_passive_gains * gains_mult
	$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains) + " PER SECOND"
func _on_tacobutton_button_down() -> void:
	tacos += amount_per_click
	emit_signal("tacos_changed",tacos)
	emit_signal("taco_clicked",amount_per_click)
	save_data()

func _process(delta):
	if golden_taco_bought == true:
		$"scroller/VBoxContainer/right/golden taco".disabled = true
	if disco_sauce_bought == true:
		$scroller/VBoxContainer/right/disco_sauce.disabled = true
	if TACO_bought == true:
		$scroller/VBoxContainer/right/T_A_C_O_BUTTON.disabled = true
	if golden_taco_bought and golden_taco_activated == false:
		var rand = randi() % 3000
		match rand:
			!2999:
				pass
			2999:
				$left/MarginContainer/tacobutton.texture_normal = gtaco_texture
				golden_taco_activated = true
			
				update_amount_per_click()
				gtaco_timer.start(10.0)
	if disco_sauce_bought and disco_sauce_activated == false:
		var rand = randi() % 3000
		match rand:
			!2999:
				pass
			2999:
				disco_sauce_activated = true
				update_passive_gains()
				$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
				$AnimationPlayer.play("disco_anim")
				dsauce_timer.start(10.0)
	if TACO_bought:
		$T_A_C_O.z_index = 1

func save_data():
	var data = {
		"tacos" : tacos,
		"base_amount_per_click": base_amount_per_click,
		"base_passive_gains" : base_passive_gains,
		"upg1cost" : upg1cost,
		"upg2cost" : upg2cost,
		"upg3cost" : upg3cost,
		"golden_taco_bought": golden_taco_bought,
		"upg4cost" : upg4cost,
		"upg5cost" : upg5cost,
		"upg6cost" : upg6cost,
		"disco_sauce_bought" : disco_sauce_bought,
		"upg7cost" : upg7cost,
		"TACO_bought" : TACO_bought,
		"TACO_click_multiplier": TACO_click_multiplier,
		"TACO_gains_multiplier": TACO_gains_multiplier
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
			base_passive_gains = data.get("base_passive_gains",0)
			passive_gains = base_passive_gains
			upg1cost = data.get("upg1cost",35)
			upg2cost = data.get("upg2cost",100)
			upg3cost = data.get("upg3cost",750)
			upg4cost = data.get("upg4cost",1500)
			upg5cost = data.get("upg5cost",3000)
			upg6cost = data.get("upg6cost",10000)
			upg7cost = data.get("upg7cost",100000)
			golden_taco_bought = data.get("golden_taco_bought",false)
			disco_sauce_bought = data.get("disco_sauce_bought",false)
			TACO_bought = data.get("TACO_bought",false)
			TACO_click_multiplier = data.get("TACO_click_multiplier",1.0)
			TACO_gains_multiplier = data.get("TACO_gains_multiplier",1.0)
			update_amount_per_click()
			update_passive_gains()
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= upg1cost:
		base_amount_per_click += 1
		update_amount_per_click()
		tacos -= upg1cost
		upg1cost *= 1.25
		$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = str(upg1cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_autoclickupg_1_button_down() -> void:
	if tacos >= upg2cost:
		base_passive_gains += 1
		if disco_sauce_activated:
			passive_gains = base_passive_gains * 50
		else:
			passive_gains = base_passive_gains
		$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
		tacos -= upg2cost
		upg2cost *= 1.25
		$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = str(upg2cost)+" Tacos"
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
		$"scroller/VBoxContainer/right/golden taco/golden taco label".text = str(upg3cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_gtacotimer_timeout() -> void:
	golden_taco_activated = false
	update_amount_per_click()
	$left/MarginContainer/tacobutton.texture_normal = taco_texture

func _on_amtperclickupg_2_button_down() -> void:
	if tacos >= upg4cost:
		base_amount_per_click += 10
		update_amount_per_click()
		tacos -= upg4cost
		upg4cost *= 1.25
		$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = str(upg4cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_autoclickupg_2_button_down() -> void:
	if tacos >= upg5cost:
		base_passive_gains += 10
		if disco_sauce_activated:
			passive_gains = base_passive_gains * 50
		else:
			passive_gains = base_passive_gains
		$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
		tacos -= upg5cost
		upg5cost *= 1.25
		$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = str(upg5cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_disco_sauce_button_down() -> void:
	if tacos >= upg6cost and disco_sauce_bought == false:
		disco_sauce_bought = true
		tacos -= upg6cost
		$scroller/VBoxContainer/right/disco_sauce/disco_sauce_label.text = str(upg6cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_dsaucetimer_timeout() -> void:
	disco_sauce_activated = false
	update_passive_gains()
	$left/MarginContainer/VBoxContainer/persecondcount.text = str(passive_gains)+" PER SECOND"
	$AnimationPlayer.play("reset")

func _on_t_a_c_o_button_button_down() -> void:
	if tacos >= upg7cost and TACO_bought == false:
		TACO_bought = true
		tacos -= upg7cost
		$scroller/VBoxContainer/right/T_A_C_O_BUTTON/T_A_C_O_LABEL.text = str(upg7cost)+" Tacos"
		$T_A_C_O/amountsperclickslider.value = 1.0
		$T_A_C_O/passivegainsperclickslider.value = 1.0
		_on_h_slider_value_changed(1.0)
		_on_passivegainsperclickslider_value_changed(1.0)
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_h_slider_value_changed(value: float) -> void:
	TACO_click_multiplier = value
	$T_A_C_O/click_multiplier_label.text = str(value) + "x"
	update_amount_per_click()

func _on_passivegainsperclickslider_value_changed(value: float) -> void:
	TACO_gains_multiplier = value
	$T_A_C_O/passivegains_multiplier_label.text = str(value) + "x"
	update_passive_gains()
