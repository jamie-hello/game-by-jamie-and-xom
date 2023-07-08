extends Node2D

var clicked = false
var rest_point = Vector2.ZERO
var rest_nodes = []
var Letter = ""
var activeplayer = get_parent()
signal released_tile_from_mouse
signal newlycreatedtile
@onready var LetterTexture = $Sprite2D
var a = preload("res://img/letters/A.png")
var b = preload("res://img/letters/B.png")
var c = preload("res://img/letters/C.png")
var d = preload("res://img/letters/D.png")
var e = preload("res://img/letters/E.png")
var f = preload("res://img/letters/F.png")
var g = preload("res://img/letters/G.png")
var h = preload("res://img/letters/H.png")
var i = preload("res://img/letters/I.png")
var j = preload("res://img/letters/J.png")
var k = preload("res://img/letters/K.png")
var l = preload("res://img/letters/L.png")
var m = preload("res://img/letters/M.png")
var n = preload("res://img/letters/N.png")
var o = preload("res://img/letters/O.png")
var p = preload("res://img/letters/P.png")
var q = preload("res://img/letters/Q.png")
var r = preload("res://img/letters/R.png")
var s = preload("res://img/letters/S.png")
var t = preload("res://img/letters/T.png")
var u = preload("res://img/letters/U.png")
var v = preload("res://img/letters/V.png")
var w = preload("res://img/letters/W.png")
var x = preload("res://img/letters/X.png")
var y = preload("res://img/letters/Y.png")
var z = preload("res://img/letters/Z.png")
var blank = preload("res://img/letters/blank.png")


func _ready():
	rest_nodes = get_tree().get_nodes_in_group("restzone")
	rest_point = self.get_position()
	#LetterTexture.set_texture()

var dealtalready = false
func drawn_by_player():
	dealtalready = true
	pass

func set_letter(lettervalue):
	Letter = lettervalue
	match lettervalue:
		"A":
			$Sprite2D.set_texture(a)
		"B":
			$Sprite2D.set_texture(b)
		"C":
			$Sprite2D.set_texture(c)
		"D":
			$Sprite2D.set_texture(d)
		"E":
			$Sprite2D.set_texture(e)
		"F":
			$Sprite2D.set_texture(f)
		"G":
			$Sprite2D.set_texture(g)
		"H":
			$Sprite2D.set_texture(h)
		"I":
			$Sprite2D.set_texture(i)
		"J":
			$Sprite2D.set_texture(j)
		"K":
			$Sprite2D.set_texture(k)
		"L":
			$Sprite2D.set_texture(l)
		"M":
			$Sprite2D.set_texture(m)
		"N":
			$Sprite2D.set_texture(n)
		"O":
			$Sprite2D.set_texture(o)
		"P":
			$Sprite2D.set_texture(p)
		"Q":
			$Sprite2D.set_texture(q)
		"R":
			$Sprite2D.set_texture(r)
		"S":
			$Sprite2D.set_texture(s)
		"T":
			$Sprite2D.set_texture(t)
		"U":
			$Sprite2D.set_texture(u)
		"V":
			$Sprite2D.set_texture(v)
		"W":
			$Sprite2D.set_texture(w)
		"X":
			$Sprite2D.set_texture(x)
		"Y":
			$Sprite2D.set_texture(y)
		"Z":
			$Sprite2D.set_texture(z)		
		"blank":
			$Sprite2D.set_texture(blank)


	


func _process(delta):
	if clicked:
		#global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		if dealtalready:
			pass
		else:
			var whoseturn = get_parent().get_node("phase singleton").active_turn
			if whoseturn != null:
				if whoseturn.tileholder.size() < 7:
					whoseturn.add_a_tile(self)
					print("added ",Letter," to ",whoseturn)
	else:
		global_position = lerp(global_position, rest_point, 25*delta)
		pass


func _on_clickbox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		clicked = true
		pass

"""
func _input(event):
	if event is InputEventMouse:
		if event.button_mask == 0 and clicked:
			clicked = false
			#if NOT in range 35 of another tile:
			if canplacehere:
				rest_point = get_global_mouse_position()
			emit_signal("released_tile_from_mouse", self)
			"""
			
			
"""			
			var shortest_dist = 35
			var foundRestPoint = false
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist:
					foundRestPoint = true
					rest_point = child.global_position
					shortest_dist = distance
			if !foundRestPoint:
				if true:
					rest_point = get_global_mouse_position()
"""

var canplacehere = true
func _on_area_2d_area_entered(area):
	canplacehere = false

func _on_active_player(p):
	print("newactiveplayer ",p)
	activeplayer=p

func _on_area_2d_area_exited(area):
	canplacehere = true
