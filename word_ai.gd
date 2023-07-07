extends Node


var board = create_proto_board()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_proto_board():
	var result = create_2d_array(15, 15, 0)
	result[7][7] = 1 # figure out mask values later
	return result


func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a
