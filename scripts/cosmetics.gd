extends Control
@onready var game = get_tree().get_first_node_in_group("game")
var dtaco_cost = 50_000_000
var sbtaco_cost = 150_000_000
var vtaco_cost = 500_000_000
func _ready():
	$s/Panel/h/DiamondTaco/dtaco.play("default")
	$s/Panel/h/DiamondTaco/dtacogolden.play("default")
	$s/Panel/h/StormboundTaco/sbtaco.play("default")
	$s/Panel/h/StormboundTaco/sbtacogolden.play("default")
	$s/Panel/h/VoidTaco/vtaco.play("default")
	$s/Panel/h/VoidTaco/vtacogolden.play("default")

func _process(_delta):
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
