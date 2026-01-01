extends Control

const saves =  "user://userdata.save"
var entropy = 999999999
var entropy_consumption_click = 0
var entropy_consumption_passive = 0
var entropy_consumption_slider = 0
var tacos = 9999999999
var base_amount_per_click = 1
var amount_per_click = 1
var base_passive_gains = 0
var passive_gains = 0
var base_entropy_gains = 1
var entropy_gains = 1
var upg1cost = 35.0
const upg1cost_base = 35.0
var upg2cost = 100.0
const upg2cost_base = 100.0
var upg3cost = 750.0
var upg4cost = 1500.0
const upg4cost_base = 1500.0
var upg5cost = 3000.0
const upg5cost_base = 3000.0
var upg6cost = 10000.0
var upg7cost = 100000.0
var upg8cost = 25000.0
const upg8cost_base = 25000.0
var upg9cost = 500000.0
const upg9cost_base = 500000.0
var upg10cost = 500000.0
const upg10cost_base = 500000.0
var upg11cost = 1000000.0
const upg11cost_base = 1000000.0
var upg12cost = 2000000.0
var upg13cost = 10000000.0
var upg14cost = 5000000.0
const upg14cost_base = 5000000.0
var upg15cost = 5000000.0
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
var active_notifications: Array = []
var notification_offset = 30
var base_notification_y = 0
var gtaco_texture = preload("res://sprites/gtaco.png")
var taco_texture = preload("res://sprites/taco.png")
var a1_bought_count = 0
var a2_bought_count = 0
var gtaco_activated_count = 0
var dsauce_activated_count = 0
var a5_bought_count = 0
var a6_bought_count = 0
var a7_bought_count = 0
var a8_bought_count = 0
var a9_bought_count = 0
var a10_bought_count = 0
var coverflow_activated_count = 0
var overclock_activated_count = 0
var a13_bought_count = 0
var a14_bought_count = 0
var a15_timer = 0
var a16_timer = 0
var a17_timer = 0
var key_to_tree = 0
var hyperdrive = false
var gtacomax = false
var dsaucemax = false
var coverflowmax = false
var gtacors = false
var dsaucers = false
var coverflowrs = false
var apccd = false
var cpscd = false
var epscd = false
var overclockmax = false
@onready var gtaco_timer = $gtacotimer
@onready var dsauce_timer = $dsaucetimer
@onready var coverflow_timer = $coverflowtimer
@onready var overclock_timer = $overclocktimer
@onready var base_apc_max_value = $T_A_C_O/amountsperclickslider.max_value
@onready var base_cps_max_value = $T_A_C_O/passivegainsperclickslider.max_value
@onready var base_entropy_max_value = $T_A_C_O/entropymultiplierperclickslider.max_value
@onready var gtacolabel = $left/MarginContainer/VBoxContainer/gtacoactivated
@onready var dsaucelabel = $left/MarginContainer/VBoxContainer/dsauceactivated
@onready var coverflowlabel = $left/MarginContainer/VBoxContainer/coverflowactivated
@onready var overclocklabel = $left/MarginContainer/VBoxContainer/overclockactivated
@onready var achievementlabel = $left/MarginContainer/VBoxContainer/achievementunlocked
var coverflow_original_position = {}
signal tacos_changed
signal taco_clicked
signal entropy_changed
signal key_to_tree_changed

func _ready():
	
	base_notification_y = gtacolabel.position.y
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
	$scroller/VBoxContainer/right/entropyupg3button3/entropyupg3label.text = format_number(upg14cost)+" Tacos"
	$scroller/VBoxContainer/right/tacoupg1button/tacoupg1label.text = format_number(upg15cost)+" Tacos"
	update_taco_sliders()
	$T_A_C_O/amountsperclickslider.value = TACO_click_multiplier
	$T_A_C_O/passivegainsperclickslider.value = TACO_gains_multiplier
	$T_A_C_O/entropymultiplierperclickslider.value = TACO_entropy_multiplier
	_on_h_slider_value_changed(TACO_click_multiplier)
	_on_passivegainsperclickslider_value_changed(TACO_gains_multiplier)
	_on_entropymultiplierperclickslider_value_changed(TACO_entropy_multiplier)
	if Global.a18_claimed:
		$left/skilltreebutton.show()
func format_number(n) -> String:
	
	if n < 1000:
		return str(int(round(n)))
	
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var tier = int(floor(log(n) / log(1000)))
	if tier >= suffixes.size():
		tier = suffixes.size() - 1
	
	var scaled = n / pow(1000, tier)
	
	var rounded = round(scaled)
	
	
	var text = str(int(rounded))
	
	return text + suffixes[tier]
func update_amount_per_click() -> void:
	var click_mult = TACO_click_multiplier
	if golden_taco_activated:
		if gtacomax:
			click_mult *= 15
		else:
			click_mult *= 5
	if hyperdrive:
		click_mult *= 1.5
	amount_per_click = base_amount_per_click * click_mult
func update_passive_gains() -> void:
	var gains_mult = TACO_gains_multiplier
	if disco_sauce_activated:

		if dsaucemax:
			gains_mult *= 150
		else:
			gains_mult *= 50
	if hyperdrive:
		gains_mult *= 1.5
	passive_gains = base_passive_gains * gains_mult
	$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains) + " PER SECOND"
func update_entropy_gains():
	var entropy_mult = TACO_entropy_multiplier
	if cosmic_overflow_activated:
		if coverflowmax:
			entropy_mult *= 75
		else:
			entropy_mult *= 25
	if hyperdrive:
		entropy_mult *= 1.5
	entropy_gains = base_entropy_gains * entropy_mult
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains) + " PER SECOND"
func update_taco_sliders():
	var slider_mult = 1
	if overclock_activated:
		if overclockmax:
			slider_mult *= 30
		else:
			slider_mult *= 10 
	$T_A_C_O/amountsperclickslider.max_value = base_apc_max_value*slider_mult
	$T_A_C_O/passivegainsperclickslider.max_value = base_apc_max_value*slider_mult
	$T_A_C_O/entropymultiplierperclickslider.max_value = base_entropy_max_value*slider_mult

func show_cost_warning(costlabel):
	if costlabel.has_meta("tween"):
		var old_tween = costlabel.get_meta("tween")
		if old_tween.is_valid():
			old_tween.kill()

	
	costlabel.modulate.a = 1.0
	costlabel.show()

	
	var tween = create_tween()
	costlabel.set_meta("tween", tween)  
	tween.tween_property(costlabel, "modulate:a", 0.0, 0.5)
	tween.tween_callback(Callable(costlabel, "hide"))
func show_notification(label: Label):
	if base_notification_y == 0:
		base_notification_y = label.position.y

	active_notifications.append(label)
	_update_notification_positions()

	label.modulate.a = 1.0
	label.show()

	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func():
		label.hide()
		active_notifications.erase(label)
		_update_notification_positions()
	)
func unlock_achievement(no):
	if Global.get(no) == false:
		Global.set(no,true)
		show_notification(achievementlabel)
		save_data()
func _update_notification_positions():
	for i in range(active_notifications.size()):
		var lbl = active_notifications[i]
		var target_y = base_notification_y + (i * notification_offset)

		if lbl.position.y != target_y:
			var tween = create_tween()
			tween.tween_property(lbl, "position:y", target_y, 0.25)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)

func _on_tacobutton_button_down() -> void:
	var rand = randi() % 25
	match rand:
		0:
			tacos += amount_per_click*5
			emit_signal("taco_clicked",amount_per_click*5,true)
		_:
			tacos += amount_per_click
			emit_signal("taco_clicked",amount_per_click,false)
	emit_signal("tacos_changed",tacos)
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
		var rand
		if gtacors:
			rand = randi() % 2400
		else:
			rand = randi() % 3000
		match rand:
			!1:
				pass
			1:
				if gtacomax:
					gtacolabel.text = "Golden Taco Activated. Tacos per Click Increased By 15x"
				show_notification(gtacolabel)
				$left/MarginContainer/tacobutton.texture_normal = gtaco_texture
				golden_taco_activated = true
				update_amount_per_click()
				gtaco_activated_count += 1
				if gtaco_activated_count >= 3:
					unlock_achievement("a3_unlocked")
				gtaco_timer.start(10.0)
	if disco_sauce_bought and disco_sauce_activated == false:
		var rand
		if dsaucers:
			rand = randi() % 2400
		else:
			rand = randi() % 3000
		match rand:
			!1:
				pass
			1:
				if dsaucemax:
					dsaucelabel.text = "Disco Sauce Activated. Clicks per Second Increased By 150x"
				show_notification(dsaucelabel)
				disco_sauce_activated = true
				update_passive_gains()
				_on_passivegainsperclickslider_value_changed(TACO_gains_multiplier)
				$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
				$disco.play("disco_anim")
				dsauce_activated_count += 1
				if dsauce_activated_count >= 3:
					unlock_achievement("a4_unlocked")
				dsauce_timer.start(10.0)
	if cosmic_overflow_bought and cosmic_overflow_activated == false:
		var rand
		if coverflowrs:
			rand = randi() % 4800
		else:
			rand = randi() % 6000

		match rand:
			!1:
				pass
			1:
				if coverflowmax:
					coverflowlabel.text = "Cosmic Overflow Activated. Entropy per Second Increased By 75x"
				show_notification(coverflowlabel)
				cosmic_overflow_activated = true
				update_entropy_gains()
				$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
				coverflow_activated_count += 1
				if coverflow_activated_count >= 3:
					unlock_achievement("a11_unlocked")
				coverflow_timer.start(10.0)
				for sprite in get_tree().get_nodes_in_group("coverflow"):
					var tween = create_tween()
					tween.tween_property(sprite, "position:y", sprite.position.y - 150, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if overclock_bought and overclock_activated == false:
		var rand = randi() % 1000
		
		match rand:
			!1:
				pass
			1:
				if overclockmax:
					overclocklabel.text = "Overclock Activated. T.A.C.O Multipliers Increased By 30x"
				show_notification(overclocklabel)
				overclock_activated = true
				update_taco_sliders()
				$overclock.play("overclock_anim")
				overclock_activated_count += 1
				if overclock_activated_count >= 3:
					unlock_achievement("a12_unlocked")
				overclock_timer.start(10.0)
	if not Global.a15_unlocked and a15_helper():
		a15_timer += delta
		if a15_timer >= 10:
			unlock_achievement("a15_unlocked")
	else:
		a15_timer = 0
	if not Global.a16_unlocked and a16_helper():
		a16_timer += delta
		if a16_timer >= 10:
			unlock_achievement("a16_unlocked")
	else:
		a16_timer = 0
	if not Global.a17_unlocked and a17_helper():
		a17_timer += delta
		if a16_timer >= 20:
			unlock_achievement("a17_unlocked")
	else:
		a17_timer = 0
	if not Global.a18_unlocked:
		if tacos >= 1000000000:
			unlock_achievement("a18_unlocked")

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
		"upg14cost" : upg14cost,
		"upg15cost" : upg15cost,
		"TACO_bought" : TACO_bought,
		"entropy": entropy,
		"base_entropy_gains" : base_entropy_gains,
		"entropy_gains": entropy_gains,
		"TACO_click_multiplier": TACO_click_multiplier,
		"TACO_gains_multiplier": TACO_gains_multiplier,
		"TACO_entropy_multiplier": TACO_entropy_multiplier,
		"base_apc_max_value" : base_apc_max_value,
		"base_cps_max_value" : base_cps_max_value,
		"base_entropy_max_value": base_entropy_max_value,
		"a1_bought_count" : a1_bought_count,
		"Global.a1_unlocked": Global.a1_unlocked,
		"Global.a1_claimed": Global.a1_claimed,
		"a2_bought_count": a2_bought_count,
		"Global.a2_unlocked": Global.a2_unlocked,
		"Global.a2_claimed": Global.a2_claimed,
		"gtaco_activated_count": gtaco_activated_count,
		"Global.a3_unlocked": Global.a3_unlocked,
		"Global.a3_claimed": Global.a3_claimed,
		"dsauce_activated_count": dsauce_activated_count,
		"Global.a4_unlocked": Global.a4_unlocked,
		"Global.a4_claimed": Global.a4_claimed,
		"a5_bought_count": a5_bought_count,
		"Global.a5_unlocked": Global.a5_unlocked,
		"Global.a5_claimed": Global.a5_claimed,
		"a6_bought_count": a6_bought_count,
		"Global.a6_unlocked": Global.a6_unlocked,
		"Global.a6_claimed": Global.a6_claimed,
		"a7_bought_count": a7_bought_count,
		"Global.a7_unlocked": Global.a7_unlocked,
		"Global.a7_claimed": Global.a7_claimed,
		"a8_bought_count": a8_bought_count,
		"Global.a8_unlocked": Global.a8_unlocked,
		"Global.a8_claimed": Global.a8_claimed,
		"a9_bought_count": a9_bought_count,
		"Global.a9_unlocked": Global.a9_unlocked,
		"Global.a9_claimed": Global.a9_claimed,
		"a10_bought_count": a10_bought_count,
		"Global.a10_unlocked": Global.a10_unlocked,
		"Global.a10_claimed": Global.a10_claimed,
		"coverflow_activated_count": coverflow_activated_count,
		"Global.a11_unlocked": Global.a11_unlocked,
		"Global.a11_claimed": Global.a11_claimed,
		"overclock_activated_count": overclock_activated_count,
		"Global.a12_unlocked": Global.a12_unlocked,
		"Global.a12_claimed": Global.a12_claimed,
		"a13_bought_count": a13_bought_count,
		"Global.a13_unlocked": Global.a13_unlocked,
		"Global.a13_claimed": Global.a13_claimed,
		"a14_bought_count": a14_bought_count,
		"Global.a14_unlocked": Global.a14_unlocked,
		"Global.a14_claimed": Global.a14_claimed,
		"Global.a15_unlocked": Global.a15_unlocked,
		"Global.a15_claimed": Global.a15_claimed,
		"Global.a16_unlocked": Global.a16_unlocked,
		"Global.a16_claimed": Global.a16_claimed,
		"Global.a17_unlocked": Global.a17_unlocked,
		"Global.a17_claimed": Global.a17_claimed,
		"Global.a18_unlocked": Global.a18_unlocked,
		"Global.a18_claimed": Global.a18_claimed,
		"Global.hyperdrive_bought": Global.hyperdrive_bought,
		"hyperdrive": hyperdrive,
		"Global.gtacomax_bought": Global.gtacomax_bought,
		"gtacomax": gtacomax,
		"Global.dsaucemax_bought": Global.dsaucemax_bought,
		"dsaucemax": dsaucemax,
		"Global.coverflowmax_bought": Global.coverflowmax_bought,
		"coverflowmax": coverflowmax,
		"Global.gtacors_bought": Global.gtacors_bought,
		"gtacors": gtacors,
		"Global.dsaucers_bought": Global.dsaucers_bought,
		"dsaucers": dsaucers,
		"Global.coverflowrs_bought": Global.coverflowrs_bought,
		"coverflowrs": coverflowrs,
		"Global.apccd_bought": Global.apccd_bought,
		"apccd": apccd,
		"Global.cpscd_bought": Global.cpscd_bought,
		"cpscd": cpscd,
		"Global.epscd_bought": Global.epscd_bought,
		"epscd": epscd,
		"Global.overclockmax_bought": Global.overclockmax_bought,
		"overclockmax": overclockmax,
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
			upg14cost = data.get("upg14cost",5000000)
			upg15cost = data.get("upg15cost",5000000)
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
			base_apc_max_value = data.get("base_apc_max_value",10)
			base_cps_max_value = data.get("base_cps_max_value",10)
			base_entropy_max_value = data.get("base_entropy_max_value",10)
			a1_bought_count = data.get("a1_bought_count",0)
			Global.a1_unlocked = data.get("Global.a1_unlocked",false)
			Global.a1_claimed = data.get("Global.a1_claimed",false)
			a2_bought_count = data.get("a2_bought_count",0)
			Global.a2_unlocked = data.get("Global.a2_unlocked",false)
			Global.a2_claimed = data.get("Global.a2_claimed",false)
			gtaco_activated_count = data.get("gtaco_activated_count",0)
			Global.a3_unlocked = data.get("Global.a3_unlocked",false)
			Global.a3_claimed = data.get("Global.a3_claimed",false)
			dsauce_activated_count = data.get("dsauce_activated_count",0)
			Global.a4_unlocked = data.get("Global.a4_unlocked",false)
			Global.a4_claimed = data.get("Global.a4_claimed",false)
			a5_bought_count = data.get("a5_bought_count",0)
			Global.a5_unlocked = data.get("Global.a5_unlocked",false)
			Global.a5_claimed = data.get("Global.a5_claimed",false)
			a6_bought_count = data.get("a6_bought_count",0)
			Global.a6_unlocked = data.get("Global.a6_unlocked",false)
			Global.a6_claimed = data.get("Global.a6_claimed",false)
			a7_bought_count = data.get("a7_bought_count",0)
			Global.a7_unlocked = data.get("Global.a7_unlocked",false)
			Global.a7_claimed = data.get("Global.a7_claimed",false)
			a8_bought_count = data.get("a8_bought_count",0)
			Global.a8_unlocked = data.get("Global.a8_unlocked",false)
			Global.a8_claimed = data.get("Global.a8_claimed",false)
			a9_bought_count = data.get("a9_bought_count",0)
			Global.a9_unlocked = data.get("Global.a9_unlocked",false)
			Global.a9_claimed = data.get("Global.a9_claimed",false)
			a10_bought_count = data.get("Global.a10_claimed",false)
			Global.a10_unlocked = data.get("Global.a10_unlocked",false)
			Global.a10_claimed = data.get("Global.a10_claimed",false)
			coverflow_activated_count = data.get("coverflow_activated_count",false)
			Global.a11_unlocked = data.get("Global.a11_unlocked",false)
			Global.a11_claimed = data.get("Global.a11_claimed",false)
			overclock_activated_count = data.get("overclock_activated_count",false)
			Global.a12_unlocked = data.get("Global.a12_unlocked",false)
			Global.a12_claimed = data.get("Global.a12_claimed",false)
			a13_bought_count = data.get("a13_bought_count",false)
			Global.a13_unlocked = data.get("Global.a13_unlocked",false)
			Global.a13_claimed = data.get("Global.a13_claimed",false)
			a14_bought_count = data.get("a14_bought_count",false)
			Global.a14_unlocked = data.get("Global.a14_unlocked",false)
			Global.a14_claimed = data.get("Global.a14_claimed",false)
			Global.a15_unlocked = data.get("Global.a15_unlocked",false)
			Global.a15_claimed = data.get("Global.a15_claimed",false)
			Global.a16_unlocked = data.get("Global.a16_unlocked",false)
			Global.a16_claimed = data.get("Global.a16_claimed",false)
			Global.a17_unlocked = data.get("Global.a17_unlocked",false)
			Global.a17_claimed = data.get("Global.a17_claimed",false)
			Global.a18_unlocked = data.get("Global.a18_unlocked",false)
			Global.a18_claimed = data.get("Global.a18_claimed",false)
			Global.hyperdrive_bought = data.get("Global.hyperdrive_bought",false)
			hyperdrive = data.get("hyperdrive",false)
			Global.gtacomax_bought = data.get("Global.gtacomax_bought",false)
			gtacomax = data.get("gtacomax",false)
			Global.dsaucemax_bought = data.get("Global.dsaucemax_bought",false)
			dsaucemax = data.get("dsaucemax",false)
			Global.coverflowmax_bought = data.get("Global.coverflowmax_bought",false)
			coverflowmax = data.get("coverflowmax",false)
			Global.gtacors_bought = data.get("Global.gtacors_bought",false)
			gtacors = data.get("gtacors",false)
			Global.dsaucers_bought = data.get("Global.dsaucers_bought",false)
			dsaucers = data.get("dsaucers",false)
			Global.coverflowrs_bought = data.get("Global.coverflowrs_bought",false)
			coverflowrs = data.get("coverflowrs",false)
			Global.apccd_bought = data.get("Global.apccd_bought",false)
			apccd = data.get("apccd",false)
			Global.cpscd_bought = data.get("Global.cpscd_bought",false)
			cpscd = data.get("cpscd",false)
			Global.epscd_bought = data.get("Global.epscd_bought",false)
			epscd = data.get("epscd",false)
			Global.overclockmax_bought = data.get("Global.overclockmax_bought",false)
			overclockmax = data.get("overclockmax",false)
			discount()
			update_amount_per_click()
			update_passive_gains()
			update_entropy_gains()
	else:
		save_data()

func _on_button_button_down() -> void:
	if tacos >= upg1cost:
		base_amount_per_click += 1
		recalc()
		tacos -= upg1cost
		
		upg1cost *= 1.35
		a1_bought_count += 1
		$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = format_number(upg1cost)+" Tacos"
		if a1_bought_count >= 10:
			unlock_achievement("a1_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
func _on_autoclickupg_1_button_down() -> void:
	if tacos >= upg2cost:
		base_passive_gains += 1
		recalc()
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg2cost

		upg2cost *= 1.35
		a2_bought_count += 1
		$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = format_number(upg2cost)+" Tacos"
		if a2_bought_count >= 10:
			unlock_achievement("a2_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
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
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
func _on_gtacotimer_timeout() -> void:
	golden_taco_activated = false
	update_amount_per_click()
	$left/MarginContainer/tacobutton.texture_normal = taco_texture

func _on_amtperclickupg_2_button_down() -> void:
	if tacos >= upg4cost:
		base_amount_per_click += 10
		recalc()
		tacos -= upg4cost

		upg4cost *= 1.35
		a5_bought_count += 1
		$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = format_number(upg4cost)+" Tacos"
		if a5_bought_count >= 10:
			unlock_achievement("a5_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
func _on_autoclickupg_2_button_down() -> void:
	if tacos >= upg5cost:
		base_passive_gains += 10
		recalc()
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg5cost

		upg5cost *= 1.35
		a6_bought_count += 1
		$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = format_number(upg5cost)+" Tacos"
		if a6_bought_count >= 10:
			unlock_achievement("a6_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
func _on_disco_sauce_button_down() -> void:
	if tacos >= upg6cost and disco_sauce_bought == false:
		disco_sauce_bought = true
		tacos -= upg6cost
		$scroller/VBoxContainer/right/disco_sauce/disco_sauce_label.text = format_number(upg6cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
func _on_dsaucetimer_timeout() -> void:
	disco_sauce_activated = false
	update_passive_gains()
	_on_passivegainsperclickslider_value_changed(TACO_gains_multiplier)
	$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
	$disco.play("reset")

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
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
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
		recalc()
		$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
		tacos -= upg8cost

		upg8cost *= 1.35
		a7_bought_count += 1
		$scroller/VBoxContainer/right/entropyupg1button/entropyupg1label.text = format_number(upg8cost)+" Tacos"
		if a7_bought_count >= 10:
			unlock_achievement("a7_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_entropyupg_2_button_2_button_down() -> void:
	if tacos >= upg9cost:
		base_entropy_gains += 10
		recalc()
		$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
		tacos -= upg9cost

		upg9cost *= 1.35
		a8_bought_count += 1
		$scroller/VBoxContainer/right/entropyupg2button2/entropyupg2label.text = format_number(upg9cost)+" Tacos"
		if a8_bought_count >= 10:
			unlock_achievement("a8_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_amtperclickupg_3_button_down() -> void:

	if tacos >= upg10cost:
		base_amount_per_click += 100
		recalc()
		tacos -= upg10cost

		upg10cost *= 1.35
		a9_bought_count += 1
		$scroller/VBoxContainer/right/amtperclickupg3/amountperclickupgrade3label.text = format_number(upg10cost)+" Tacos"
		if a9_bought_count >= 10:
			unlock_achievement("a9_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_autoclickupg_3_button_down() -> void:
	if tacos >= upg11cost:
		base_passive_gains += 100
		recalc()
		$left/MarginContainer/VBoxContainer/persecondcount.text = format_number(passive_gains)+" PER SECOND"
		tacos -= upg11cost

		upg11cost *= 1.35
		a10_bought_count += 1
		$scroller/VBoxContainer/right/autoclickupg3/autoclickupgsprite3.text = format_number(upg11cost)+" Tacos"
		if a10_bought_count >= 10:
			unlock_achievement("a10_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_cosmic_overflow_button_down() -> void:
	if tacos >= upg12cost and cosmic_overflow_bought == false:
		cosmic_overflow_bought = true
		tacos -= upg12cost
		$scroller/VBoxContainer/right/cosmic_overflow/cosmic_overflow_label.text = format_number(upg12cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_coverflowtimer_timeout() -> void:
	cosmic_overflow_activated = false
	update_entropy_gains()
	$left/entropy/entropypersecondcount.text = format_number(entropy_gains) + " PER SECOND"
	#coverflow_original_position[sprite] = sprite.position
	for sprite in get_tree().get_nodes_in_group("coverflow"):
		if not coverflow_original_position.has(sprite):
			continue

		var tween = create_tween()
		tween.tween_property(
			sprite,
			"position",
			coverflow_original_position[sprite],
			0.5
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)	
func _on_taco_overclock_button_down() -> void:
	if tacos >= upg13cost and overclock_bought == false:
		overclock_bought = true
		tacos -= upg13cost
		$scroller/VBoxContainer/right/TACO_overclock/TACO_overclock_label.text = format_number(upg13cost)+" Tacos"
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)

func _on_overclocktimer_timeout() -> void:
	overclock_activated = false
	update_taco_sliders()
	$overclock.play("reset")


func _on_entropyupg_3_button_3_button_down() -> void:
	if tacos >= upg14cost:
		base_entropy_gains += 100
		recalc()
		$left/entropy/entropypersecondcount.text = format_number(entropy_gains)+" PER SECOND"
		tacos -= upg14cost

		upg14cost *= 1.35
		a13_bought_count += 1
		
		$scroller/VBoxContainer/right/entropyupg3button3/entropyupg3label.text = format_number(upg14cost)+" Tacos"
		if a13_bought_count >= 10:
			unlock_achievement("a13_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
	
func _on_tacoupg_1_button_button_down() -> void:
	if tacos >= upg15cost:
		base_cps_max_value += 1
		base_apc_max_value += 1
		base_entropy_max_value += 1
		update_taco_sliders()
		tacos -= upg15cost
	
		upg15cost *= 1.35
		a14_bought_count += 1
		$scroller/VBoxContainer/right/tacoupg1button/tacoupg1label.text = format_number(upg15cost)+" Tacos"
		if a14_bought_count >= 10:
			unlock_achievement("a14_unlocked")
		emit_signal("tacos_changed",tacos)
		save_data()
	else:
		show_cost_warning($left/MarginContainer/VBoxContainer/notenoughmoneylabel)
	


func _on_achievementsbutton_button_up() -> void:
	#var ach = preload("res://scenes/achievements.tscn")
	#ach.connect("a1_reward", Callable(self, "_on_achievement_reward"))
	var transition = preload("res://scenes/swipe.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.swipe_in("res://scenes/achievements.tscn", 1)
	
func a15_helper():
	return (TACO_click_multiplier >= 5 and TACO_gains_multiplier >= 5 and TACO_entropy_multiplier >= 5)
func a16_helper():
	return(TACO_click_multiplier >= 10 and TACO_gains_multiplier >= 10 and TACO_entropy_multiplier >= 10)
func a17_helper():
	return(TACO_click_multiplier >= 20 and TACO_gains_multiplier >= 20 and TACO_entropy_multiplier >= 20)

func recalc():
	update_amount_per_click()
	update_passive_gains()
	update_entropy_gains()


func _on_skilltreebutton_button_up() -> void:
	var transition = preload("res://scenes/swipe.tscn").instantiate()
	get_tree().root.add_child(transition)
	transition.swipe_in("res://scenes/skill_tree.tscn", 1)
func discount():
	var apc_discount = 0.8 if apccd else 1.0
	var cps_discount = 0.8 if cpscd else 1.0
	var eps_discount = 0.8 if epscd else 1.0
	upg1cost = upg1cost_base * apc_discount
	upg4cost = upg4cost_base * apc_discount
	upg10cost = upg10cost_base * apc_discount
	upg2cost = upg2cost_base * cps_discount
	upg5cost = upg5cost_base * cps_discount
	upg11cost = upg11cost_base * cps_discount
	upg8cost = upg8cost_base * eps_discount
	upg9cost = upg9cost_base * eps_discount
	upg14cost = upg14cost_base * eps_discount
	$scroller/VBoxContainer/right/amtperclickupg1/amountperclickupgrade1label.text = format_number(upg1cost)+" Tacos"
	$scroller/VBoxContainer/right/amtperclickupg2/amountperclickupgrade2label.text = format_number(upg4cost)+" Tacos"
	$scroller/VBoxContainer/right/amtperclickupg3/amountperclickupgrade3label.text = format_number(upg10cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg1/autoclickupgsprite1.text = format_number(upg2cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg2/autoclickupgsprite2.text = format_number(upg5cost)+" Tacos"
	$scroller/VBoxContainer/right/autoclickupg3/autoclickupgsprite3.text = format_number(upg11cost)+" Tacos"
	$scroller/VBoxContainer/right/entropyupg1button/entropyupg1label.text = format_number(upg8cost)+" Tacos"
	$scroller/VBoxContainer/right/entropyupg2button2/entropyupg2label.text = format_number(upg9cost)+" Tacos"
	$scroller/VBoxContainer/right/entropyupg3button3/entropyupg3label.text = format_number(upg14cost)+" Tacos"
	save_data()
