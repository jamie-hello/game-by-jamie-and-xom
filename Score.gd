extends Control

@onready var CurrentScore = $CurrentScore

func _process(delta):
	CurrentScore.set_text("Score:\n  " + str(get_parent().score))
	pass
