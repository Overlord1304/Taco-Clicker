extends Control
@onready var game = get_tree().get_first_node_in_group("game")
var staco_cost = 67
var dtaco_cost = 50_000_000
var sbtaco_cost = 150_000_000
var vtaco_cost = 500_000_000
var ataco_cost = 650_000_000
var etaco_cost = 750_000_000
var ftaco_cost = 1_000_000_000
func _ready():
	$s/Panel/h/DiamondTaco/dtaco.play("default")
	$s/Panel/h/DiamondTaco/dtacogolden.play("default")
	$s/Panel/h/StormboundTaco/sbtaco.play("default")
	$s/Panel/h/StormboundTaco/sbtacogolden.play("default")
	$s/Panel/h/VoidTaco/vtaco.play("default")
	$s/Panel/h/VoidTaco/vtacogolden.play("default")
	$s/Panel/h/AmethystTaco/ataco.play("default")
	$s/Panel/h/AmethystTaco/atacogolden.play("default")
	$s/Panel/h/EntropyTaco/etaco.play("default")
	$s/Panel/h/EntropyTaco/etacogolden.play("default")
	$s/Panel/h/FireTaco/ftaco.play("default")
	$s/Panel/h/FireTaco/ftacogolden.play("default")
func _process(_delta):
	if Global.staco_bought:
		if Global.staco_equipped:
			$s/Panel/h/StormlockTaco/staco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/StormlockTaco/staco_buy.text = "EQUIP"
	if Global.dtaco_bought:
		if Global.dtaco_equipped:
			$s/Panel/h/DiamondTaco/dtaco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/DiamondTaco/dtaco_buy.text = "EQUIP"
	if Global.sbtaco_bought:
		if Global.sbtaco_equipped:
			$s/Panel/h/StormboundTaco/sbtaco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/StormboundTaco/sbtaco_buy.text = "EQUIP"
	if Global.ntaco_equipped:
		$s/Panel/h/NormalTaco/ntaco_equip.text = "EQUIPPED"
	else:
		$s/Panel/h/NormalTaco/ntaco_equip.text = "EQUIP"
	if Global.vtaco_bought:
		if Global.vtaco_equipped:
			$s/Panel/h/VoidTaco/vtaco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/VoidTaco/vtaco_buy.text = "EQUIP"
	if Global.ataco_bought:
		if Global.ataco_equipped:
			$s/Panel/h/AmethystTaco/ataco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/AmethystTaco/ataco_buy.text = "EQUIP"
	if Global.etaco_bought:
		if Global.etaco_equipped:
			$s/Panel/h/EntropyTaco/etaco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/EntropyTaco/etaco_buy.text = "EQUIP"
	if Global.ftaco_bought:
		if Global.ftaco_equipped:
			$s/Panel/h/FireTaco/ftaco_buy.text = "EQUIPPED"
		else:
			$s/Panel/h/FireTaco/ftaco_buy.text = "EQUIP"
func _on_back_button_down():
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)


func _on_dtaco_buy_pressed() -> void:
	if Global.dtaco_bought:
		Global.dtaco_equipped = true
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = false
		Global.etaco_equipped = false
		Global.ftaco_equipped = false
		Global.staco_equipped = false
		$s/Panel/h/DiamondTaco/dtaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= dtaco_cost:
		$s/Panel/h/DiamondTaco/dtaco_buy.text = "EQUIP"
		Global.dtaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)
	


func _on_sbtaco_buy_pressed():
	if Global.sbtaco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = true
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = false
		Global.etaco_equipped = false
		Global.ftaco_equipped = false
		Global.staco_equipped = false
		$s/Panel/h/StormboundTaco/sbtaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= sbtaco_cost:
		$s/Panel/h/StormboundTaco/sbtaco_buy.text = "EQUIP"
		Global.sbtaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_ntaco_equip_pressed() -> void:
	Global.dtaco_equipped = false
	Global.sbtaco_equipped = false
	Global.ntaco_equipped = true
	Global.vtaco_equipped = false
	Global.ataco_equipped = false
	Global.etaco_equipped = false
	Global.ftaco_equipped = false
	Global.staco_equipped = false
	$s/Panel/h/NormalTaco/ntaco_equip.text = "EQUIPPED"
	game.update_taco_skin()
	game.save_data()
	return


func _on_vtaco_buy_pressed() -> void:
	if Global.vtaco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = true
		Global.ataco_equipped = false
		Global.etaco_equipped = false
		Global.ftaco_equipped = false
		Global.staco_equipped = false
		$s/Panel/h/VoidTaco/vtaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= vtaco_cost:
		$s/Panel/h/VoidTaco/vtaco_buy.text = "EQUIP"
		Global.vtaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_ataco_buy_pressed() -> void:
	if Global.ataco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = true
		Global.etaco_equipped = false
		Global.ftaco_equipped = false
		Global.staco_equipped = false
		$s/Panel/h/AmethystTaco/ataco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= ataco_cost:
		$s/Panel/h/AmethystTaco/ataco_buy.text = "EQUIP"
		Global.ataco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)



func _on_etaco_buy_pressed() -> void:
	if Global.etaco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = false
		Global.etaco_equipped = true
		Global.ftaco_equipped = false
		Global.staco_equipped = false
		$s/Panel/h/EntropyTaco/etaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= etaco_cost:
		$s/Panel/h/EntropyTaco/etaco_buy.text = "EQUIP"
		Global.etaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_ftaco_buy_pressed() -> void:
	if Global.ftaco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = false
		Global.etaco_equipped = false
		Global.ftaco_equipped = true
		Global.staco_equipped = false
		$s/Panel/h/FireTaco/ftaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= ftaco_cost:
		$s/Panel/h/FireTaco/ftaco_buy.text = "EQUIP"
		Global.ftaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_staco_equip_pressed() -> void:
	if Global.staco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		Global.vtaco_equipped = false
		Global.ataco_equipped = false
		Global.etaco_equipped = false
		Global.ftaco_equipped = false
		Global.staco_equipped = true
		$s/Panel/h/StormlockTaco/staco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= staco_cost:
		$s/Panel/h/StormlockTaco/staco_buy.text = "EQUIP"
		Global.staco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)
