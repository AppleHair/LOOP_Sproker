class_name TitleMenu
extends MenuBase
## The game's title screen.

## Keeps track of the removal
## of the quit option on web.
var quit_removed:bool = false

## Loads the pause menu and the level.
func start() -> void:
	Game.get_game(get_tree()).load_level("round_3")

## Quits the game.
func quit() -> void:
	get_tree().quit()

func _ready() -> void:
	var start_text = %Start.text
	# This code removes the quit option when targeting the web and
	# makes the text say "press enter to start" instead of just "start"
	if OS.get_name() == "Web":
		if not quit_removed:
			var prv_neig = %Quit.get_node(%Quit.focus_previous)
			var nxt_neig = %Quit.get_node(%Quit.focus_next)
			nxt_neig.focus_neighbor_top = %Quit.focus_previous
			nxt_neig.focus_previous = %Quit.focus_previous
			prv_neig.focus_neighbor_bottom = %Quit.focus_next
			prv_neig.focus_next = %Quit.focus_next
			# NOTE: we don't use queue_free here, because
			# we load this menu when the level starts and
			# if we wait with the deletion to the end of
			# the frame, it will create noticable lag at
			# the start of the level.
			%Quit.free()
			quit_removed = true
		start_text = "press enter to start"
		%Start.text = start_text
	# Defining the basic menu behavior.
	_options = {
		start_text: start,
		"quit": quit
	}
	_focus_first = %Start
	super()
	# There's a weird bug where the text changes color only when we first enter
	# the title screen on web, so here we make sure the color is always the same.
	if OS.get_name() == "Web":
		%Start.remove_theme_color_override("font_color")
