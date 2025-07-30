class_name ReplaySystem
extends Node
## Lets you record and replay the player's inputs in the game.
##
## This was made for making demo footage for the title screen.
## 
## NOTE: Using [method Input.is_just_pressed] or [method Input.is_just_released] can
## let the player interupt the replay, so the usage of these functions should be avoided.

## Defines the states the replay system can be in.
enum State { STOP, RECORD, PLAY }
## Stores the replay system's current state, defined by [State].
var state: State = State.STOP:
	set(value):
		state = value
		if state == State.RECORD:
			print("recording started...")
			recorded_inputs.clear()
			current_time = 0.0
			return
		if state == State.PLAY:
			print("playing recording...")
			replay_index = 0
			current_time = 0.0
			return
		print("replay system stopped.")
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
	for action in ["run_left", "run_right", "jump", "action_up", "action_down"]:
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

## Saves the [member recorded_inputs] array in a [JSON]
## file in user://[param filename].json.
func save_replay(filename: String):
	var file = FileAccess.open("user://" + filename + ".json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(recorded_inputs))
		file.close()
		print("Replay saved to: ", filename)
	else:
		print("Failed to save replay")

## Loads recorded inputs from a [JSON] file
## in user://[param filename].json into the
## [member recorded_inputs] array.
## @deprecated: Generally unused. Just keeping it here if I ever need it I guess...
func load_replay(filename: String):
	var file = FileAccess.open("user://" + filename + ".json", FileAccess.READ)
	if file:
		recorded_inputs = JSON.parse_string(file.get_as_text())
		file.close()
		print("Replay loaded from: ", filename)
	else:
		print("Failed to load replay")

func _ready() -> void:
	# Just to make sure the simulated inputs override the
	# real inputs by the time the player script checks them.
	process_physics_priority = -1

func _physics_process(delta):
	current_time += delta
	if state == State.RECORD:
		record_inputs()
		return
	if state == State.PLAY:
		play_inputs()

func _input(event):
	if state == State.STOP:
		if event.is_action_pressed("replay_record"):
			state = State.RECORD
			return
		if event.is_action_pressed("replay_play"):
			state = State.PLAY
		return
	if state == State.RECORD and event.is_action_pressed("replay_stop"):
		state = State.STOP
		# No reason to save these on Web.
		if not OS.get_name() == "Web":
			save_replay("replay_demo")
		return
	if state == State.PLAY and event.is_action_pressed("replay_stop"):
		state = State.STOP
