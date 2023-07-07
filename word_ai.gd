# based on https://github.com/charlescapps/ProScrabble (MIT license)
extends Node


var BINGO_BONUS = 50
var BOARD_SIZE = 15
var BOARD_END = BOARD_SIZE - 1

var DIR_EAST = 0
var DIR_SOUTH = 1

var SQ_NORMAL = 5
var SQ_DL = 6
var SQ_TL = 7
var SQ_DW = 9
var SQ_TW = 13


var board = create_proto_board()
var tableau = create_2d_array(BOARD_SIZE, BOARD_SIZE, 0) # tableau is tiles on board; 0 is empty, 1 is unplayed wildcard, uppercase ASCII codes for letters, lowercase for played wildcards


func _ready():
	pass # Replace with function body.


func letter_mult(square):
	return square % 4


func word_mult(square):
	return square >> 4


func score_perpendicular(x, y, orig_dir, letter):
	if orig_dir == DIR_SOUTH:
		if (x == 0 or tableau[y][x-1] == 0) and (x == BOARD_END or tableau[y][x+1] == 0):
			return 0
		var xx = x
		while xx != 0 and tableau[y][xx-1] != 0:
			xx -= 1
		var start = xx
		var word = []
		word.append(letter if xx == x else tableau[y][xx])
		while xx != BOARD_END and tableau[y][xx+1] != 0:
			xx += 1
			word.append(letter if xx == x else tableau[y][xx])
		return score_one_word(start, y, DIR_EAST, word)
	else:
		if (y == 0 or tableau[y-1][x] == 0) and (y == BOARD_END or tableau[y+1][x] == 0):
			return 0
		var yy = y
		while yy != 0 and tableau[yy-1][x] != 0:
			yy -= 1
		var start = yy
		var word = []
		word.append(letter if yy == y else tableau[yy][x])
		while yy != BOARD_END and tableau[yy+1][x] != 0:
			yy += 1
			word.append(letter if yy == y else tableau[yy][x])
		return score_one_word(x, start, DIR_SOUTH, word)


# does not test validity; word should be a int array or PackedByteArray
func score_move(x, y, dir, word):
	var result = score_one_word(x, y, dir, word)
	var tiles_used = 0

	if dir == DIR_SOUTH:
		for i in word.size():
			if (tableau[y+i][x] == 0):
				result += score_perpendicular(x, y + i, dir, word[i])
				tiles_used += 1
	else:
		for i in word.size():
			if (tableau[y][x+i] == 0):
				result += score_perpendicular(x, y + i, dir, word[i])
				tiles_used += 1

	if tiles_used == 7:
		result += BINGO_BONUS
	return result


# word should be a int array or PackedByteArray
func score_one_word(x, y, dir, word):
	var result = 0
	var mult = 1
	var tiles_index = 0

	if dir == DIR_SOUTH:
		for i in word.size():
			if (tableau[y+i][x] == 0):
				result += letter_value(word[i]) * letter_mult(board[y+i][x])
				mult *= word_mult(board[y+i][x])
			else:
				result += letter_value(word[i])
	else:
		for i in word.length():
			if (tableau[y][x+i] == 0):
				result += letter_value(word[i]) * letter_mult(board[y][x+i])
				mult *= word_mult(board[y][x+i])
			else:
				result += letter_value(word[i])
	
	return result * mult


func letter_value(letter):
	match letter:
		65, 69, 73, 78, 79, 82, 83, 84:
			return 1
		68, 76, 85:
			return 2
		67, 71, 72, 77:
			return 3
		66, 70, 80, 87, 89:
			return 4
		75, 86:
			return 5
		74:
			return 8
		88:
			return 9
		81, 90:
			return 10
		_:
			return 0


func create_proto_board():
	var result = create_2d_array(BOARD_SIZE, BOARD_SIZE, 0)
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
