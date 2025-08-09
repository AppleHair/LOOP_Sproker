class_name TitleMenu
extends MenuBase
## The game's title screen.

const REPLAY_TIME:float = 6
var replay_timer:float = REPLAY_TIME

func _init() -> void:
	Input.connect("joy_connection_changed", _on_joy_connection_changed)

func _enter_tree() -> void:
	replay_timer = REPLAY_TIME
	$AnimatedSprite2D.play($AnimatedSprite2D.animation)
	super()

func _on_joy_connection_changed(_device_id, connected):
	if connected:
		$AnimatedSprite2D.animation = "gamepad"
		$AnimatedSprite2D/Gamepad.visible = true
		$AnimatedSprite2D/Keyboard.visible = false
		$Label2.text = "F11 - Fullscreen\nPlus - Pause"
		$Text/Start.text = "press Plus to start"
		$Text/Quit.text = "Minus to quit"
		return
	$AnimatedSprite2D.animation = "keyboard"
	$AnimatedSprite2D/Gamepad.visible = false
	$AnimatedSprite2D/Keyboard.visible = true
	$Label2.text = "F11 - Fullscreen\nEnter - Pause"
	$Text/Start.text = "press Enter to start"
	$Text/Quit.text = "Escape to quit"

func _process(delta: float) -> void:
	replay_timer -= delta
	if replay_timer <= 0.0:
		start_replay()
		return
	super(delta)

func start_replay() -> void:
	var game = Game.get_game(get_tree())
	game.replay = true
	game.load_level("round_2")

## Loads the pause menu and the level.
func start() -> void:
	var game = Game.get_game(get_tree())
	game.score = 0
	game.load_level("round_1")

## Quits the game.
func quit() -> void:
	get_tree().quit()

func _ready() -> void:
	# Defining the basic menu behavior.
	_options = {
		"press Enter to start": start,
		"press Plus to start": start
	}
	_focus_first = %Start
	if OS.get_name() == "Web":
		$Text/Quit.visible = false
		super()
		return
	_on_cancel = quit
	super()
