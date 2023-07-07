extends Node
@onready var instance = preload("res://tile_(placeholder_instance).tscn")

func _ready():
	deal_out_some_tiles()


func _process(delta):
	pass


func deal_out_some_tiles():
	for x in range(7):
		var rand = randi_range(1,27)
		var newtile = instance.instantiate()
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

		newtile.set_position(Vector2((x+1)*80,(x+1)*70))
		add_child(newtile)
		
