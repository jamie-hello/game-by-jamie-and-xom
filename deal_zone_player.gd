extends Node2D


var hand = [] # ASCII
var rack = [] # instances


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func play_turn(): # TODO: Should counts_for_score (false on first turn) be a parameter here, or implemented some other way?
	var move = $"../../WordAI".get_best_move(hand)
	# TODO move logic to word_ai.gd?
	if move == null:
		return # no valid move, pass the turn; # TODO check for end of game
	if move[2] == $"../../WordAI".DIR_SOUTH:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1] + i][move[0]] == 0:
				$"../../WordAI".tableau[move[1] + i][move[0]] = move[3][i]
				var to_find = move[3][i]
				if to_find > 100: # lowercase
					to_find = 1 # wildcard
					$"../../bag".set_wildcard_played()
				var pos = hand.find(to_find)
				hand.pop_at(pos)
				var tile = rack.pop_at(pos)
				tile.global_position = Vector2(0.515 * (move[0] - 7) * 930 / 14 + 528, 0.452 * (move[1] + i - 7) * 960 / 14 + 226)
				tile.rest_point = tile.global_position
	else:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1]][move[0] + i] == 0:
				$"../../WordAI".tableau[move[1]][move[0] + i] = move[3][i]
				var to_find = move[3][i]
				var pos = hand.find(to_find if to_find < 100 else 1) # convert lowercase to wildcard
				hand.pop_at(pos)
				var tile = rack.pop_at(pos)
				tile.global_position = Vector2((move[0] + i) * 490 / 14 + 300, move[1] * 210 / 14 + 160)
				tile.global_position = Vector2(0.515 * (move[0] + i - 7) * 930 / 14 + 528, 0.452 * (move[1] - 7) * 960 / 14 + 226)
				tile.rest_point = tile.global_position
	cleanup()


func cleanup():
	for i in rack.size():
		rack[i].global_position = get_children()[i].global_position
		rack[i].rest_point = rack[i].global_position


func add_tile(tile):
	rack.append(tile)
	var prev_hand_size = hand.size()
	tile.set_position(get_children()[prev_hand_size - 1].global_position)
	add_child(tile)
	tile.rest_point = tile.global_position
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	hand.append(ascii_code)