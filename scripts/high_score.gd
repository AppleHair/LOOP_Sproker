class_name HighScore
extends Label

var base:String = "High Score: "

func _enter_tree() -> void:
	text = base + str(ProjectSettings.get_setting("global/high_score") as int)
