extends Node2D

var clicked = false
var rest_point = self.get_transform().get_origin()
var rest_nodes = []


func _ready():
	rest_nodes = get_tree().get_nodes_in_group("restzone")


func _process(delta):
	if clicked:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
	else:
		global_position = lerp(global_position, rest_point, 25*delta)


func _on_clickbox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		clicked = true
		pass

func _input(event):
	if event is InputEventMouse:
		if event.button_mask == 0 and clicked:
			clicked = false
			var shortest_dist = 35
			var foundRestPoint = false
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist:
					foundRestPoint = true
					rest_point = child.global_position
					shortest_dist = distance
			if !foundRestPoint:
				rest_point = get_global_mouse_position()
