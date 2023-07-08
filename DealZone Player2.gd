extends Node2D
var addcount = 0
var Letters_as_string = ""
var tiles_in_hand=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var tileholder = []
func _on_main_add_tile_to_player_2_inventory(newtile):
	
	tileholder.append(newtile)
	var cards_in_hand = get_parent().get_parent().player2hand.size()
	newtile.set_position(get_children()[cards_in_hand-1].global_position)
	add_child(newtile)
	addcount = addcount+1
	newtile.drawn_by_player()
	
func evaluate():
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
	print("player2's letters: ",Letters_as_string)
