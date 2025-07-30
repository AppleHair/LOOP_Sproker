class_name MenuOption
extends Label
## An option which can be selected in a [MenuBase] instance.
##
## This node modifies the [member MenuBase.selected_option] attribute
## of its [MenuBase] owner to change the selected option when it gains focus.

## The color the option will appear in when it has focus.
@export_color_no_alpha var focus_color: Color = Color.WHITE

func _on_focus_entered() -> void:
	# If the option is inside a menu,
	# it will become the selected option
	# when it gets focus.
	if owner is MenuBase:
		(owner as MenuBase).selected_option = text
	# Gives the option its focus color.
	add_theme_color_override("font_color", focus_color)

func _on_focus_exited() -> void:
	# Removes the focus color from the option when it loses focus.
	remove_theme_color_override("font_color")
