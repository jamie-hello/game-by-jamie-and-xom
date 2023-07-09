extends Node


signal spawn_a_click_animation


@onready var instance = preload("res://tile.tscn")
@onready var card_instance = preload("res://card.tscn")


var dealer_hand = []
var dealer_rack = [null, null, null, null, null, null, null]


func _ready():
	newgame_deal_out_some_tiles()
	$Timer.start()


func _process(delta):
	pass


func dealer_newhand():
	dealer_hand = $Bag.draw_seven()
	if dealer_hand.is_empty():
		return false
	for i in 7:
		var tilename = "blank" if dealer_hand[i] == 1 else String.chr(dealer_hand[i])
		var newtile = instance.instantiate()
		newtile.add_to_group("deleteMe")
		newtile.set_letter(tilename)
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 - 1000))
		dealer_rack[i] = newtile
		add_child(newtile)
		
		var tmpcard = card_instance.instantiate()
		tmpcard.add_to_group("deleteMe")
		tmpcard.get_node("Glyph").text = tilename if tilename.length() == 1 else ""
		tmpcard.get_node("SubScript").text = str($WordAI.letter_value(dealer_hand[i])) if tilename.length() == 1 else ""
		add_child(tmpcard)
		tmpcard.position = Vector2(933, 443)
		tmpcard.destination_x = $HUD.get_children()[i].position.x + 60
		tmpcard.destination_y = $HUD.get_children()[i].position.y + 60
		tmpcard.moving = true
		var lam = func _lam(_i):
			if tmpcard.signal_id != -1:
				tmpcard.signal_id = -1
				tmpcard.queue_free()
				if dealer_hand[i] != 0:
					$HUD.show_card(i, "" if dealer_hand[i] == 1 else tilename, "" if dealer_hand[i] == 1 else str($WordAI.letter_value(dealer_hand[i])))
		tmpcard.connect("done_moving", lam)

	return true


func newgame_deal_out_some_tiles():
	# player1
	var tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var tile = instance.instantiate()
		tile.add_to_group("deleteMe")
		tile.set_letter(tilename)
		$"dealerUI/DealZone Player1".add_tile(tile)
		tile.card = card_instance.instantiate()
		tile.card.add_to_group("deleteMe")
		tile.card.get_node("Glyph").text = tile.Letter
		tile.card.get_node("SubScript").text = str($WordAI.letter_value(tiles[i]))
		add_child(tile.card)
		tile.card.set_scale(Vector2(.5, .5))
		tile.card.position = tile.position
		
	# player2
	tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var tile = instance.instantiate()
		tile.add_to_group("deleteMe")
		tile.set_letter(tilename)
		$"dealerUI/DealZone Player2".add_tile(tile)
		tile.card = card_instance.instantiate()
		tile.card.add_to_group("deleteMe")
		tile.card.get_node("Glyph").text = tile.Letter
		tile.card.get_node("SubScript").text = str($WordAI.letter_value(tiles[i]))
		add_child(tile.card)
		tile.card.set_scale(Vector2(.5, .5))
		tile.card.position = tile.position

	# player3
	tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var tile = instance.instantiate()
		tile.add_to_group("deleteMe")
		tile.set_letter(tilename)
		$"dealerUI/DealZone Player3".add_tile(tile)
		tile.card = card_instance.instantiate()
		tile.card.add_to_group("deleteMe")
		tile.card.get_node("Glyph").text = tile.Letter
		tile.card.get_node("SubScript").text = str($WordAI.letter_value(tiles[i]))
		add_child(tile.card)
		tile.card.set_scale(Vector2(.5, .5))
		tile.card.position = tile.position

	$Bag.add_remaining_letters()


func deal_tile(whoseturn, tile):
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	var pos = dealer_rack.find(tile)
	dealer_hand[pos] = 0
	dealer_rack[pos] = null
	$HUD.hide_card(pos)
	whoseturn.add_tile(tile)
	#print("added ", tile.Letter, " to ", whoseturn)
	emit_signal("spawn_a_click_animation")#spawn that thing

	tile.card = card_instance.instantiate()
	tile.card.add_to_group("deleteMe")
	tile.card.get_node("Glyph").text = tile.Letter if tile.Letter.length() == 1 else ""
	tile.card.get_node("SubScript").text = str($WordAI.letter_value(ascii_code)) if tile.Letter.length() == 1 else ""
	add_child(tile.card)
	tile.card.position = $HUD.cards[pos].position
	tile.card.destination_x = tile.position.x
	tile.card.destination_y = tile.position.y
	tile.card.destination_scale = 0.5
	tile.card.moving = true

	$HUD.tiles_left -= 1
	$HUD/TilesLeft.text = "Tiles Left: " + str($HUD.tiles_left)

	var dealer_should_draw = true
	for code in dealer_hand:
		if code != 0:
			dealer_should_draw = false
			break
	if dealer_should_draw:
		dealer_newhand()
	if (not (null in whoseturn.rack)) or dealer_hand.is_empty():
		$PhaseSingleton.active_step = $PhaseSingleton.STEP_PLAYING
		tile.card.signal_id = 1
		tile.card.connect("done_moving", _on_done_moving)


func _on_hud_hand_card_pressed(pos):
	if dealer_rack[pos] != null:
		var dealer_tile_count = 0
		var player_tile_count = 0
		for tile in dealer_rack:
			if tile != null:
				dealer_tile_count += 1
		for tile in $PhaseSingleton.active_player.rack:
			if tile != null:
				player_tile_count += 1
		if dealer_tile_count + player_tile_count <= 7:
			for tile in dealer_rack:
				if tile != null:
					tile.clicked = true
		else:
			dealer_rack[pos].clicked = true


func _on_done_moving(i):
	if i == 1 and $PhaseSingleton.active_step == $PhaseSingleton.STEP_PLAYING:
		$PhaseSingleton.play_turn()


func restart_game():
	$PhaseSingleton/TimerFirstTurn1.stop()
	$Timer.stop()

	for tile_or_card in get_tree().get_nodes_in_group("deleteMe"):
		tile_or_card.queue_free()

	$HUD/ScoresButton.hide()
	$"dealerUI/DealZone Player1/Score".hide()
	$"dealerUI/DealZone Player2/Score".hide()
	$"dealerUI/DealZone Player3/Score".hide()
	dealer_hand = []
	dealer_rack = [null, null, null, null, null, null, null]
	$WordAI.board = $WordAI.create_proto_board()
	$WordAI.tableau = $WordAI.create_2d_array($WordAI.BOARD_SIZE, $WordAI.BOARD_SIZE, 0)
	$Bag.newbagnewgame()
	for i in 7:
		$HUD.hide_card(i)
	$HUD.tiles_left = 84
	for p in [$PhaseSingleton.player1, $PhaseSingleton.player2, $PhaseSingleton.player3]:
		p.hand = [0, 0, 0, 0, 0, 0, 0]
		p.rack = [null, null, null, null, null, null, null]
		p.score = 0

	newgame_deal_out_some_tiles()
	$PhaseSingleton._on_timer_timeout()
	$HighScoresOnGameover._on_button_pressed()
