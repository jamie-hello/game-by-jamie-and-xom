extends Node


signal spawn_a_click_animation


@onready var instance = preload("res://tile.tscn")
@onready var card_instance = preload("res://card.tscn")


var dealer_hand = []
var dealer_rack = [null, null, null, null, null, null, null]


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
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 - 1000))
		dealer_rack[i] = newtile
		$HUD.show_card(i, "" if dealer_hand[i] == 1 else tilename, "" if dealer_hand[i] == 1 else str($WordAI.letter_value(dealer_hand[i])))
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
	var pos = dealer_rack.find(tile)
	dealer_hand[pos] = 0
	dealer_rack[pos] = null
	$HUD.hide_card(pos)
	whoseturn.add_tile(tile)
	#print("added ", tile.Letter, " to ", whoseturn)
	emit_signal("spawn_a_click_animation")#spawn that thing
	
	var newcard = card_instance.instantiate()
	newcard.get_node("Glyph").text = tile.Letter if tile.Letter.length() == 1 else ""
	newcard.get_node("SubScript").text = str($WordAI.letter_value(ascii_code)) if tile.Letter.length() == 1 else ""
	add_child(newcard)
	newcard.position = $HUD.cards[pos].position
	newcard.destination_x = tile.position.x
	newcard.destination_y = tile.position.y
	newcard.destination_scale = 0.5
	newcard.moving = true
	
	var dealer_should_draw = true
	for code in dealer_hand:
		if code != 0:
			dealer_should_draw = false
			break
	if dealer_should_draw:
		dealer_newhand()
	if whoseturn.rack.size() == 7 or dealer_hand.is_empty():
		$PhaseSingleton.active_step = $PhaseSingleton.STEP_PLAYING
		newcard.signal_id = 1
		newcard.connect("done_moving", _on_done_moving)


func _on_hud_hand_card_pressed(pos):
	if dealer_rack[pos] != null:
		dealer_rack[pos].clicked = true


func _on_done_moving(i):
	if i == 1:
		$PhaseSingleton.play_turn()
