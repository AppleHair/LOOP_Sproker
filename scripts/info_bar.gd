class_name InfoBar
extends Control

@onready var score_base: String = $Score.text
@onready var round_base: String = $Round.text

var score_follow:int = 0
var round_follow:StringName

func _ready() -> void:
	score_follow = Game.get_game(get_tree()).score
	round_follow = Game.get_game(get_tree()).current_level
	$Score.text = score_base + str(score_follow)

func _process(_delta: float) -> void:
	var game = Game.get_game(get_tree())
	if game.replay:
		visible = false
		return
	visible = true
	if game.current_level != round_follow:
		round_follow = game.current_level
		$Round.text = round_base + str(round_follow)[-1]
	if game.score != score_follow:
		score_follow = game.score
		$Score.text = score_base + str(score_follow)
