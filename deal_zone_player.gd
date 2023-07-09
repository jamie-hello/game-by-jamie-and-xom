extends Node2D


var hand = [] # ASCII
var rack = [] # instances
var score = 0
signal played_tiles_sound
signal clicktiletoplayerhand
signal new_score


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func play_turn(): # TODO: Should counts_for_score (false on first turn) be a parameter here, or implemented some other way?
	var move = $"../../WordAI".get_best_move(hand)
	# TODO move logic to word_ai.gd?
	if move == null:
		print('no valid move, pass the turn')
		$"../../PhaseSingleton".consecutive_passes += 1
		return # no valid move, pass the turn; # TODO check for end of game
	$"../../PhaseSingleton".consecutive_passes = 0
	print(move)
	emit_signal("played_tiles_sound")
	print(PackedByteArray(move[3]).get_string_from_ascii())
	if move[2] == $"../../WordAI".DIR_SOUTH:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1] + i][move[0]] == 0:
				$"../../WordAI".tableau[move[1] + i][move[0]] = move[3][i]
				var to_find = move[3][i]
				if to_find > 100: # lowercase
					to_find = 1 # wildcard
					$"../../Bag".set_wildcard_played()
				var pos = hand.find(to_find)
				hand.pop_at(pos)
				var tile = rack.pop_at(pos)
				if tile.Letter.length() != 1:
					tile.card.get_node("Glyph").text = String.chr(move[3][i] - 32)
				tile.card.destination_scale = 0.333333
				tile.card.destination_x = move[0] * 40 + 80
				tile.card.destination_y = (move[1] + i) * 40 + 80
				tile.card.moving = true
				tile.queue_free()
	else:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1]][move[0] + i] == 0:
				$"../../WordAI".tableau[move[1]][move[0] + i] = move[3][i]
				var to_find = move[3][i]
				var pos = hand.find(to_find if to_find < 100 else 1) # convert lowercase to wildcard
				hand.pop_at(pos)
				var tile = rack.pop_at(pos)
				if tile.Letter.length() != 1:
					tile.card.get_node("Glyph").text = String.chr(move[3][i] - 32)
				tile.card.destination_scale = 0.333333
				tile.card.destination_x = (move[0] + i) * 40 + 80
				tile.card.destination_y = move[1] * 40 + 80
				tile.card.moving = true
				tile.queue_free()
	if not $"../../PhaseSingleton".is_opening:
		score += move[4]
		emit_signal("new_score",move[4],PackedByteArray(move[3]).get_string_from_ascii())
		if hand.is_empty() and $"../..".dealer_hand.is_empty():
			$"../../PhaseSingleton".consecutive_passes = 4 # game over
	cleanup()


func cleanup():
	for i in rack.size():
		rack[i].global_position = get_children()[i].global_position
		rack[i].rest_point = rack[i].global_position


func add_tile(tile):
	tile.drawn_by_player()
	rack.append(tile)
	tile.set_position(get_children()[hand.size()].global_position)
	add_child(tile)
	tile.rest_point = tile.global_position
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	hand.append(ascii_code)
	emit_signal("clicktiletoplayerhand")
