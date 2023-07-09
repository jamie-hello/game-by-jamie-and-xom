extends Node


var STEP_DEALING = 0
var STEP_PLAYING = 1
var STEP_ANIMATING = 2
var STEP_GAMEOVER = 3

var ANIMATION_DELAY = 0.1

var player1
var player2
var player3
var active_player
var active_step
var is_opening
var consecutive_passes


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	player1 = get_parent().get_node("dealerUI").get_node("DealZone Player1")
	player2 = get_parent().get_node("dealerUI").get_node("DealZone Player2")
	player3 = get_parent().get_node("dealerUI").get_node("DealZone Player3")
	#start the game
	$"../HUD/ScoresButton".show()
	is_opening = true
	consecutive_passes = 0
	set_active_player(1, STEP_PLAYING)
	player1turn()


#func signpost():
#	print(active_step)


func set_active_player(n, step):
	if n == 0:
		active_player = null
	elif n == 1:
		active_player = player1
	elif n == 2:
		active_player = player2
	elif n == 3:
		active_player = player3
	active_step = step
	player1.get_node("PointLight2D").set_visible(n == 1)
	player2.get_node("PointLight2D").set_visible(n == 2)
	player3.get_node("PointLight2D").set_visible(n == 3)
	set_active_turn_rack_scale(n)
	
	
func set_active_turn_rack_scale(n):
	match n:
		1:
			player1.get_node("Rack").set_scale(Vector2(1.07,1.07))
			player2.get_node("Rack").set_scale(Vector2(1.0,1.0))
			player3.get_node("Rack").set_scale(Vector2(1.0,1.0))
		2:
			player1.get_node("Rack").set_scale(Vector2(1.0,1.0))
			player2.get_node("Rack").set_scale(Vector2(1.07,1.07))
			player3.get_node("Rack").set_scale(Vector2(1.0,1.0))
		3:
			player1.get_node("Rack").set_scale(Vector2(1.0,1.0))
			player2.get_node("Rack").set_scale(Vector2(1.0,1.0))
			player3.get_node("Rack").set_scale(Vector2(1.07,1.07))


func game_over():
	print("gameover")
	set_active_player(0, STEP_GAMEOVER)
	var bonuses = [0, 0, 0]
	for tile in player1.hand:
		bonuses[0] -= $"../WordAI".letter_value(tile)
	for tile in player2.hand:
		bonuses[1] -= $"../WordAI".letter_value(tile)
	for tile in player3.hand:
		bonuses[2] -= $"../WordAI".letter_value(tile)
	var penalty_sum = bonuses[0] + bonuses[1] + bonuses[2]
	if $"..".dealer_hand.is_empty() and $"../Bag".contents.is_empty():
		var player1_has_remaining_tiles = false
		for x in player1.hand:
			if x != 0:
				player1_has_remaining_tiles = true
				break
		if not player1_has_remaining_tiles:
			bonuses[0] -= penalty_sum
		var player2_has_remaining_tiles = false
		for x in player2.hand:
			if x != 0:
				player2_has_remaining_tiles = true
				break
		if not player2_has_remaining_tiles:
			bonuses[1] -= penalty_sum
		var player3_has_remaining_tiles = false
		for x in player3.hand:
			if x != 0:
				player3_has_remaining_tiles = true
				break
		if not player3_has_remaining_tiles:
			bonuses[2] -= penalty_sum
	else:
		print("gameover by consecutive passes")
	print(bonuses)
	player1.score += bonuses[0]
	player2.score += bonuses[1]
	player3.score += bonuses[2]
	print([player1.score, player2.score, player3.score])

	#high scores recording
	var sortscores = [player1.score, player2.score, player3.score]
	sortscores.sort()
	HighscoresSingleton.RecordNewRun(
		player1.score + player2.score + player3.score,
		sortscores[2],
		sortscores[0]
	)
	$"../HUD/NewGameButton".show()
	get_parent().get_node("HighScoresOnGameover").display_scores()


func player1turn():
	player1.play_turn()


func _on_timer_first_turn_1_timeout():
	if consecutive_passes >= 3:
		game_over()
		return
	if active_player == player1:
		if is_opening or $"..".dealer_hand.is_empty():
			set_active_player(2, STEP_PLAYING)
			player2turn()
		else:
			nextphase()
	elif active_player == player2:
		if is_opening or $"..".dealer_hand.is_empty():
			set_active_player(3, STEP_PLAYING)
			player3turn()
		else:
			nextphase()
	elif active_player == player3:
		if is_opening:
			$"..".dealer_newhand()
			is_opening = false
			nextphase()
		elif $"..".dealer_hand.is_empty():
			set_active_player(1, STEP_PLAYING)
			player1turn()
		else:
			nextphase()


func player2turn():
	player2.play_turn()


func player3turn():
	player3.play_turn()


func play_turn():
	active_step = STEP_PLAYING
	if active_player == player1:
		player1turn()
	elif active_player == player2:
		player2turn()
	elif active_player == player3:
		player3turn()


func nextphase():
	if active_player == player1:
		set_active_player(2, STEP_DEALING)
	elif active_player == player2:
		set_active_player(3, STEP_DEALING)
	elif active_player == player3:
		set_active_player(1, STEP_DEALING)
