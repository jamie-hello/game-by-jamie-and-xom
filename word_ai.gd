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
var word_dict = {}


func _ready():
	var f = FileAccess.open("res://CSW22.txt", FileAccess.READ)
	while not f.eof_reached():
		var word = f.get_line()
		if word == "":
			break
		var alpha = alphabetize(word)
		if word_dict.has(alpha):
			word_dict[alpha].append(word)
		else:
			word_dict[alpha] = [word]
	f.close()
#	pass # Replace with function body.
#	var hand = PackedByteArray()
#	for i in range(7):
#		hand.append(65 + (randi() % 26))
#	hand[0] = 1
#	print(hand.get_string_from_ascii())
#	get_best_first_move(hand)


func letter_mult(square):
	return square % 4


func word_mult(square):
	return square >> 2


func alphabetize(word):
	var ascii = word.to_ascii_buffer()
	ascii.sort()
	return ascii.get_string_from_ascii()


# s should be all caps
func get_anagrams(s):
	var alpha = alphabetize(s)
	if not word_dict.has(alpha):
		return []
	return word_dict[alpha]


# hand should be a int array or PackedByteArray; assume reflective symmetry and only consider DIR_EAST
func get_best_first_move(hand):
	var best_moves = []
	var best_score = -1
	var substr_by_len = generate_substrings(hand)
	for len in range(1, 8):
		for s in substr_by_len[len - 1]:
			var matches = get_anagrams(s.get_string_from_ascii().to_upper())
			for m in matches:
				var word = assign_wildcards(hand, m)
				for offset in range(0, len):
					var score = score_move(7 - offset, 7, DIR_EAST, word)
					if score == best_score:
						best_moves.append([7 - offset, 7, DIR_EAST, word, score])
					elif score > best_score:
						best_score = score
						best_moves = [[7 - offset, 7, DIR_EAST, word, score]]
	
	if best_moves.is_empty():
		return null
	return best_moves.pick_random()




# currently does not check that hand actually contains wildcards; m should be an uppercase string
func assign_wildcards(hand, m):
	var result = m.to_ascii_buffer()
	var h = hand.duplicate()
	for i in range(result.size()):
		var pos = h.find(result[i])
		if pos == -1:
			result[i] += 32 # to lower case
		else:
			h.remove_at(pos)
	return result


# "strings" is a misnomer; hand must be a PackedByteArray!
func generate_substrings(hand):
	var d = {}
	d[""] = PackedByteArray()
	for c in hand:
		var keys = d.keys()
		if c == 1:
			for cc in range(97, 123): # (a, z + 1)
				for k in keys:
					var new_value = d[k].duplicate()
					new_value.append(cc)
					new_value.sort()
					d[new_value.get_string_from_ascii()] = new_value
		else:
			for k in keys:
				var new_value = d[k].duplicate()
				new_value.append(c)
				new_value.sort()
				d[new_value.get_string_from_ascii()] = new_value
	var substr_by_len = []
	for tile in hand:
		substr_by_len.append([])
	for v in d.values():
		substr_by_len[v.size() - 1].append(v)
	return substr_by_len


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
		for i in word.size():
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
	var result = create_2d_array(BOARD_SIZE, BOARD_SIZE, SQ_NORMAL)
	result[0][0] = SQ_TW
	result[0][7] = SQ_TW
	result[0][14] = SQ_TW
	result[7][0] = SQ_TW
	result[7][14] = SQ_TW
	result[14][0] = SQ_TW
	result[14][7] = SQ_TW
	result[14][14] = SQ_TW
	
	result[1][2] = SQ_DW
	result[1][12] = SQ_DW
	result[2][1] = SQ_DW
	result[2][13] = SQ_DW
	result[3][4] = SQ_DW
	result[3][10] = SQ_DW
	result[4][3] = SQ_DW
	result[4][11] = SQ_DW
	result[10][3] = SQ_DW
	result[10][11] = SQ_DW
	result[11][4] = SQ_DW
	result[11][10] = SQ_DW
	result[12][1] = SQ_DW
	result[12][13] = SQ_DW
	result[13][2] = SQ_DW
	result[13][12] = SQ_DW
	
	result[1][6] = SQ_TL
	result[1][8] = SQ_TL
	result[2][5] = SQ_TL
	result[2][9] = SQ_TL
	result[5][2] = SQ_TL
	result[5][12] = SQ_TL
	result[6][1] = SQ_TL
	result[6][13] = SQ_TL
	result[8][1] = SQ_TL
	result[8][13] = SQ_TL
	result[9][2] = SQ_TL
	result[9][12] = SQ_TL
	result[12][5] = SQ_TL
	result[12][9] = SQ_TL
	result[13][6] = SQ_TL
	result[13][8] = SQ_TL
	
	result[0][3] = SQ_DL
	result[0][11] = SQ_DL
	result[3][0] = SQ_DL
	result[3][14] = SQ_DL
	result[4][7] = SQ_DL
	result[5][6] = SQ_DL
	result[5][8] = SQ_DL
	result[6][5] = SQ_DL
	result[6][9] = SQ_DL
	result[7][4] = SQ_DL
	result[7][10] = SQ_DL
	result[8][5] = SQ_DL
	result[8][9] = SQ_DL
	result[9][6] = SQ_DL
	result[9][8] = SQ_DL
	result[10][7] = SQ_DL
	result[11][0] = SQ_DL
	result[11][14] = SQ_DL
	result[14][3] = SQ_DL
	result[14][11] = SQ_DL
	return result


func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a
