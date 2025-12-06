extends Control

const saves =  "user://userdata.save"
var entropy = 0
var entropy_consumption_click = 0
var entropy_consumption_passive = 0
var entropy_consumption_slider = 0
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
var upg8cost:int = 25000
var upg9cost:int = 500000
var upg10cost:int = 500000
var upg11cost:int = 1000000
var upg12cost:int = 2000000
var upg13cost:int = 10000000
var golden_taco_bought = false
var golden_taco_activated = false
var disco_sauce_bought = false
var disco_sauce_activated = false
var cosmic_overflow_bought = false
var cosmic_overflow_activated = false
var overclock_bought = false
var overclock_activated = false
var TACO_bought = false
var TACO_click_multiplier = 1.0
var TACO_gains_multiplier = 1.0
var TACO_entropy_multiplier = 1.0
var gtaco_texture = preload("res://sprites/gtaco.png")
var taco_texture = preload("res://sprites/taco.png")
@onready var gtaco_timer = $gtacotimer
@onready var dsauce_timer = $dsaucetimer
@onready var coverflow_timer = $coverflowtimer
@onready var overclock_timer = $overclocktimer
@onready var base_apc_max_value = $T_A_C_O/amountsperclickslider.max_value
@onready var base_cps_max_value = $T_A_C_O/passivegainsperclickslider.max_value
@onready var base_entropy_max_value = $T_A_C_O/entropymultiplierperclickslider.max_value
var coverflow_original_position = {}
signal tacos_changed
signal taco_clicked
signal entropy_changed

func _ready():
	load_data()
	for sprite in get_tree().get_nodes_in_group("coverflow"):
		sprite.play()
		coverflow_original_position[sprite] = sprite.position
	if not TACO_bought:
		$T_A_C_O.visible = false
		$left/entropy.visible = false
	else:
		$T_A_C_O.visible = true
		$left/entropy.visible = true
	emit_signal("tacos_changed", tacos)
	emit_signal("entropy_changed",entropy)
	$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = format_number(upg1cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = format_number(upg2cost)+" Tacos"
	$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
	$"scroller/VBoxContainer/right/golden taco/golden taco label".text = format_number(upg3cost)+" Tacos"
	$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = format_number(upg4cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = format_number(upg5cost)+" Tacos"
	$scroller/VBoxContainer/right/disco_sauce/disco_sauce_label.text = format_number(upg6cost)+" Tacos"
	$scroller/VBoxContainer/right/T_A_C_O_BUTTON/T_A_C_O_LABEL.text = format_number(upg7cost)+" Tacos"
	$scroller/VBoxContainer/right/entropyupg1button/entropyupg1label.text = format_number(upg8cost)+" Tacos"
	$scroller/VBoxContainer/right/entropyupg2button2/entropyupg2label.text = format_number(upg9cost)+" Tacos"
	$scroller/VBoxContainer/right/amtperclickupg3/amountperclickupgrade3label.text = format_number(upg10cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg3/autoclickupgsprite3.text = format_number(upg11cost)+" Tacos"
	$scroller/VBoxContainer/right/cosmic_overflow/cosmic_overflow_label.text = format_number(upg12cost)+" Tacos"
	$scroller/VBoxContainer/right/TACO_overclock/TACO_overclock_label.text = format_number(upg13cost)+" Tacos"
	$T_A_C_O/amountsperclickslider.value = TACO_click_multiplier
	$T_A_C_O/passivegainsperclickslider.value = TACO_gains_multiplier
	$T_A_C_O/entropymultiplierperclickslider.value = TACO_entropy_multiplier
	_on_h_slider_value_changed(TACO_click_multiplier)
	_on_passivegainsperclickslider_value_changed(TACO_gains_multiplier)
	_on_entropymultiplierperclickslider_value_changed(TACO_entropy_multiplier)
func format_number(n: float) -> String:
	if n < 1000:
		return str(n)
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var tier = int(floor(log(n) / log(1000)))
	if tier >= suffixes.size():
		tier = suffixes.size() - 1
	var scaled = n / pow(1000, tier)
	var text = str(round(scaled * 10) / 10.0)
	if text.ends_with(".0"):
		text = text.trim_suffix(".0")
	return text + suffixes[tier]
func update_amount_per_click() -> void:
	var click_mult = TACO_click_multiplier
	if golden_taco_activated:
		click_mult *= 5
	amount_per_click = base_amount_per_click * click_mult
func update_passive_gains() -> void:
	var gains_mult = TACO_gains_multiplier
	if disco_sauce_activated:
		gains_mult *= 50
	passive_gains = base_passive_gains * gains_mult
	$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains) + " PER SECOND"
func update_entropy_gains():
	var entropy_mult = TACO_entropy_multiplier
	if cosmic_overflow_activated:
		entropy_mult *= 50
	entropy_gains = base_entropy_gains * entropy_mult
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains) + " PER SECOND"
func update_taco_sliders():
	if overclock_activated:
		$T_A_C_O/amountsperclickslider.max_value = base_apc_max_value*10
		$T_A_C_O/passivegainsperclickslider.max_value = base_apc_max_value*10
		$T_A_C_O/entropymultiplierperclickslider.max_value = base_entropy_max_value*10
	else:
		$T_A_C_O/entropymultiplierperclickslider.max_value = base_entropy_max_value
		$T_A_C_O/passivegainsperclickslider.max_value = base_apc_max_value
		$T_A_C_O/amountsperclickslider.max_value = base_apc_max_value
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
	if cosmic_overflow_bought == true:
		$scroller/VBoxContainer/right/cosmic_overflow.disabled = true
	if overclock_bought == true:
		$scroller/VBoxContainer/right/TACO_overclock.disabled = true
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
				$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
				$AnimationPlayer.play("disco_anim")
				dsauce_timer.start(10.0)
	if cosmic_overflow_bought and cosmic_overflow_activated == false:
		var rand = randi() % 3000
		match rand:
			!2999:
				pass
			2999:
				cosmic_overflow_activated = true
				update_entropy_gains()
				$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
				coverflow_timer.start(10.0)
				for sprite in get_tree().get_nodes_in_group("coverflow"):
					var tween = create_tween()
					tween.tween_property(sprite, "position:y", sprite.position.y - 150, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if overclock_bought and overclock_activated == false:
		var rand = randi() % 1000
		print(rand)
		match rand:
			!999:
				pass
			999:
				overclock_activated = true
				update_taco_sliders()
				$AnimationPlayer.play("overclock_anim")
				overclock_timer.start(10.0)

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
		"upg8cost" : upg8cost,
		"upg9cost" : upg9cost,
		"upg10cost" : upg10cost,
		"upg11cost" : upg11cost,
		"upg12cost" : upg12cost,
		"cosmic_overflow_bought" : cosmic_overflow_bought,
		"upg13cost" : upg13cost,
		"overclock_bought": overclock_bought,
		"TACO_bought" : TACO_bought,
		"entropy": entropy,
		"base_entropy_gains" : base_entropy_gains,
		"entropy_gains": entropy_gains,
		"TACO_click_multiplier": TACO_click_multiplier,
		"TACO_gains_multiplier": TACO_gains_multiplier,
		"TACO_entropy_multiplier": TACO_entropy_multiplier
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
			upg8cost = data.get("upg8cost",25000)
			upg9cost = data.get("upg9cost",500000)
			upg10cost = data.get("upg10cost",500000)
			upg11cost = data.get("upg11cost",1000000)
			upg12cost = data.get("upg12cost",2000000)
			upg13cost = data.get("upg13cost",10000000)
			golden_taco_bought = data.get("golden_taco_bought",false)
			disco_sauce_bought = data.get("disco_sauce_bought",false)
			cosmic_overflow_bought = data.get("cosmic_overflow_bought",false)
			overclock_bought = data.get("overclock_bought",false)
			TACO_bought = data.get("TACO_bought",false)
			entropy = data.get("entropy", 0)
			base_entropy_gains = data.get("base_entropy_gains", 1)
			entropy_gains = data.get("entropy_gains",1)
			entropy_gains = base_entropy_gains
			TACO_click_multiplier = data.get("TACO_click_multiplier",1.0)
			TACO_gains_multiplier = data.get("TACO_gains_multiplier",1.0)
			TACO_entropy_multiplier = data.get("TACO_entropy_multiplier", 1.0)
			update_amount_per_click()
			update_passive_gains()
			update_entropy_gains()
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= upg1cost:
		base_amount_per_click += 1
		update_amount_per_click()
		tacos -= upg1cost
		upg1cost *= 1.25
		$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = format_number(upg1cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_autoclickupg_1_button_down() -> void:
	if tacos >= upg2cost:
		base_passive_gains += 1
		if disco_sauce_activated:
			passive_gains = base_passive_gains * 50
		else:
			passive_gains = base_passive_gains
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg2cost
		upg2cost *= 1.25
		$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = format_number(upg2cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_timer_timeout() -> void:
	
	entropy += entropy_gains

	
	if TACO_click_multiplier > 1.0:
		var cost = cost_click_mult(TACO_click_multiplier)
		if entropy >= cost:
			entropy -= cost
		else:
			
			var new_val = get_affordable_value(TACO_click_multiplier, func(v): return cost_click_mult(v), entropy)
			$T_A_C_O/amountsperclickslider.value = new_val
			_on_h_slider_value_changed(new_val)

	
	if TACO_gains_multiplier > 1.0:
		var cost = cost_passive_mult(TACO_gains_multiplier)
		if entropy >= cost:
			entropy -= cost
		else:
			var new_val = get_affordable_value(TACO_gains_multiplier, func(v): return cost_passive_mult(v), entropy)
			$T_A_C_O/passivegainsperclickslider.value = new_val
			_on_passivegainsperclickslider_value_changed(new_val)

	
	if TACO_entropy_multiplier > 1.0:
		var cost = cost_entropy_boost(TACO_entropy_multiplier)
		if tacos >= cost:
			tacos -= cost
		else:
			var new_val = get_affordable_value(TACO_entropy_multiplier, func(v): return cost_entropy_boost(v), tacos)
			$T_A_C_O/entropymultiplierperclickslider.value = new_val
			_on_entropymultiplierperclickslider_value_changed(new_val)

	
	tacos += passive_gains

	emit_signal("tacos_changed", tacos)
	emit_signal("entropy_changed", entropy)
	save_data()

func _on_golden_taco_button_down() -> void:
	if tacos >= upg3cost and golden_taco_bought == false:
		golden_taco_bought = true
		tacos -= upg3cost
		$"scroller/VBoxContainer/right/golden taco/golden taco label".text = format_number(upg3cost)+" Tacos"
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
		$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = format_number(upg4cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_autoclickupg_2_button_down() -> void:
	if tacos >= upg5cost:
		base_passive_gains += 10
		if disco_sauce_activated:
			passive_gains = base_passive_gains * 50
		else:
			passive_gains = base_passive_gains
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg5cost
		upg5cost *= 1.25
		$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = format_number(upg5cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_disco_sauce_button_down() -> void:
	if tacos >= upg6cost and disco_sauce_bought == false:
		disco_sauce_bought = true
		tacos -= upg6cost
		$scroller/VBoxContainer/right/disco_sauce/disco_sauce_label.text = format_number(upg6cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()

func _on_dsaucetimer_timeout() -> void:
	disco_sauce_activated = false
	update_passive_gains()
	$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
	$AnimationPlayer.play("reset")

func _on_t_a_c_o_button_button_down() -> void:
	if tacos >= upg7cost and TACO_bought == false:
		TACO_bought = true
		$T_A_C_O.visible = true
		$left/entropy.visible = true
		tacos -= upg7cost
		$scroller/VBoxContainer/right/T_A_C_O_BUTTON/T_A_C_O_LABEL.text = format_number(upg7cost)+" Tacos"
		$T_A_C_O/amountsperclickslider.value = 1.0
		$T_A_C_O/passivegainsperclickslider.value = 1.0
		_on_h_slider_value_changed(1.0)
		_on_passivegainsperclickslider_value_changed(1.0)
		emit_signal("tacos_changed",tacos)
		save_data()
func get_affordable_value(current_value: float, cost_func: Callable, resource_amount: float) -> float:
	var test = current_value
	if test <= 1.0:
		return current_value
	
	while test > 1.0:
		if cost_func.call(test) <= resource_amount:
			return test
		test -= 0.5
		test = round(test*10) / 10
	return 1.0
func cost_click_mult(value: float) -> float:
	return (value - 1.0) * 25  

func cost_passive_mult(value: float) -> float:
	return (value - 1.0) * 20 

func cost_entropy_boost(value: float) -> float:
	return ((value - 1.0) * 50)*base_entropy_gains  
func _on_h_slider_value_changed(value: float) -> void:
	var affordable = get_affordable_value(
		value,
		func(v): return cost_click_mult(v),
		entropy
	)
	if affordable != value:
		$T_A_C_O/amountsperclickslider.value = affordable
		value = affordable
	TACO_click_multiplier = value
	$T_A_C_O/click_multiplier_label.text = format_number(value) + "x"
	update_amount_per_click()

func _on_passivegainsperclickslider_value_changed(value: float) -> void:
	var affordable = get_affordable_value(
		value,
		func(v): return cost_passive_mult(v),
		entropy
	)

	if affordable != value:
		$T_A_C_O/passivegainsperclickslider.value = affordable
		value = affordable

	TACO_gains_multiplier = value
	$T_A_C_O/passivegains_multiplier_label.text = format_number(value) + "x"

	update_passive_gains()
	
func _on_entropymultiplierperclickslider_value_changed(value: float) -> void:
	var affordable = get_affordable_value(
		value,
		func(v): return cost_entropy_boost(v),
		tacos
	)

	if affordable != value:
		$T_A_C_O/entropymultiplierperclickslider.value = affordable
		value = affordable

	TACO_entropy_multiplier = value
	update_entropy_gains()
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains) + " PER SECOND"
	$T_A_C_O/entropy_multiplier_label.text = format_number(value) + "x"


func _on_entropyupg_1_button_button_down() -> void:
	if tacos >= upg8cost:
		base_entropy_gains += 1
		if cosmic_overflow_activated:
			entropy_gains = base_entropy_gains * 50
		else:
			update_entropy_gains()
		$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
		tacos -= upg8cost
		upg8cost *= 1.25
		$scroller/VBoxContainer/right/entropyupg1button/entropyupg1label.text = format_number(upg8cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_entropyupg_2_button_2_button_down() -> void:
	if tacos >= upg9cost:
		base_entropy_gains += 10
		if cosmic_overflow_activated:
			entropy_gains = base_entropy_gains * 50
		else:
			update_entropy_gains()
		$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
		tacos -= upg9cost
		upg9cost *= 1.25
		$scroller/VBoxContainer/right/entropyupg2button2/entropyupg2label.text = format_number(upg9cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_amtperclickupg_3_button_down() -> void:
	if tacos >= upg10cost:
		base_amount_per_click += 100
		update_amount_per_click()
		tacos -= upg10cost
		upg10cost *= 1.25
		$scroller/VBoxContainer/right/amtperclickupg3/amountperclickupgrade3label.text = format_number(upg10cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_autoclickupg_3_button_down() -> void:
	if tacos >= upg11cost:
		base_passive_gains += 100
		if disco_sauce_activated:
			passive_gains = base_passive_gains * 50
		else:
			passive_gains = base_passive_gains
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg11cost
		upg11cost *= 1.25
		$scroller/VBoxContainer/right/autoclickupg3/autoclickupgsprite3.text = format_number(upg11cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_cosmic_overflow_button_down() -> void:
	if tacos >= upg12cost and cosmic_overflow_bought == false:
		cosmic_overflow_bought = true
		tacos -= upg12cost
		$scroller/VBoxContainer/right/cosmic_overflow/cosmic_overflow_label.text = format_number(upg12cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_coverflowtimer_timeout() -> void:
	cosmic_overflow_activated = false
	update_entropy_gains()
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
	for sprite in get_tree().get_nodes_in_group("coverflow"):
		var tween = create_tween()
		tween.tween_property(sprite, "position", coverflow_original_position[sprite], 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_taco_overclock_button_down() -> void:
	if tacos >= upg13cost and overclock_bought == false:
		overclock_bought = true
		tacos -= upg13cost
		$scroller/VBoxContainer/right/TACO_overclock/TACO_overclock_label.text = format_number(upg13cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()


func _on_overclocktimer_timeout() -> void:
	overclock_activated = false
	update_taco_sliders()
	$AnimationPlayer.play("reset")
	
