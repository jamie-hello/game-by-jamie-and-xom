extends Node2D

var clicked = false


func _ready():
	pass 


func _process(delta):
	if clicked:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
	pass


func _on_clickbox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		clicked = true
		pass

func _input(event):
	if event is InputEventMouse:
		if event.button_mask == 0 and clicked:
			clicked = false
