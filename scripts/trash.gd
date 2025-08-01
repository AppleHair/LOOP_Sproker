class_name Trash
extends Node2D

enum State {
	ENTERING,
	LANDING
}

@export_range(0,2,1) var frame:int = 0
var state:State = State.ENTERING

func _ready() -> void:
	$AnimatedSprite2D.frame = frame

#region ENTERING Vars
const ENTER_SPEED_Y:float = 30
#endregion

#region LANDING Vars
var velocity_y:float = 120
const ACC_LANDING:float = 700
#endregion

func _physics_process(delta: float) -> void:
	match state:
		State.ENTERING:
			position.y += ENTER_SPEED_Y * delta
			if position.y >= 56.0:
				state = State.LANDING
		State.LANDING:
			position.y += velocity_y * delta
			velocity_y += ACC_LANDING * delta

func out_of_bounds() -> void:
	queue_free()
