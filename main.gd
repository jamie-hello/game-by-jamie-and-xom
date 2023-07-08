extends Node


@onready var instance = preload("res://tile.tscn")


var dealer_hand = []


func _ready():
	newgame_deal_out_some_tiles()


func _process(delta):
	pass


func dealer_newhand():
	dealer_hand = $Bag.draw_seven()
	if dealer_hand.is_empty():
		return false
	for i in 7:
		var tilename = "blank" if dealer_hand[i] == 1 else String.chr(dealer_hand[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 + 165))
		add_child(newtile)
	return true


func newgame_deal_out_some_tiles():
	# player1
	var tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player1".add_tile(newtile)
		
	# player2
	tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player2".add_tile(newtile)

	# player3
	tiles = $Bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		$"dealerUI/DealZone Player3".add_tile(newtile)

	$Bag.add_remaining_letters()


func deal_tile(whoseturn, tile):
	var ascii_code = tile.Letter.to_ascii_buffer()[0] if tile.Letter.length() == 1 else 1
	dealer_hand.pop_at(dealer_hand.find(ascii_code))
	whoseturn.add_tile(tile)
	print("added ", tile.Letter, " to ", whoseturn)
	if dealer_hand.is_empty():
		dealer_newhand()
	if whoseturn.rack.size() == 7 or dealer_hand.is_empty():
		$PhaseSingleton.play_turn()
