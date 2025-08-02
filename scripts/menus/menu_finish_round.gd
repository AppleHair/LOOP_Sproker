class_name FinishRoundMenu
extends MenuBase

const PAUSE_TIME:float = 2
var pause_timer:float = PAUSE_TIME

func _enter_tree() -> void:
	pause_timer = PAUSE_TIME
	super()

func _process(delta: float) -> void:
	pause_timer -= delta
	if pause_timer <= 0.0:
		if RoomBase.current_room.next_round == "":
			var final_score:int = Game.get_game(get_tree()).score
			if final_score > (ProjectSettings.get_setting("global/high_score") as int):
				ProjectSettings.set_setting("global/high_score", final_score)
				ProjectSettings.save_custom("override.cfg")
			Game.get_game(get_tree()).score = 0
			GUI.get_gui(get_tree()).switch_menu("menu_title")
			return
		Game.get_game(get_tree()).load_level(RoomBase.current_room.next_round)
