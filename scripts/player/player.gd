class_name Player
extends CharacterBody2D

## Used to define which states the player can be in.
enum PlayerState {
	NORMAL,
	CUTSCENE
}

var spray_res: PackedScene = preload("res://scenes/spray/spray.tscn")

## The player's current movement state.
var state:PlayerState = PlayerState.NORMAL:
	set(value):
		match value:
			PlayerState.NORMAL:
				pass
		state = value

## The position of the player when it enters the room.
var init_pos:Vector2

#region Normal State Variables
const SHOOT_COOLDOWN_TIME:float = 0.5
## The player's running speed.
const SPEED:float = 90
## The velocity given to the player when he jumps.
const JUMP_VELOCITY:float = -270
## The gravity which influences the player's jump.
var local_gravity = Vector2(0.0, 1400.0)# original gravity
var shoot_timer:float = 0.0
#endregion

func _enter_tree() -> void:
	init_pos = position
	state = PlayerState.NORMAL

func _physics_process(delta: float) -> void:
	match state:
		PlayerState.NORMAL:
			if shoot_timer > 0.0:
				# if not Input.is_action_pressed("shoot"):
				# 	shoot_timer = 0.0
				shoot_timer -= delta
			# Add the gravity.
			if not is_on_floor():
				# run_sfx_player.stop_loop()
				# This will make the player play the land
				# sound effect when he lands on the ground again
				# if not jump_land_sfx_player.playing:
				# 	jump_sfx_player.stream = null
				velocity += local_gravity * delta

			# Handle jump.
			if is_on_floor():
				# if velocity.x != 0:
				#	run_sfx_player.start_loop(sound_effects["run"])
				if Input.is_action_pressed("jump"):
					velocity.y = JUMP_VELOCITY
					# Play the jump sound effect
					# jump_sfx_player.stream = sound_effects["jump"]
					# jump_sfx_player.play()

			# Get the input direction and handle the movement.
			velocity.x = Input.get_axis("run_left", "run_right") * SPEED
			move_and_slide()
			if Input.is_action_pressed("shoot") and shoot_timer <= 0.0:
				var spray = spray_res.instantiate()
				get_parent().add_child(spray)
				spray.position = global_position
				spray.position.y -= 16
				shoot_timer = SHOOT_COOLDOWN_TIME
