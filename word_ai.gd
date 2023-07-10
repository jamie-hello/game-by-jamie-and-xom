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
#	print(get_best_first_move(hand))


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
	var substr_by_len = generate_substrings(hand)
	var best_moves = []
	var best_score = -1
	for len in range(1, 8):
		for s in substr_by_len[len - 1]:
			var matches = get_anagrams(s.get_string_from_ascii().to_upper())
			for m in matches:
				var word = assign_wildcards(hand, m)
				if word == null:
					continue
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


# hand should be a int array or PackedByteArray
func get_best_move(hand):
	if tableau[7][7] == 0:
		return get_best_first_move(hand)
	var substr_by_len = generate_substrings(hand)
	var best_moves = []
	var best_score = -1
	var searched = [create_2d_array(BOARD_SIZE, BOARD_SIZE, false), create_2d_array(BOARD_SIZE, BOARD_SIZE, false)] # E, S
	var parallel_dir = -1
	
	for y in BOARD_SIZE:
		for x in BOARD_SIZE:
			if tableau[y][x] != 0:
				var best_local = get_best_local_move(hand, substr_by_len, x, y, searched)
				if not best_local.is_empty():
					if best_local[0][4] == best_score:
						best_moves.append_array(best_local)
					elif best_local[0][4] > best_score:
						best_score = best_local[0][4]
						best_moves = best_local
			else:
				parallel_dir = has_parallel_move(x, y)
				if parallel_dir != -1:
					var best_parallel = get_best_parallel_move(hand, substr_by_len, x, y, parallel_dir)
					if not best_parallel.is_empty():
						if best_parallel[0][4] == best_score:
							best_moves.append_array(best_parallel)
						elif best_parallel[0][4] > best_score:
							best_score = best_parallel[0][4]
							best_moves = best_parallel
	
	if best_moves.is_empty():
		return null
	return best_moves.pick_random()


func get_best_local_move(hand, substr_by_len, x, y, searched):
	var best_moves = []
	var best_score = -1
	if not searched[DIR_SOUTH][y][x]:
		var base = get_word_starting_here(x, y, DIR_SOUTH)
		if base != null:
			var w_len = base.size()
			for i in range(w_len, BOARD_SIZE - y):
				for j in range(y + 1):
					var num_tiles_req = 0
					for r1 in range(y - j, y + i + 1):
						if tableau[r1][x] == 0:
							num_tiles_req += 1
					if num_tiles_req > hand.size():
						break
					var substrings = substr_by_len[num_tiles_req - 1]
					for s in substrings:
						var sub_index = 0
						var cand = PackedByteArray()
						for r1 in range(y - j, y + i + 1):
							if tableau[r1][x] == 0:
								cand.append(s[sub_index])
								sub_index += 1
							else:
								cand.append(tableau[r1][x])
						var str = cand.get_string_from_ascii().to_upper()
						var alpha = alphabetize(str)
						if not (word_dict.has(alpha) and str in word_dict[alpha]):
							continue
						if is_valid_move(x, y - j, DIR_SOUTH, cand, false):
							var score = score_move(x, y - j, DIR_SOUTH, cand)
							if score == best_score:
								best_moves.append([x, y - j, DIR_SOUTH, cand, score])
							elif score > best_score:
								best_score = score
								best_moves = [[x, y - j, DIR_SOUTH, cand, score]]
			for r1 in range(y, w_len):
				if r1 >= BOARD_SIZE or tableau[r1][x] == 0:
					break
				searched[DIR_SOUTH][r1][x] = true
		else: # "Perp word case going SOUTH, i.e. we're in the middle of a word"
			var perp_moves = get_perp_moves(hand, substr_by_len, x, y, DIR_SOUTH)
			for move in perp_moves:
				var score = score_move(move[0], move[1], move[2], move[3])
				if score == best_score:
					move.append(score)
					best_moves.append(move)
				elif score > best_score:
					best_score = score
					move.append(score)
					best_moves = [move]
	if not searched[DIR_EAST][y][x]:
		var base = get_word_starting_here(x, y, DIR_EAST)
		if base != null:
			var w_len = base.size()
			for i in range(w_len, BOARD_SIZE - x):
				for j in range(x + 1):
					var num_tiles_req = 0
					for c1 in range(x - j, x + i + 1):
						if tableau[y][c1] == 0:
							num_tiles_req += 1
					if num_tiles_req > hand.size():
						break
					var substrings = substr_by_len[num_tiles_req - 1]
					for s in substrings:
						var sub_index = 0
						var cand = PackedByteArray()
						for c1 in range(x - j, x + i + 1):
							if tableau[y][c1] == 0:
								cand.append(s[sub_index])
								sub_index += 1
							else:
								cand.append(tableau[y][c1])
						var str = cand.get_string_from_ascii().to_upper()
						var alpha = alphabetize(str)
						if not (word_dict.has(alpha) and str in word_dict[alpha]):
							continue
						if is_valid_move(x - j, y, DIR_EAST, cand, false):
							var score = score_move(x - j, y, DIR_EAST, cand)
							if score == best_score:
								best_moves.append([x - j, y, DIR_EAST, cand, score])
							elif score > best_score:
								best_score = score
								best_moves = [[x - j, y, DIR_EAST, cand, score]]
			for c1 in range(x, w_len):
				if c1 >= BOARD_SIZE or tableau[y][c1] == 0:
					break
				searched[DIR_EAST][y][c1] = true
		else: # "Perp word case going EAST, i.e. we're in the middle of a word"
			var perp_moves = get_perp_moves(hand, substr_by_len, x, y, DIR_EAST)
			for move in perp_moves:
				var score = score_move(move[0], move[1], move[2], move[3])
				if score == best_score:
					move.append(score)
					best_moves.append(move)
				elif score > best_score:
					best_score = score
					move.append(score)
					best_moves = [move]
	return best_moves


func get_perp_moves(hand, substr_by_len, x, y, dir):
	var num_tiles = hand.size()
	var moves = []
	if dir == DIR_SOUTH:
		for i in y + 1:
			for j in BOARD_SIZE - y:
				var num_tiles_req = 0
				for r1 in range(y - i, y + j + 1):
					if tableau[r1][x] == 0:
						num_tiles_req += 1
				if num_tiles_req == 0:
					continue
				if num_tiles_req > num_tiles:
					break
				var substrings = substr_by_len[num_tiles_req - 1]
				for s in substrings:
					var sub_index = 0
					var cand = PackedByteArray()
					for r1 in range(y - i, y + j + 1):
						if tableau[r1][x] == 0:
							cand.append(s[sub_index])
							sub_index += 1
						else:
							cand.append(tableau[r1][x])
					var str = cand.get_string_from_ascii().to_upper()
					var anags = get_anagrams(str)
					if anags.is_empty():
						continue
					for m in anags:
						var lines_up = true
						for r1 in range(y - 1, y + j + 1):
							if tableau[r1][x] != 0 and String.chr(tableau[r1][x]).to_upper() != m[r1 - y + i]:
								lines_up = false
								break
						if lines_up:
							var word = assign_wildcards_for_perp(hand, m, x, y - i, dir)
							if word != null and is_valid_move(x, y - i, dir, word, false):
								moves.append([x, y - i, dir, word])
	else:
		for i in x + 1:
			for j in BOARD_SIZE - x:
				var num_tiles_req = 0
				for c1 in range(x - i, x + j + 1):
					if tableau[y][c1] == 0:
						num_tiles_req += 1
				if num_tiles_req == 0:
					continue
				if num_tiles_req > num_tiles:
					break
				var substrings = substr_by_len[num_tiles_req - 1]
				for s in substrings:
					var sub_index = 0
					var cand = PackedByteArray()
					for c1 in range(x - i, x + j + 1):
						if tableau[y][c1] == 0:
							cand.append(s[sub_index])
							sub_index += 1
						else:
							cand.append(tableau[y][c1])
					var str = cand.get_string_from_ascii().to_upper()
					var anags = get_anagrams(str)
					if anags.is_empty():
						continue
					for m in anags:
						var lines_up = true
						for c1 in range(x - i, x + j + 1):
							if tableau[y][c1] != 0 and String.chr(tableau[y][c1]).to_upper() != m[c1 - x + i]:
								lines_up = false
								break
						if lines_up:
							var word = assign_wildcards_for_perp(hand, m, x - i, y, dir)
							if word != null and is_valid_move(x - i, y, dir, word, false):
								moves.append([x - i, y, dir, word])
	return moves


# assume m is all caps
func assign_wildcards_for_perp(hand, m, x, y, dir):
	var result = m.to_ascii_buffer()
	var h = hand.duplicate()
	if dir == DIR_SOUTH:
		for i in result.size():
			if tableau[y + i][x] != 0:
				result[i] = tableau[y + i][x]
			else:
				var pos = h.find(result[i])
				if pos == -1:
					pos = h.find(1)
					if pos == -1:
						return null # bug? anyway, bail!
					h.remove_at(pos)
					result[i] += 32 # to lower case
				else:
					h.remove_at(pos)
	else:
		for i in result.size():
			if tableau[y][x + i] != 0:
				result[i] = tableau[y][x + i]
			else:
				var pos = h.find(result[i])
				if pos == -1:
					result[i] += 32 # to lower case
				else:
					h.remove_at(pos)
	return result


func get_word_starting_here(x, y, dir):
	if dir == DIR_SOUTH:
		if y > 0 and tableau[y - 1][x] != 0:
			return null
		var southerly = PackedByteArray()
		var i = 0
		while y + i < BOARD_SIZE and tableau[y + i][x] != 0:
			southerly.append(tableau[y + i][x])
			i += 1
		return southerly if southerly.size() >= 2 else null
	else:
		if x > 0 and tableau[y][x - 1] != 0:
			return null
		var easterly = PackedByteArray()
		var i = 0
		while x + i < BOARD_SIZE and tableau[y][x + i] != 0:
			easterly.append(tableau[y][x + i])
			i += 1
		return easterly if easterly.size() >= 2 else null
		

func get_best_parallel_move(hand, substr_by_len, x, y, dir):
	var max_play_size = hand.size()
	if max_play_size < 2:
		return []
	var best_moves = []
	var best_score = -1
	if dir == DIR_SOUTH:
		for i in max_play_size:
			if y - i < 0 or (y - i > 0 and tableau[y - i - 1][x] != 0):
				return best_moves
			for j in max_play_size:
				if i == 0 and j == 0:
					continue
				if i + j + 1 > max_play_size:
					break
				if y + j >= BOARD_SIZE or (y + j < BOARD_END and tableau[y + j + 1][x] != 0):
					break
				var substrings = substr_by_len[i + j]
				for s in substrings:
					var anags = get_anagrams(s.get_string_from_ascii().to_upper())
					for m in anags:
						var word = assign_wildcards(hand, m)
						if is_valid_move(x, y - i, dir, word, true):
							var score = score_move(x, y - i, dir, word)
							if score == best_score:
								best_moves.append([x, y - i, dir, word, score])
							elif score > best_score:
								best_score = score
								best_moves = [[x, y - i, dir, word, score]]
	else:
		for i in max_play_size:
			if x - i < 0 or (x - i > 0 and tableau[y][x - i - 1] != 0):
				return best_moves
			for j in max_play_size:
				if i == 0 and j == 0:
					continue
				if i + j + 1 > max_play_size:
					break
				if x + j >= BOARD_SIZE or (x + j < BOARD_END and tableau[y][x + j + 1] != 0):
					break
				var substrings = substr_by_len[i + j]
				for s in substrings:
					var anags = get_anagrams(s.get_string_from_ascii().to_upper())
					for m in anags:
						var word = assign_wildcards(hand, m)
						if word != null and is_valid_move(x - i, y, dir, word, true):
							var score = score_move(x - i, y, dir, word)
							if score == best_score:
								best_moves.append([x - i, y, dir, word, score])
							elif score > best_score:
								best_score = score
								best_moves = [[x - i, y, dir, word, score]]
	return best_moves


func has_parallel_move(x, y):
	if tableau[y][x] != 0:
		return -1
	if (x > 0 and tableau[y][x - 1] != 0) or (x < BOARD_END and tableau[y][x + 1] != 0):
		if (y > 0 and tableau[y - 1][x] != 0) or (y < BOARD_END and tableau[y + 1][x] != 0):
			return -1
		if y == 1 or y == BOARD_END - 1:
			return DIR_SOUTH
		if y > 1 and tableau[y - 2][x] == 0:
			return DIR_SOUTH
		if y < BOARD_END - 1 and tableau[y + 2][x] == 0:
			return DIR_SOUTH
	if (y > 0 and tableau[y - 1][x] != 0) or (y < BOARD_END and tableau[y + 1][x] != 0):
		if (x > 0 and tableau[y][x - 1] != 0) or (x < BOARD_END and tableau[y][x + 1] != 0):
			return -1
		if x == 1 or x == BOARD_END - 1:
			return DIR_EAST
		if x > 1 and tableau[y][x - 2] == 0:
			return DIR_EAST
		if x < BOARD_END - 1 and tableau[y][x + 2] == 0:
			return DIR_EAST
	return -1


func is_valid_move(x, y, dir, word, is_parallel):
	# can skip check for using tiles from hand?
	if word.size() < 2:
		return false
	# can skip dictionary check on word itself?
	# can skip board boundary check?
	if not is_parallel: # if parallel, can skip check for collision before and after word itself?
		if dir == DIR_SOUTH:
			if y > 0 and tableau[y - 1][x] != 0:
				return false
			if y + word.size() < BOARD_SIZE and tableau[y + word.size()][x] != 0:
				return false
		else:
			if x > 0 and tableau[y][x - 1] != 0:
				return false
			if x + word.size() < BOARD_SIZE and tableau[y][x + word.size()] != 0:
				return false
	var next_to_something = false
#	var xx = x
#	var yy = y
	
	# "Check if it's a prefix/suffix of some word" is commented out in the original code
	
	# "Collisions with letters already on board must match up"
#	var tiles_needed = [] # can skip check word overlaps correctly with letters on tableau?
	if dir == DIR_SOUTH:
		for i in word.size():
			var perp_invalid = is_perp_invalid(x, y + i, dir, word[i])
			if perp_invalid:
				return false
			if tableau[y+i][x] != 0 or tableau[y+i][max(x-1,0)] != 0 or tableau[y+i][min(x+1,BOARD_END)] != 0:
				next_to_something = true
	else:
		for i in word.size():
			var perp_invalid = is_perp_invalid(x + i, y, dir, word[i])
			if perp_invalid:
				return false
			if tableau[y][x+i] != 0 or tableau[max(y-1,0)][x+i] != 0 or tableau[min(y+1,BOARD_END)][x+i] != 0:
				next_to_something = true
	return next_to_something


func is_perp_invalid(x, y, orig_dir, letter):
	if orig_dir == DIR_SOUTH:
		if (x == 0 or tableau[y][x-1] == 0) and (x == BOARD_END or tableau[y][x+1] == 0):
			return false
		var xx = x
		while xx != 0 and tableau[y][xx-1] != 0:
			xx -= 1
#		var start = xx
		var str = ""
		str += String.chr(letter if xx == x else tableau[y][xx])
		while xx != BOARD_END and (xx + 1 == x or tableau[y][xx+1] != 0):
			xx += 1
			str += String.chr(letter if xx == x else tableau[y][xx])
		str = str.to_upper()
		var alpha = alphabetize(str)
		return not (word_dict.has(alpha) and str in word_dict[alpha])
	else:
		if (y == 0 or tableau[y-1][x] == 0) and (y == BOARD_END or tableau[y+1][x] == 0):
			return false
		var yy = y
		while yy != 0 and tableau[yy-1][x] != 0:
			yy -= 1
#		var start = yy
		var str = ""
		str += String.chr(letter if yy == y else tableau[yy][x])
		while yy != BOARD_END and (yy + 1 == y or tableau[yy+1][x] != 0):
			yy += 1
			str += String.chr(letter if yy == y else tableau[yy][x])
		str = str.to_upper()
		var alpha = alphabetize(str)
		return not (word_dict.has(alpha) and str in word_dict[alpha])


# currently does not check that hand actually contains wildcards; m should be an uppercase string
func assign_wildcards(hand, m):
	var result = m.to_ascii_buffer()
	var h = hand.duplicate()
	for i in result.size():
		var pos = h.find(result[i])
		if pos == -1:
			pos = h.find(1)
			if pos == -1:
				return null # bug? anyway, bail!
			h.remove_at(pos)
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
		if v.size() > 0:
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
				result += score_perpendicular(x + i, y, dir, word[i])
				tiles_used += 1

	if tiles_used == 7:
		result += BINGO_BONUS
	return result


# word should be a int array or PackedByteArray
func score_one_word(x, y, dir, word):
	var result = 0
	var mult = 1

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


func do_debug():
	tableau = create_2d_array(BOARD_SIZE, BOARD_SIZE, 0)
	tableau[0][12] = "G".to_ascii_buffer()[0]
	tableau[1][12] = "E".to_ascii_buffer()[0]
	tableau[2][12] = "M".to_ascii_buffer()[0]
	tableau[3][12] = "O".to_ascii_buffer()[0]
	tableau[4][12] = "T".to_ascii_buffer()[0]
	tableau[5][12] = "E".to_ascii_buffer()[0]
	tableau[5][11] = "E".to_ascii_buffer()[0]
	tableau[6][11] = "Q".to_ascii_buffer()[0]
	tableau[7][11] = "U".to_ascii_buffer()[0]
	tableau[8][11] = "I".to_ascii_buffer()[0]
	tableau[9][11] = "T".to_ascii_buffer()[0]
	tableau[10][11] = "E".to_ascii_buffer()[0]
	tableau[11][11] = "S".to_ascii_buffer()[0]
	tableau[11][5] = "J".to_ascii_buffer()[0]
	tableau[11][6] = "E".to_ascii_buffer()[0]
	tableau[11][7] = "R".to_ascii_buffer()[0]
	tableau[11][8] = "B".to_ascii_buffer()[0]
	tableau[11][9] = "I".to_ascii_buffer()[0]
	tableau[11][10] = "L".to_ascii_buffer()[0]
	tableau[10][7] = "A".to_ascii_buffer()[0]
	tableau[12][7] = "O".to_ascii_buffer()[0]
	tableau[13][7] = "S".to_ascii_buffer()[0]
	tableau[14][7] = "E".to_ascii_buffer()[0]
	tableau[7][4] = "P".to_ascii_buffer()[0]
	tableau[7][5] = "I".to_ascii_buffer()[0]
	tableau[7][6] = "O".to_ascii_buffer()[0]
	tableau[7][7] = "Y".to_ascii_buffer()[0]
	tableau[7][8] = "E".to_ascii_buffer()[0]
	tableau[5][6] = "C".to_ascii_buffer()[0]
	tableau[6][6] = "H".to_ascii_buffer()[0]
	tableau[8][6] = "R".to_ascii_buffer()[0]
	tableau[9][6] = "T".to_ascii_buffer()[0]
	tableau[10][6] = "L".to_ascii_buffer()[0]
	tableau[12][6] = "D".to_ascii_buffer()[0]
	var result = get_best_move("VOIOEII".to_ascii_buffer())
	print(result)
	print(result[3].get_string_from_ascii())
