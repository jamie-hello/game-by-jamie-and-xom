extends Node2D
var addcount = 0
var Letters_as_string = ""
var tiles_in_hand = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var tileholder = []
func _on_main_add_tile_to_player_3_inventory(newtile):
	
	tileholder.append(newtile)
	var cards_in_hand = get_parent().get_parent().player3hand.size()
	newtile.set_position(get_children()[cards_in_hand-1].global_position)
	add_child(newtile)
	addcount = addcount+1
	newtile.drawn_by_player()
	
func playfirstturn():
	for x in 5: #player three plays 5 tiles for testing
		var randomtile = randi_range(0,tileholder.size()-1)
		var chosentile = tileholder.pop_at(randomtile)
		get_parent().get_parent().player3hand.pop_at(randomtile)
		chosentile.global_position = Vector2(randi_range(300,790),(randi_range(160,370)))
		chosentile.rest_point = chosentile.global_position
	cleanup()
	pass

func cleanup():
	for n in (tileholder.size()):
		tileholder[n].global_position = get_children()[n].global_position
		tileholder[n].rest_point = tileholder[n].global_position
	pass
	
func add_a_tile(tile):
	tileholder.append(tile)
	var dealerhand = get_parent().get_parent().dealerhand
	tile.global_position = get_children()[get_parent().get_parent().player3hand.size()].global_position #playerx
	tile.rest_point = tile.global_position
	tile.drawn_by_player()
	get_parent().get_parent().player3hand.append(tile.Letter) #playerx
	print(get_parent().get_parent().player3hand) #playerx
	if tileholder.size() == 7:
		get_parent().get_parent().get_node("phase singleton").nextphase()
	dealerhand.pop_at(dealerhand.find(tile.Letter))
	print("dealerhand: ",dealerhand) 
	if dealerhand.size() == 0:
		print("The Bag is out of tiles to deal. refreshing...")
		get_parent().get_parent().dealer_newhand()
	pass
	
func evaluate():
	"""
	tiles_in_hand=0
	Letters_as_string = ""
	var tiles = $evaluator.get_overlapping_areas()
	for n in tiles.size():
		if !tiles[n].is_in_group("tile"):
			pass
			#tiles.remove_at(n)
		else:
			Letters_as_string = Letters_as_string + (tiles[n].get_parent().Letter + " ")
			tiles_in_hand = tiles_in_hand + 1
			"""
	print("player3's letters: ",get_parent().get_parent().player3hand)
