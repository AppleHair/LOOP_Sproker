class_name RoomBase
extends Node2D
## The base class for all the rooms in the game.
##
## Includes the room bound node with no coliision shape,
## so that other rooms would be able to put their own shape.
## Also includes a default script with default room behaviors.

## The current room which is inside the scene tree.
static var current_room: RoomBase
# ## Used to help the player camera predict the first
# ## camera limits that should be enforced on it when
# ## it enters the room.
# @export_node_path("CameraLimiter") var start_h_limit: NodePath
# ## Used to help the player camera predict the first
# ## camera limits that should be enforced on it when
# ## it enters the room.
# @export_node_path("CameraLimiter") var start_v_limit: NodePath
## A reference to the PlayerSpawn node
## which is included in in every room
@onready var player_spawn: Marker2D = $PlayerSpawn

@export var next_round: String = ""

var score_gain:int = 0

## [b]IF YOU OVERRIDE THIS METHOD, YOU MUST ADD [/b]
## [code]super()[/code][b] TO THE END OF THE FUNCTION!!![/b]
func _enter_tree() -> void:
	current_room = self

func _process(_delta) -> void:
	if $Kills.get_child_count() != 0:
		return
	get_tree().paused = true
	Game.get_game(get_tree()).score += score_gain
	GUI.get_gui(get_tree()).switch_menu("menu_finish_round")

# NOTE: The reason why I don't just calculate
# bound_rect on _ready is because at that point,
# the shape of BoundShape is always empty.
# (even on inherited scenes which add a shape to BoundShape)
## After the function below calculates the
## rectangle that bounds the room for the
## first time, we store it in this variable
## and use it for future calls, so we won't
## have to do the same calculation again.
var _bound_rect_cache
## Returns the rectangle that bounds
## the room in global positioning
func get_bound_rect() -> Rect2:
	if _bound_rect_cache != null:
		return _bound_rect_cache
	_bound_rect_cache = (
			$Bound/BoundShape.shape.get_rect() 
			* $Bound/BoundShape.global_transform.inverse()
	)
	return _bound_rect_cache

## Calls the out_of_bounds function
## when a spray or wasp gets out of the bounds of the room.
func _on_bound_area_exited(area: Area2D) -> void:
	if (
			area.owner is Spray or
			area.owner is Wasp or
			area.owner is Trash or
			area.owner is Worm
	):
		area.owner.out_of_bounds()
