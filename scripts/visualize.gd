class_name Visualize
extends Control

@onready var actions:Dictionary = {
	"run_left": $WalkLeft,
	"run_right": $WalkRight,
	"jump": $Jump,
	"shoot": $Shoot
}

func _physics_process(_delta: float) -> void:
	for action in actions.keys():
		if Input.is_action_pressed(action):
			actions[action].frame = 1
			continue
		actions[action].frame = 0
