extends Control
var hyperdrive_cost = 1_000_000_000
var gtacomax_cost = 10_000_000
var dsaucemax_cost = 20_000_000
func _process(_delta):
	
	if Global.hyperdrive_bought:
		$Panel/OverDrive/Panel/buyhyperdrive.text = "BOUGHT"
		$Panel/OverDrive/Panel/buyhyperdrive.disabled = true
		$Panel/GTacoUpg.disabled = false
		$Panel/DSauceUpg.disabled = false
	if Global.gtacomax_bought:
		$Panel/GTacoUpg/Panel/buygtacomax.text = "BOUGHT"
		$Panel/GTacoUpg/Panel/buygtacomax.disabled = true
	if Global.dsaucemax_bought:
		$Panel/DSauceUpg/Panel/buydsaucemax.text = "BOUGHT"
		$Panel/DSauceUpg/Panel/buydsaucemax.disabled = true
func _on_back_button_up():
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)

func _on_over_drive_button_up() -> void:
	if $Panel/OverDrive/Panel.visible:
		$Panel/OverDrive/Panel.visible = false
	else:
		$Panel/OverDrive/Panel.visible = true
		$Panel/GTacoUpg/Panel.visible = false
		$Panel/DSauceUpg/Panel.visible = false
		

func _on_buyhyperdrive_button_up() -> void:
	var game = get_tree().get_first_node_in_group("game")
	if game.tacos >= hyperdrive_cost and Global.hyperdrive_bought == false:
		game.tacos -= hyperdrive_cost
		$Panel/OverDrive/Panel/buyhyperdrive.text = "BOUGHT"
		$Panel/OverDrive/Panel/buyhyperdrive.disabled = true
		Global.hyperdrive_bought = true
		$Panel/GTacoUpg.disabled = false
		game.hyperdrive = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_g_taco_upg_button_up() -> void:
	if $Panel/GTacoUpg/Panel.visible:
		$Panel/GTacoUpg/Panel.visible = false
	else:
		$Panel/GTacoUpg/Panel.visible = true
		$Panel/OverDrive/Panel.visible = false
		$Panel/DSauceUpg/Panel.visible = false


func _on_buygtacomax_button_up() -> void:
	var game = get_tree().get_first_node_in_group("game")
	if game.entropy >= gtacomax_cost and Global.gtacomax_bought == false:
		game.entropy -= gtacomax_cost
		$Panel/GTacoUpg/Panel/buygtacomax.text = "BOUGHT"
		$Panel/GTacoUpg/Panel/buygtacomax.disabled = true
		Global.gtacomax_bought = true
		game.gtacomax = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)


func _on_d_sauce_upg_button_up() -> void:
	if $Panel/DSauceUpg/Panel.visible:
		$Panel/DSauceUpg/Panel.visible = false
	else:
		$Panel/DSauceUpg/Panel.visible = true
		$Panel/GTacoUpg/Panel.visible = false
		$Panel/OverDrive/Panel.visible = false


func _on_buydsaucemax_button_up() -> void:
	var game = get_tree().get_first_node_in_group("game")
	if game.entropy >= dsaucemax_cost and Global.dsaucemax_bought == false:
		game.entropy -= dsaucemax_cost
		$Panel/DSauceUpg/Panel/buydsaucemax.text = "BOUGHT"
		$Panel/DSauceUpg/Panel/buydsaucemax.disabled = true
		Global.dsaucemax_bought = true
		game.dsaucemax = true
		game.recalc()
	else:
		game.show_cost_warning($notenoughmoneylabel)
