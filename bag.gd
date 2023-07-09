extends Node2D



@onready var clickspriteinstance = preload("res://clicksprite.tscn")

var DECK = [9, 2, 2, 5, 13, 2, 3, 3, 9, 1, 1, 4, 2, 6, 8, 2, 1, 6, 5, 7, 4, 2, 2, 1, 2, 1]
var contents = []
var wildcard_played = false
signal draw7


func newbagnewgame():
	contents = []
	wildcard_played = false
	for i in DECK.size():
		for j in DECK[i] - 1: # save one of each letter from being dealt into starting hands
			contents.append(65 + i) # ASCII


func add_remaining_letters():
	for i in DECK.size():
		contents.append(65 + i)
	contents.append(1) # save other wildcard until first is used


func draw_seven():
	if contents.is_empty():
		return []
	if contents.size() == 6:
		set_wildcard_played()
	var result = []
	for i in 7:
		var r = randi() % contents.size()
		result.append(contents[r])
		contents[r] = contents[contents.size() - 1]
		contents.resize(contents.size() - 1)
	if contents.size() == 41 and wildcard_played: # add second wildcard when halfway
		contents.append(1)
	emit_signal("draw7")
	return result


func set_wildcard_played():
	if not wildcard_played:
		wildcard_played = true
		if contents.size() <= 41: # else add second wildcard later
			contents.append(1)


func _ready():
	newbagnewgame()
#	pass # Replace with function body.


func _process(delta):
	pass


func _on_main_spawn_a_click_animation():
	
	var newclickanim = clickspriteinstance.instantiate()
	add_child(newclickanim)
	newclickanim.global_position = get_global_mouse_position()
	print("click animation at ", newclickanim.global_position,"  mouse position at ", get_global_mouse_position())
	pass # Replace with function body.
