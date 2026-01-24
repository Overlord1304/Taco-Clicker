extends Control
@onready var game = get_tree().get_first_node_in_group("game")
var dtaco_cost = 50_000_000
var sbtaco_cost = 150_000_000
func _ready():
	$s/h/Panel/DiamondTaco/dtaco.play("default")
	$s/h/Panel/DiamondTaco/dtacogolden.play("default")
	$s/h/Panel/StormboundTaco/sbtaco.play("default")
	$s/h/Panel/StormboundTaco/sbtacogolden.play("default")

func _process(_delta):
	if Global.dtaco_bought:
		if Global.dtaco_equipped:
			$s/h/Panel/DiamondTaco/dtaco_buy.text = "EQUIPPED"
		else:
			$s/h/Panel/DiamondTaco/dtaco_buy.text = "EQUIP"
	if Global.sbtaco_bought:
		if Global.sbtaco_equipped:
			$s/h/Panel/StormboundTaco/sbtaco_buy.text = "EQUIPPED"
		else:
			$s/h/Panel/StormboundTaco/sbtaco_buy.text = "EQUIP"
func _on_back_button_down():
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)


func _on_dtaco_buy_pressed() -> void:
	if Global.dtaco_bought:
		Global.dtaco_equipped = true
		Global.sbtaco_equipped = false
		Global.ntaco_equipped = false
		$s/h/Panel/DiamondTaco/dtaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= dtaco_cost:
		$s/h/Panel/DiamondTaco/dtaco_buy.text = "EQUIP"
		Global.dtaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)
	


func _on_sbtaco_buy_pressed():
	if Global.sbtaco_bought:
		Global.dtaco_equipped = false
		Global.sbtaco_equipped = true
		Global.ntaco_equipped = false
		$s/h/Panel/StormboundTaco/sbtaco_buy.text = "EQUIPPED"
		game.update_taco_skin()
		game.save_data()
		return

	if game.tacos >= sbtaco_cost:
		$s/h/Panel/StormboundTaco/sbtaco_buy.text = "EQUIP"
		Global.sbtaco_bought = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)
