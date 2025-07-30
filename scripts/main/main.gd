class_name Main
extends Node
## Handles miscellaneous tasks related to the game's application.
##
## Currently handles window management and settings related stuff.

@onready var last_mode: Window.Mode = get_tree().root.mode

var viewport_size = Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
)

## This attribute represents the scale of the game's
## window from it's original viewport size. It's also
## used to change the game window's startup size in the settings.
## This value is not relevant to non-PC platforms.
@warning_ignore("integer_division")
var window_mult: int = (
		(ProjectSettings.get_setting("display/window/size/window_width_override") as int) /
		(ProjectSettings.get_setting("display/window/size/viewport_width") as int)
):
	set(value):
		window_mult = value
		if (OS.get_name() == "Web" or
			OS.get_name() == "IOS" or
			OS.get_name() == "Android"):
			return
		ProjectSettings.set_setting(
			"display/window/size/window_width_override",
			viewport_size.x * value
		)
		ProjectSettings.set_setting(
			"display/window/size/window_height_override",
			viewport_size.y * value
		)
		# override.cfg is used for overriding the
		# project settings on the exported game and
		# when testing in the editor. Will be saved
		# next to the project file / game executable.
		ProjectSettings.save_custom("override.cfg")

## Calculates the maximum integer scale the window
## can be in without touching the edges of the screen.
func window_mult_max() -> int:
	var pw:float = DisplayServer.screen_get_size().x
	var ph:float = DisplayServer.screen_get_size().y
	var cw:float = viewport_size.x
	var ch:float = viewport_size.y
	if (pw / ph) > (cw / ch):
		return floori(ph / ch)
	return floori(pw / cw)

## Resets the window's size to the startup size and
## puts the window in the center of the screen.
func reset_window() -> void:
	if (OS.get_name() == "Web" or
		OS.get_name() == "IOS" or
		OS.get_name() == "Android" or
		get_tree().root.mode == Window.MODE_EXCLUSIVE_FULLSCREEN or
		get_tree().root.is_embedded() or
		Engine.is_embedded_in_editor()):
		return
	get_tree().root.size = viewport_size * window_mult
	get_tree().root.move_to_center()

func _ready() -> void:
	get_tree().paused = true

func _process(_delta: float) -> void:
	# Handles fullscreen toggle.
	if Input.is_action_just_pressed("fullscreen"):
		if get_tree().root.mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_tree().root.mode = last_mode
			return
		last_mode = get_tree().root.mode
		get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
