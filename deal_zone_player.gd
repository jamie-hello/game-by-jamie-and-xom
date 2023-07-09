extends Node2D


var hand = [0, 0, 0, 0, 0, 0, 0] # ASCII
var rack = [null, null, null, null, null, null, null] # instances
var score = 0
signal played_tiles_sound
signal clicktiletoplayerhand
signal new_score


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func play_turn(): # TODO: Should counts_for_score (false on first turn) be a parameter here, or implemented some other way?
	var filtered_hand = []
	for x in hand:
		if x != 0:
			filtered_hand.append(x)
	var move = $"../../WordAI".get_best_move(filtered_hand)
	# TODO move logic to word_ai.gd?
	if move == null:
		print('no valid move, pass the turn')
		$"../../PhaseSingleton".consecutive_passes += 1
		emit_signal("new_score",0,"passed turn",$"../../PhaseSingleton".is_opening)
		return # no valid move, pass the turn; # TODO check for end of game
	$"../../PhaseSingleton".consecutive_passes = 0
	print(move)
	print(PackedByteArray(move[3]).get_string_from_ascii())
	var rightmost_pos = -1
	var rightmost_card = null
	var tiles_used = 0
	if move[2] == $"../../WordAI".DIR_SOUTH:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1] + i][move[0]] == 0:
				tiles_used += 1
				var to_find = move[3][i]
				if to_find > 95: # lowercase
					to_find = 1 # wildcard
					$"../../Bag".set_wildcard_played()
				var pos = hand.find(to_find)
				hand[pos] = 0
				var tile = rack[pos]
				rack[pos] = null
				if tile.Letter.length() != 1:
					tile.card.get_node("Glyph").text = String.chr(move[3][i] - 32)
				tile.card.destination_scale = 0.333333
				tile.card.destination_x = move[0] * 40 + 80
				tile.card.destination_y = (move[1] + i) * 40 + 80
				tile.card.moving = true
				if pos > rightmost_pos:
					rightmost_pos = pos
					rightmost_card = tile.card
				tile.queue_free()
		var handler = func _handler(_i):
			if $"../../PhaseSingleton".active_player == self and $"../../PhaseSingleton".active_step == $"../../PhaseSingleton".STEP_PLAYING:
				$"../../PhaseSingleton".active_step = $"../../PhaseSingleton".STEP_ANIMATING
				for i in move[3].size():
					if $"../../WordAI".tableau[move[1] + i][move[0]] == 0:
						$"../../WordAI".tableau[move[1] + i][move[0]] = move[3][i]
				if not $"../../PhaseSingleton".is_opening:
					score += move[4]
					var has_remaining_tiles = false
					for x in hand:
						if x != 0:
							has_remaining_tiles = true
							break
					if (not has_remaining_tiles) and $"../..".dealer_hand.is_empty():
						$"../../PhaseSingleton".consecutive_passes = 4 # game over
				emit_signal("played_tiles_sound")
				emit_signal("new_score",move[4],PackedByteArray(move[3]).get_string_from_ascii(),$"../../PhaseSingleton".is_opening,tiles_used == 7)
				$"../../PhaseSingleton/TimerFirstTurn1".start($"../../PhaseSingleton".ANIMATION_DELAY)
		rightmost_card.connect("done_moving", handler)
	else:
		for i in move[3].size():
			if $"../../WordAI".tableau[move[1]][move[0] + i] == 0:
				tiles_used += 1
				var to_find = move[3][i]
				if to_find > 95: # lowercase
					to_find = 1 # wildcard
					$"../../Bag".set_wildcard_played()
				var pos = hand.find(to_find)
				hand[pos] = 0
				var tile = rack[pos]
				rack[pos] = null
				if tile.Letter.length() != 1:
					tile.card.get_node("Glyph").text = String.chr(move[3][i] - 32)
				tile.card.destination_scale = 0.333333
				tile.card.destination_x = (move[0] + i) * 40 + 80
				tile.card.destination_y = move[1] * 40 + 80
				tile.card.moving = true
				if pos > rightmost_pos:
					rightmost_pos = pos
					rightmost_card = tile.card
				tile.queue_free()
		var handler = func _handler(_i):
			if $"../../PhaseSingleton".active_player == self and $"../../PhaseSingleton".active_step == $"../../PhaseSingleton".STEP_PLAYING:
				$"../../PhaseSingleton".active_step = $"../../PhaseSingleton".STEP_ANIMATING
				for i in move[3].size():
					if $"../../WordAI".tableau[move[1]][move[0] + i] == 0:
						$"../../WordAI".tableau[move[1]][move[0] + i] = move[3][i]
				if not $"../../PhaseSingleton".is_opening:
					score += move[4]
					var has_remaining_tiles = false
					for x in hand:
						if x != 0:
							has_remaining_tiles = true
							break
					if (not has_remaining_tiles) and $"../..".dealer_hand.is_empty():
						$"../../PhaseSingleton".consecutive_passes = 4 # game over
				emit_signal("played_tiles_sound")
				emit_signal("new_score",move[4],PackedByteArray(move[3]).get_string_from_ascii(),$"../../PhaseSingleton".is_opening,tiles_used == 7)
				$"../../PhaseSingleton/TimerFirstTurn1".start($"../../PhaseSingleton".ANIMATION_DELAY)
		rightmost_card.connect("done_moving", handler)


func add_tile(tile):
	tile.drawn_by_player()
	var pos = hand.find(0)
	rack[pos] = tile
	tile.set_position(get_children()[pos].global_position)
	add_child(tile)
	tile.rest_point = tile.global_position
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	hand[pos] = ascii_code
	emit_signal("clicktiletoplayerhand")
