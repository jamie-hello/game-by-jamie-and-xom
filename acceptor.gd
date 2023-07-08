extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cleanup():
	var tiles = get_parent().get_node("evaluator").get_overlapping_areas()
	for n in tiles.size():
		if !tiles[n].is_in_group("tile"):
			pass
			#tiles.remove_at(n)
		else:
			tiles[n].position = get_parent().get_children()[n].global_position

func _on_tile_placeholder_instance_released_tile_from_mouse(tile):
	var overlapping = get_overlapping_areas()
	var tilecheck = tile.get_node("clickbox")
	for n in overlapping:
		if tilecheck == n:
			if get_parent().tiles_in_hand < 7:
				var target = get_parent().get_children()[get_parent().tiles_in_hand].global_position
				print(target)
				tile.rest_point = target
				tile.position = target
			else:
				pass
				
	
			#place the tile correctly
