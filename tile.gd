extends Node2D


var clicked = false
var rest_point = Vector2.ZERO
var rest_nodes = []
var Letter = ""
var card = null


@onready var LetterTexture = $Sprite2D
var blank = preload("res://img/blank.png")


var dealtalready = false


func _ready():
	rest_nodes = get_tree().get_nodes_in_group("restzone")
	rest_point = self.get_position()
	#LetterTexture.set_texture()


func drawn_by_player():
	dealtalready = true


func set_letter(lettervalue):
	Letter = lettervalue
	$Sprite2D.set_texture(blank)


func _process(delta):
	if clicked:
		#global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		if dealtalready or $"../PhaseSingleton".active_step != $"../PhaseSingleton".STEP_DEALING:
			clicked = false
		else:
			var whoseturn = get_parent().get_node("PhaseSingleton").active_player
			if whoseturn != null:
				if null in whoseturn.rack:
					get_parent().deal_tile(whoseturn, self)
	else:
		global_position = lerp(global_position, rest_point, 25*delta)
		pass


func _on_clickbox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		clicked = true
		pass
