class_name MenuLabel
extends Label
## A label which displays a value of a property which is associated with an option in a menu
##
## should be owned by a [MenuBase] and a direct child of a [MenuOption].
## The [member MenuBase.labels] dictionary will determine the [NodePath]
## that will be used to find this label's associated property.

## The array returned by the [method Node.get_node_and_resource] function
## for an absolute [NodePath] to this label's associated property.
var res_arr: Array
## The last value which was displayed by this label.
var last_value: Variant = null

## Gets the value from the provided path and updates the text if necessary.
func reset_value() -> void:
	if res_arr[0] == null:
		return
	var value = (res_arr[0] as Node).get_indexed(res_arr[2])
	if res_arr[1] != null:
		value = (res_arr[1] as Resource).get_indexed(res_arr[2])
	# CAUTION: I think the following line can raise errors
	# if the type of this value gets changed, but I'm not sure.
	if value == last_value:
		return
	last_value = value
	text = str(last_value)

func _ready() -> void:
	var option = get_parent()
	if owner is MenuBase and option is MenuOption:
		res_arr = get_node_and_resource((owner as MenuBase).labels[(option as MenuOption).text])
		reset_value()

func _process(_delta: float) -> void:
	reset_value()
