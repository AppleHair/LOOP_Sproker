class_name PreRoundMenu
extends MenuBase

const READY_TIME:float = 2
var ready_timer:float = READY_TIME

func _enter_tree() -> void:
	ready_timer = READY_TIME
	super()

func _process(delta: float) -> void:
	ready_timer -= delta
	if ready_timer <= 0.0:
		get_tree().paused = false
		GUI.get_gui(get_tree()).switch_menu("menu_pause")
		MenuBase.current_menu.visible = false
