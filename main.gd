extends Node
@onready var instance = preload("res://tile_(placeholder_instance).tscn")
signal add_tile_to_player1_inventory
signal add_tile_to_player2_inventory
signal add_tile_to_player3_inventory

var player1hand=[] #["X","J","E","S","S"]
var player2hand=[] #
var player3hand=[] #
var dealerhand=[]  #
"""
var player1tileholder = [] #[<tileobject>,<tileobject>...]
var player2tileholder = [] #
var player3tileholder = [] #
var dealertileholder = []  #
"""


func _ready():
	newgame_deal_out_some_tiles()


func _process(delta):
	pass


func dealer_newhand():
	var tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		dealerhand.append(tilename)
		var newtile = instance.instantiate()
		newtile.set_letter(tilename)
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 + 165))
		add_child(newtile)


func newgame_deal_out_some_tiles():
	#player1
	var tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#$"phase singleton".active_player.connect(newtile._on_active_player)
		
		newtile.set_letter(tilename)
		player1hand.append(tilename)
		emit_signal("add_tile_to_player1_inventory",newtile)
		
	#player2
	tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		newtile.set_letter(tilename)
		player2hand.append(tilename)
		emit_signal("add_tile_to_player2_inventory",newtile)

	#player3
	tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		newtile.set_letter(tilename)
		player3hand.append(tilename)
		emit_signal("add_tile_to_player3_inventory",newtile)
		
	#dealer
	#add in one blank and QXZJ
	$bag.add_remaining_letters()
	tiles = $bag.draw_seven()
	for i in 7:
		var tilename = "blank" if tiles[i] == 1 else String.chr(tiles[i])
		dealerhand.append(tilename)
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		newtile.set_letter(tilename)
		newtile.set_position(Vector2((i+1)*30,(i+1)*50 + 165))
		add_child(newtile)


func evaluate_hands():
	$"dealerUI/DealZone Player1".evaluate()
	$"dealerUI/DealZone Player2".evaluate()
	$"dealerUI/DealZone Player3".evaluate()


func _on_evaluatehandsbutton_pressed():
	evaluate_hands()


func _on_timer_timeout():
	evaluate_hands()
	#$"dealerUI/DealZone Player1/acceptor".cleanup()
	#$"dealerUI/DealZone Player2/acceptor".cleanup()
	#$"dealerUI/DealZone Player3/acceptor".cleanup()
