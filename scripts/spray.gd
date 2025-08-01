class_name Spray
extends Node2D

const EXPAND_TIME = 0.15
const SPEED:float = 240.0

var wasps_killed:int = 0

var expand_timer = EXPAND_TIME
@onready var tile_map:TileMapLayer = $TileMapLayer
@onready var colli:CollisionShape2D = $Area2D/CollisionShape2D
	
func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta
	expand_timer -= delta
	if expand_timer <= 0.0:
		resize_spray(1)
		expand_timer = EXPAND_TIME

func resize_spray(change: int) -> void:
	if change == 0:
		return
	if colli.scale.x + (change as float) <= 0.0:
		destroy()
		return
	colli.scale.x += change
	@warning_ignore("narrowing_conversion")
	var new_scale:int = colli.scale.x
	for i in range(new_scale-change,new_scale+sign(change),sign(change)):
		var left_coord = Vector2i(-i,-1)
		var right_coord = Vector2i(i-1,-1)
		if i == new_scale:
			tile_map.set_cell(right_coord,0,Vector2i(2,0))
			tile_map.set_cell(left_coord,0,Vector2i(0,0))
			break
		match sign(change):
			1:
				var middle_atlas = Vector2i(1,0)
				tile_map.set_cell(right_coord,0,middle_atlas)
				tile_map.set_cell(left_coord,0,middle_atlas)
			-1:
				tile_map.erase_cell(right_coord)
				tile_map.erase_cell(left_coord)

func out_of_bounds() -> void:
	destroy()

func destroy() -> void:
	queue_free()
