class_name ReplaySystem
extends Node
## Lets you record and replay the player's inputs in the game.
##
## This was made for making demo footage for the title screen.
## 
## NOTE: Using [method Input.is_just_pressed] or [method Input.is_just_released] can
## let the player interupt the replay, so the usage of these functions should be avoided.

## Defines the states the replay system can be in.
enum State { STOP, PLAY }
## Stores the replay system's current state, defined by [State].
var state: State = State.STOP:
	set(value):
		state = value
		if state == State.PLAY:
			replay_index = 0
			current_time = 0.0
			return
		if state == State.STOP:
			for action in ["run_left", "run_right", "jump", "shoot"]:
				Input.action_release(action)
## This array contains [Dictionary]s with input times and action names.
var recorded_inputs: Array = preload("res://replays/replay_demo.json").data
## The replay's current time.
var current_time: float = 0.0
## The index for the current input that is waited for in the [member recorded_inputs] array.
var replay_index: int = 0

## This function records the player's inputs
## to the [member recorded_inputs] array.
func record_inputs():
	# Get the current time and put
	# it in a input event dictionary.
	var input_event = {
		"time": current_time,
		"actions": {}
	}
	# Capture the relevant input actions.
	for action in ["run_left", "run_right", "jump", "shoot"]:
		input_event.actions[action] = Input.is_action_pressed(action)
	recorded_inputs.append(input_event)

## This function plays the recorded inputs
## from the [member recorded_inputs] array. 
func play_inputs():
	if replay_index >= recorded_inputs.size():
		# Stop when replay is done
		state = State.STOP
		return
	# Get the next recorded input and simulate
	# it's actions if the time is right.
	var event = recorded_inputs[replay_index]
	if current_time >= event.time:
		for action in event.actions:
			if event.actions[action]:
				Input.action_press(action)
				continue
			Input.action_release(action)
		replay_index += 1

func _physics_process(delta):
	current_time += delta
	if state == State.PLAY:
		play_inputs()
