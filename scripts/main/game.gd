class_name Game
extends Node2D
## Manages an instance of gameplay.
##
## Currently handles the loading and memory managment of rooms and levels,
## and moves the player from room to room.

## find the [Game] instance on a given [SceneTree]
static func get_game(tree: SceneTree) -> Game:
	return tree.root.get_node("Main/Game") as Game

@onready var score:int = 0

## The main player instance of the game.
var player: Player = preload("res://scenes/player.tscn").instantiate()
## The current level whose rooms are loaded into memory.
var current_level: StringName
# NOTE: Levels are defined by making a new folder
# in the "scenes/levels" directory and adding room
# scenes to it. the name of the level is the name of
# the folder created.
## Contains all of the currently loaded rooms.
## The keys are [StringName]s with the rooms' file names
## ([b]without[/b] [code].tscn[/code]) and the values are instances of [RoomBase].
var rooms: Dictionary[StringName, RoomBase] = {}

## Contains the names of the rooms which were requested to
## load on a seperate thread ([b]with[/b] [code].tscn[/code]).
var rooms_to_load: Array[StringName] = []

## Spawns the player inside the current room.
## if [param init_pos] isn't provided, will spawn the player
## in the default player spawn position of the room.
func spawn_player_in_room(init_pos: Vector2 = Vector2.INF) -> void:
	# uses the player_spawn position by default.
	player.position = RoomBase.current_room.player_spawn.position
	# if init_pos is provided, use that instead.
	if init_pos != Vector2.INF:
		player.position = init_pos
	# Regardless, add the player as a sibling of player_spawn
	RoomBase.current_room.player_spawn.add_sibling(player)

## Adds a room from the current level to the [SceneTree] and spawns
## the player in it. The room is added using the provided [param key].
func add_room(key: StringName, init_pos: Vector2 = Vector2.INF) -> void:
	add_child(rooms[key])
	spawn_player_in_room(init_pos)

## Removes the player and the current room from the
## [SceneTree] if they exist and are in the [SceneTree].
func remove_current_room() -> void:
	if RoomBase.current_room == null:
		return
	if not RoomBase.current_room.is_inside_tree():
		return
	if player.is_inside_tree():
		# NOTE: The player should always be a child of the current room.
		RoomBase.current_room.remove_child(player)
	# NOTE: The current room should always be a child of the Game node.
	remove_child(RoomBase.current_room)

## Removes the player and the current room from the [SceneTree],
## and adds a new room using the provided [param key].
func switch_room(key: StringName, init_pos: Vector2 = Vector2.INF) -> void:
	remove_current_room()
	add_room(key, init_pos)

## Switches to the next room in the level
## in the order the rooms were loaded into memory.
func next_room() -> void:
	if rooms.is_empty():
		return
	switch_room(rooms.keys()[(rooms.keys().find(rooms.find_key(RoomBase.current_room)) + 1) % rooms.size()])

## Loads all of the rooms in the current level into memory.
func load_level(level: StringName) -> void:
	rooms.clear()
	current_level = level
	remove_current_room()
	for res_string in ResourceLoader.list_directory("res://scenes/levels/"+current_level):
		ResourceLoader.load_threaded_request("res://scenes/levels/"+current_level+"/"+res_string)
		rooms_to_load.push_back(res_string)
		#rooms[res_string.left(-5)] = load("res://scenes/levels/"+current_level+"/"+res_string).instantiate()

## Gets called when the game finishes loading
## all of the rooms in the level into memory
## as a result of a call to [method load_level].
func _level_loaded() -> void:
	add_room(rooms.keys()[0])
	GUI.get_gui(get_tree()).switch_menu("menu_pre_round")

func _process(_delta: float) -> void:
	if not rooms_to_load.is_empty():
		# TODO: Add loading screen while the level is loading
		#region Multi-threaded level loading
		for room in rooms_to_load:
			var path = "res://scenes/levels/"+current_level+"/"+room
			if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				rooms[room.left(-5)] = ResourceLoader.load_threaded_get(path).instantiate()
				continue
			if (ResourceLoader.load_threaded_get_status(path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
					or ResourceLoader.load_threaded_get_status(path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE):
				print("Something went wrong when loading "+room+" in game.gd on a seperate thread.")
				continue
			return
		rooms_to_load.clear()
		_level_loaded()
		#endregion
		return
	# Pressing the pause button will cause the
	# tree to pause, which will deactivate this node
	# and it's children and activate the pause menu
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
