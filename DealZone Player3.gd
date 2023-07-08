extends Node2D
var count = 0
var Letters_as_string = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_add_tile_to_player_3_inventory(newtile):
	
	newtile.set_position(get_children()[count].global_position)
	add_child(newtile)
	count = count+1
	
func evaluate():
	Letters_as_string = ""
	var tiles = $evaluator.get_overlapping_areas()
	print("overlapping areas: ", tiles.size())
	for n in len(tiles):
		if !tiles[n].is_in_group("tile"):
			tiles.remove_at(n)
		else:
			Letters_as_string = Letters_as_string + (tiles[n].get_parent().Letter + " ")
	print("player3's letters: ",Letters_as_string)
