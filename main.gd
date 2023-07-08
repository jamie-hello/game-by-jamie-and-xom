extends Node
@onready var instance = preload("res://tile_(placeholder_instance).tscn")


var dealer_hand = []


func _ready():
	newgame_deal_out_some_tiles()


func _process(delta):
	pass


func dealer_newhand():
	dealer_hand = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if dealer_hand[i] == 1 else String.chr(dealer_hand[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 + 165))
		add_child(newtile)


func newgame_deal_out_some_tiles():
	# player1
	var tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player1".add_tile(newtile)
		
	# player2
	tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player2".add_tile(newtile)

	# player3
	tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player3".add_tile(newtile)

	# dealer
	$bag.add_remaining_letters() # add in one blank and QXZJ
	dealer_newhand() # TODO maybe don't draw until opening is ended, to really emphasize the game hadn't started


func deal_tile(whoseturn, tile):
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	dealer_hand.pop_at(dealer_hand.find(ascii_code))
	whoseturn.add_tile(tile)
	tile.drawn_by_player()
	print("added ", tile.Letter, " to ", whoseturn)
	if dealer_hand.is_empty():
		dealer_newhand()
	if whoseturn.rack.size() == 7:
		$"phase singleton".is_opening = false
		$"phase singleton".play_turn()


func evaluate_hands():
#	$"dealerUI/DealZone Player1".evaluate()
#	$"dealerUI/DealZone Player2".evaluate()
#	$"dealerUI/DealZone Player3".evaluate()
	pass


func _on_evaluatehandsbutton_pressed():
	evaluate_hands()


func _on_timer_timeout():
	evaluate_hands()
	#$"dealerUI/DealZone Player1/acceptor".cleanup()
	#$"dealerUI/DealZone Player2/acceptor".cleanup()
	#$"dealerUI/DealZone Player3/acceptor".cleanup()
