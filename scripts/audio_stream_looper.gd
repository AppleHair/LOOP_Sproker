class_name AudioStreamLooper
extends AudioStreamPlayer
## An [AudioStreamPlayer] that has functionality for handling looping of audio streams.
##
## To start a loop you should call [method start_loop] with an [AudioStream] as
## an argument and when you want to stop the loop you just call [method stop_loop].
## You can also call this method on [method Node._process] and it'll still work fine.

## Tracks if the sound is looping or not.
var _loop_sound = false

## Starts the sound loop.
func start_loop(stream_tl: AudioStream) -> void:
	if _loop_sound and stream == stream_tl:
		return
	stream = stream_tl
	_loop_sound = true
	play()

## Stops the sound loop.
func stop_loop() -> void:
	if not _loop_sound:
		return
	_loop_sound = false
	stop()

func _ready() -> void:
	connect("finished", _on_finished)

func _on_finished() -> void:
	if _loop_sound:
		play()
