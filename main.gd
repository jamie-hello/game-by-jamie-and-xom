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
	for x in range(7):
		var rand = randi_range(0,$bag.contents.size()-1)
		var newtile = instance.instantiate()
		var to_hand = $bag.contents.pop_at(rand)
		newtile.set_letter(to_hand)
		dealerhand.append(to_hand)
		newtile.set_position(Vector2((x+1)*30,(x+1)*50 + 165))
		add_child(newtile)
	
	pass
	


func newgame_deal_out_some_tiles():
	
	#player1
	for x in range(7):
		var rand = randi_range(0,$bag.contents.size()-1)
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#$"phase singleton".active_player.connect(newtile._on_active_player)
		
		#matchit(newtile,rand)
		var to_hand = $bag.contents.pop_at(rand)
		newtile.set_letter(to_hand)
		player1hand.append(to_hand)
		emit_signal("add_tile_to_player1_inventory",newtile)
		
	#player2
	for x in range(7):
		var rand = randi_range(0,$bag.contents.size()-1)
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		var to_hand = $bag.contents.pop_at(rand)
		newtile.set_letter(to_hand)
		player2hand.append(to_hand)
		emit_signal("add_tile_to_player2_inventory",newtile)

	#player3
	for x in range(7):
		var rand = randi_range(0,$bag.contents.size()-1)
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		var to_hand = $bag.contents.pop_at(rand)
		newtile.set_letter(to_hand)
		player3hand.append(to_hand)
		emit_signal("add_tile_to_player3_inventory",newtile)
		
	#dealer
	#add in one blank and QXZJ
	$bag.contents.append("blank")
	$bag.contents.append("blank")
	$bag.contents.append("Q")
	$bag.contents.append("X")
	$bag.contents.append("Z")
	$bag.contents.append("J")
	for x in range(7):
		var rand = randi_range(0,$bag.contents.size()-1)
		var newtile = instance.instantiate()
		
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player1/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player2/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		#newtile.released_tile_from_mouse.connect(get_node("dealerUI/DealZone Player3/acceptor")._on_tile_placeholder_instance_released_tile_from_mouse)
		
		var to_hand = $bag.contents.pop_at(rand)
		newtile.set_letter(to_hand)
		dealerhand.append(to_hand)
		newtile.set_position(Vector2((x+1)*30,(x+1)*50 + 165))
		add_child(newtile)
		
func matchit(newtile,rand):
	
	match rand:
		1:
			newtile.set_letter("A")
		2:
			newtile.set_letter("B")
		3:
			newtile.set_letter("C")
		4:
			newtile.set_letter("D")
		5:
			newtile.set_letter("E")
		6:
			newtile.set_letter("F")
		7:
			newtile.set_letter("G")
		8:
			newtile.set_letter("H")
		9:
			newtile.set_letter("I")
		10:
			newtile.set_letter("J")
		11:
			newtile.set_letter("K")
		12:
			newtile.set_letter("L")
		13:
			newtile.set_letter("M")
		14:
			newtile.set_letter("N")
		15:
			newtile.set_letter("O")
		16:
			newtile.set_letter("P")
		17:
			newtile.set_letter("Q")
		18:
			newtile.set_letter("R")
		19:
			newtile.set_letter("S")
		20:
			newtile.set_letter("T")
		21:
			newtile.set_letter("U")
		22:
			newtile.set_letter("V")
		23:
			newtile.set_letter("W")
		24:
			newtile.set_letter("X")
		25:
			newtile.set_letter("Y")
		26:
			newtile.set_letter("Z")
		27:
			newtile.set_letter("blank")
	
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
