class_name PauseMenu
extends MenuBase
## The main pause menu of the game.
##
## Should stay in the [SceneTree] while the game is running,
## so when the tree gets paused, this menu will pop up. When loading
## into a new level, make sure you set [member CanvasItem.visible] to [code]false[/code].

# Helps us detect the frame when the game gets paused.
# Should be set to true in the first frame of the game
# being paused, and set to false by the end of it.
var just_paused = true

## Resumes gameplay and hides the pause menu.
func resume() -> void:
	get_tree().paused = false
	visible = false
	# This will make sure we can
	# detect when the game gets paused again,
	# so we'll be able to make the pause menu
	# visible again and give focus to the resume option.
	just_paused = true

# NOTE: This is a test pause menu option
## Will switch to the next room that is loaded. 
func next_room() -> void:
	Game.get_game(get_tree()).next_room()
	resume()

## Switches to the settings menu
func settings() -> void:
	GUI.get_gui(get_tree()).menus["menu_settings"].prv_menu = "menu_pause"
	GUI.get_gui(get_tree()).switch_menu("menu_settings")
	# Give this attribute it's initial value.
	just_paused = true
	pass

## Switches back to the title screen
## and removes the currently loaded room
func title() -> void:
	Game.get_game(get_tree()).remove_current_room()
	GUI.get_gui(get_tree()).switch_menu("menu_title")
	# Give this attribute it's initial value.
	just_paused = true

func _ready() -> void:
	# Defining the basic menu behavior.
	_options = {
		"resume": resume,
		"next room": next_room,
		"settings": settings,
		"return to title": title
	}
	_on_cancel = resume
	_focus_first = %Resume
	super()

func _process(delta: float) -> void:
	if just_paused:
		just_paused = false
		# when the pause menu becomes active, make it
		# visible and give focus to the resume option.
		_focus_first.grab_focus()
		visible = true
		return
	super(delta)
