class_name Worm
extends Node2D

enum State {
	TURNING,
	FREE
}

var state:State = State.TURNING

const POS_LEFT:float = 48
const POS_RIGHT:float = 176
@export_range(1,6) var turn_amount:int = 1
@export_range(-1,1,2) var direction_x:int = 1

const SPEED_X:float = 60

func _ready() -> void:
	$AnimatedSprite2D.flip_h = direction_x == 1
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	position.x += SPEED_X * direction_x * delta
	if state == State.FREE:
		return
	match direction_x:
		1:
			if position.x >= POS_RIGHT:
				direction_x = -1
				turn_amount -= 1
		-1:
			if position.x <= POS_LEFT:
				direction_x = 1
				turn_amount -= 1
	if turn_amount == 0:
		state = State.FREE
	$AnimatedSprite2D.flip_h = direction_x == 1

func out_of_bounds() -> void:
	queue_free()
