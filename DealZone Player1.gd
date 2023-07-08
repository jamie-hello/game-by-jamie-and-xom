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


func _on_main_add_tile_to_player_1_inventory(newtile):
	
	newtile.set_position(get_children()[addcount].global_position)
	add_child(newtile)
	addcount = addcount+1
	
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
	print("player1's letters: ",Letters_as_string)
