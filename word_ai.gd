extends Node


var SQ_NORMAL = 5
var SQ_DL = 6
var SQ_TL = 7
var SQ_DW = 9
var SQ_TW = 13


var board = create_proto_board()


func _ready():
	pass # Replace with function body.


func letter_mult(square):
	return square % 4


func word_mult(square):
	return square >> 4


func create_proto_board():
	var result = create_2d_array(15, 15, 0)
	result[1][2] = SQ_DL
	result[1][12] = SQ_DL
	result[2][1] = SQ_DL
	result[2][4] = SQ_DL
	result[2][10] = SQ_DL
	result[2][13] = SQ_DL
	result[4][2] = SQ_DL
	result[4][6] = SQ_DL
	result[4][8] = SQ_DL
	result[4][12] = SQ_DL
	result[6][4] = SQ_DL
	result[6][10] = SQ_DL
	result[8][4] = SQ_DL
	result[8][10] = SQ_DL
	result[10][2] = SQ_DL
	result[10][6] = SQ_DL
	result[10][8] = SQ_DL
	result[10][12] = SQ_DL
	result[12][1] = SQ_DL
	result[12][4] = SQ_DL
	result[12][10] = SQ_DL
	result[12][13] = SQ_DL
	result[13][2] = SQ_DL
	result[13][12] = SQ_DL

	result[0][6] = SQ_TL
	result[0][8] = SQ_TL
	result[3][3] = SQ_TL
	result[3][11] = SQ_TL
	result[5][5] = SQ_TL
	result[5][9] = SQ_TL
	result[6][0] = SQ_TL
	result[6][14] = SQ_TL
	result[8][0] = SQ_TL
	result[8][14] = SQ_TL
	result[9][5] = SQ_TL
	result[9][9] = SQ_TL
	result[11][3] = SQ_TL
	result[11][11] = SQ_TL
	result[14][6] = SQ_TL
	result[14][8] = SQ_TL

	result[1][5] = SQ_DW
	result[1][9] = SQ_DW
	result[3][7] = SQ_DW
	result[5][1] = SQ_DW
	result[5][13] = SQ_DW
	result[7][3] = SQ_DW
	result[7][11] = SQ_DW
	result[9][1] = SQ_DW
	result[9][13] = SQ_DW
	result[11][7] = SQ_DW
	result[13][5] = SQ_DW
	result[13][9] = SQ_DW

	result[0][4] = SQ_TW
	result[0][10] = SQ_TW
	result[4][0] = SQ_TW
	result[4][14] = SQ_TW
	result[10][0] = SQ_TW
	result[10][14] = SQ_TW
	result[14][4] = SQ_TW
	result[14][10] = SQ_TW
	return result


func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a
