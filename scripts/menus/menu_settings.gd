class_name SettingsMenu
extends MenuBase
## The main settings menu of the game.
##
## Currently only includes settings for Changing startup window size.

## Increases the game window's startup size and
## loops back to 1 when it reaches the maximum value.
func increase_win_start_size() -> void:
	var main = get_node("/root/Main") as Main
	main.window_mult %= main.window_mult_max()
	main.window_mult += 1

## Resets the window's size to the startup size and
## puts the window in the center of the screen.
func reset_win() -> void:
	(get_node("/root/Main") as Main).reset_window()

func _enter_tree() -> void:
	# The window size option will have a label which will display the
	# value of the window's size multiplier and its change by the option.
	labels = {
		"startup window size:      ": "/root/Main:window_mult"
	}
	super()

func _ready() -> void:
	# Defining the basic menu behavior.
	_options = {
		"startup window size:      ": increase_win_start_size,
		"reset window size": reset_win,
		"back": back
	}
	_on_cancel = back
	_focus_first = %StartWinSize
	super()
