class_name Spray
extends Node2D

const EXPAND_TIME = 0.1
const SPEED:float = 240.0

var expand_timer = EXPAND_TIME
@onready var tile_map:TileMapLayer = $TileMapLayer
@onready var colli:CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta
	expand_timer -= delta
	if expand_timer <= 0.0:
		expand_spray()
		expand_timer = EXPAND_TIME

func expand_spray() -> void:
	colli.scale.x += 1.0
	@warning_ignore("narrowing_conversion")
	var new_scale:int = colli.scale.x
	for i in range(1,new_scale+1):
		if i == new_scale:
			tile_map.set_cell(Vector2i(i-1,-1),0,Vector2i(2,0))
			tile_map.set_cell(Vector2i(-i,-1),0,Vector2i(0,0))
			break
		tile_map.set_cell(Vector2i(i-1,-1),0,Vector2i(1,0))
		tile_map.set_cell(Vector2i(-i,-1),0,Vector2i(1,0))

func out_of_bounds() -> void:
	queue_free()
