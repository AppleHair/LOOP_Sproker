class_name GUI
extends CanvasLayer
## Manages all of the Graphical User Interfaces
## and Head-Up Displays in the game.
##
## Currently preloads all of the menus in the game
## and handles the process of switching between menus.

## find the [GUI] instance on a given [SceneTree]
static func get_gui(tree: SceneTree) -> GUI:
	return tree.root.get_node("Main/GUI") as GUI

## Contains all of the menus in the game.
## The keys are [StringName]s with the menus' file names
## ([b]without[/b] [code].tscn[/code]) and the values are instances of [RoomBase].
var menus: Dictionary[StringName, MenuBase] = {
	"menu_pause": preload("res://scenes/menus/menu_pause.tscn").instantiate(),
	"menu_title": preload("res://scenes/menus/menu_title.tscn").instantiate(),
	"menu_settings": preload("res://scenes/menus/menu_settings.tscn").instantiate(),
	"menu_pre_round": preload("res://scenes/menus/menu_pre_round.tscn").instantiate(),
	"menu_got_hit": preload("res://scenes/menus/menu_got_hit.tscn").instantiate(),
	"menu_finish_round": preload("res://scenes/menus/menu_finish_round.tscn").instantiate()
}

## Removes the current menu from the [SceneTree],
## and adds a new menu using the provided [param key].
func switch_menu(key: StringName) -> void:
	if not menus.has(key):
		return
	remove_child(MenuBase.current_menu)
	menus[key].request_ready()
	add_child(menus[key])

func _enter_tree() -> void:
	# The first menu is the title screen
	add_child(menus["menu_title"])
