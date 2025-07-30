class_name MenuBase
extends Control
## The base class for all the menus in the game.
##
## Implements basic menu behavior and adds properties,
## which help make menu behavior more uniform across all
## menus in the game.

## The current menu which is inside the scene tree.
static var current_menu: MenuBase
## Used for making a uniform way of selecting an option on all menus.
var selected_option:String = ""
## Used for helping menus go back to the menu they came from
## The string is a key to the [member GUI.menus] dictionary, which is
## used for switching menus with the [method GUI.switch_menu] method.
var prv_menu: String = ""

## Contains [Callable]s for the different
## options that can be selected in the menu.
## The [StringName] keys need to be the texts
## the options contain.
var _options: Dictionary[StringName, Callable]
## Contains absolute [NodePath]s for values
## which are associated with the options that
## can be selected in this menu. The [StringName]
## keys need to be the texts the options contain.
## These will be used by the [MenuLabel]s which should
## appear next to the relevant options and display
## the value which they change and are associated with,
## so make sure you use [method Node._enter_tree] to set this property
## when you inherit this class, because if you set it
## on [method Node._ready], the label will only see and empty dictionary.
var labels: Dictionary[StringName, NodePath]
## A [Callable] which gets called when the
## [code]ui_cancel[/code] button gets pressed on the menu.
var _on_cancel: Callable
## The first [Control] node that will get
## focus when this menu enters the [SceneTree].
var _focus_first: Control

## Switches back to the menu
## where this menu was entered from.
func back() -> void:
	GUI.get_gui(get_tree()).switch_menu(prv_menu)

## [b]IF YOU OVERRIDE THIS METHOD, YOU MUST ADD [/b]
## [code]super()[/code][b] TO THE END OF THE FUNCTION!!![/b]
func _enter_tree() -> void:
	current_menu = self

## [b]IF YOU OVERRIDE THIS METHOD, YOU MUST ADD [/b]
## [code]super()[/code][b] TO THE END OF THE FUNCTION!!![/b]
func _ready() -> void:
	# Give focus to _focus_first if possible.
	if _focus_first != null:
		_focus_first.grab_focus()

## [b]IF YOU OVERRIDE THIS METHOD, YOU MUST ADD [/b]
## [code]super(delta)[/code][b] TO THE END OF THE FUNCTION!!![/b]
func _process(_delta: float) -> void:
	# Handles menu canceling behavior.
	if Input.is_action_just_pressed("ui_cancel") and _on_cancel.is_valid():
		_on_cancel.call()
		return
	# Handles option selection behavior.
	if Input.is_action_just_pressed("ui_accept") and not _options.is_empty():
		if selected_option in _options:
			_options[selected_option].call()

## Overriding this method will make echo inputs
## allowed if you don't call [code]super(event)[/code].
func _input(event: InputEvent) -> void:
	# Cancels echo inputs, because they are
	# way too fast and don't fit a video game GUI.
	if event.is_echo():
		get_tree().root.set_input_as_handled()
