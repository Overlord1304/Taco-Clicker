extends Control

@onready var game = get_tree().get_first_node_in_group("game")
@onready var gtaco_button = $Panel/GTacoUpg
@onready var dsauce_button = $Panel/DSauceUpg
@onready var coverflow_button = $Panel/COverflowUpg
@onready var gtacors_button = $Panel/GTacoUpg2
@onready var dsaucers_button = $Panel/DSauceUpg2
@onready var coverflowrs_button = $Panel/COverflowUpg2
@onready var apccd_button = $Panel/APCSubsidy
var upgrades = {
	"hyperdrive": {
		"cost": 1_000_000_000,
		"currency": "tacos",
		"bought_flag": "hyperdrive_bought",
		"game_flag": "hyperdrive",
		"buy_button_path": "Panel/HyperDrive/Panel/buyhyperdrive",
		"panel_path": "Panel/HyperDrive/Panel"
	},
	"gtacomax": {
		"cost": 10_000_000,
		"currency": "entropy",
		"bought_flag": "gtacomax_bought",
		"game_flag": "gtacomax",
		"buy_button_path": "Panel/GTacoUpg/Panel/buygtacomax",
		"panel_path": "Panel/GTacoUpg/Panel"
	},
	"dsaucemax": {
		"cost": 20_000_000,
		"currency": "entropy",
		"bought_flag": "dsaucemax_bought",
		"game_flag": "dsaucemax",
		"buy_button_path": "Panel/DSauceUpg/Panel/buydsaucemax",
		"panel_path": "Panel/DSauceUpg/Panel"
	},
	"coverflowmax": {
		"cost": 30_000_000,
		"currency": "entropy",
		"bought_flag": "coverflowmax_bought",
		"game_flag": "coverflowmax",
		"buy_button_path": "Panel/COverflowUpg/Panel/buycoverflowmax",
		"panel_path": "Panel/COverflowUpg/Panel",
	},
	"gtacors":{
		"cost": 500_000_000,
		"currency": "tacos",
		"bought_flag": "gtacors_bought",
		"game_flag": "gtacors",
		"buy_button_path": "Panel/GTacoUpg2/Panel/buygtacoupg2",
		"panel_path":"Panel/GTacoUpg2/Panel",
	},
	"dsaucers":{
		"cost": 750_000_000,
		"currency": "tacos",
		"bought_flag": "dsaucers_bought",
		"game_flag": "dsaucers",
		"buy_button_path": "Panel/DSauceUpg2/Panel/buydsauceupg2",
		"panel_path":"Panel/DSauceUpg2/Panel",
	},
	"coverflowrs":{
		"cost": 1_000_000_000,
		"currency": "tacos",
		"bought_flag": "coverflowrs_bought",
		"game_flag": "coverflowrs",
		"buy_button_path": "Panel/COverflowUpg2/Panel/buycoverflowupg2",
		"panel_path": "Panel/COverflowUpg2/Panel"
	},
	"apccd":{
		"cost": 500_000_000,
		"currency":"tacos",
		"bought_flag": "apccd_bought",
		"game_flag": "apccd",
		"buy_button_path": "Panel/APCSubsidy/Panel/buyapcsubsidy",
		"panel_path": "Panel/APCSubsidy/Panel",
	}
}

func _ready():
	
	for key in upgrades:
		var upg = upgrades[key]
		upg.button = get_node(upg.buy_button_path)
		upg.panel = get_node(upg.panel_path)

	update_buttons()

func update_buttons():
	gtaco_button.disabled = !Global.hyperdrive_bought
	dsauce_button.disabled = !Global.hyperdrive_bought
	coverflow_button.disabled = !Global.hyperdrive_bought
	gtacors_button.disabled = !Global.gtacomax_bought
	dsaucers_button.disabled = !Global.dsaucemax_bought
	coverflowrs_button.disabled = !Global.coverflowmax_bought
	apccd_button.disabled = !Global.gtacomax_bought
	for key in upgrades:
		var upg = upgrades[key]
		if Global.get(upg.bought_flag):
			upg.button.text = "BOUGHT"
			upg.button.disabled = true

func buy_upgrade(name):
	var upg = upgrades[name]

	if Global.get(upg.bought_flag):
		return

	if game.get(upg.currency) >= upg.cost:
		game.set(upg.currency, game.get(upg.currency) - upg.cost)
		Global.set(upg.bought_flag, true)
		game.set(upg.game_flag, true)

		upg.button.text = "BOUGHT"
		upg.button.disabled = true

		game.recalc()
		update_buttons()
	else:
		game.show_cost_warning($notenoughmoneylabel)

func toggle_panel(panel):
	hide_all_panels()
	panel.visible = !panel.visible

func hide_all_panels():
	for panel in get_tree().get_nodes_in_group("upg_desc"):
		panel.visible = false

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_all_panels()

func _on_back_button_up():
	var swipe = get_meta("swipe")
	if swipe:
		swipe.swipe_out(-1)



func _on_over_drive_button_up():
	toggle_panel(upgrades.hyperdrive.panel)
	
func _on_buyhyperdrive_button_up():
	buy_upgrade("hyperdrive")
func _on_g_taco_upg_button_up():
	toggle_panel(upgrades.gtacomax.panel)

func _on_buygtacomax_button_up():
	buy_upgrade("gtacomax")
func _on_d_sauce_upg_button_up():
	toggle_panel(upgrades.dsaucemax.panel)
	
func _on_buydsaucemax_button_up():
	buy_upgrade("dsaucemax")

func _on_c_overflow_upg_button_up():
	toggle_panel(upgrades.coverflowmax.panel)
	
	
func _on_buycoverflowmax_button_up():
	buy_upgrade("coverflowmax")


func _on_g_taco_upg_2_button_up() -> void:
	toggle_panel(upgrades.gtacors.panel)
func _on_buygtacoupg_2_button_up() -> void:
	buy_upgrade("gtacors")


func _on_d_sauce_upg_2_button_up() -> void:
	toggle_panel(upgrades.dsaucers.panel)

func _on_buydsauceupg_2_button_up() -> void:
	buy_upgrade("dsaucers")
func _on_c_overflow_upg_2_button_up() -> void:
	toggle_panel(upgrades.coverflowrs.panel)

func _on_buycoverflowupg_2_button_down() -> void:
	buy_upgrade("coverflowrs")


func _on_apc_subsidy_button_up() -> void:
	toggle_panel(upgrades.apccd.panel)


func _on_buyapcsubsidy_button_up() -> void:
	buy_upgrade("apccd")
