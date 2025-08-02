class_name GotHitMenu
extends MenuBase

const PAUSE_TIME:float = 2
var pause_timer:float = PAUSE_TIME

func _enter_tree() -> void:
	pause_timer = PAUSE_TIME
	super()

func _process(delta: float) -> void:
	pause_timer -= delta
	if pause_timer <= 0.0:
		var game:Game = Game.get_game(get_tree())
		if game.replay:
			game.stop_replay()
			return
		game.load_level(game.current_level)
