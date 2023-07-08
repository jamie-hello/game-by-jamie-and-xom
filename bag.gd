extends Node2D

var contents = []

func newbagnewgame():
	for a in 9:
		contents.append("A")
	for b in 2:
		contents.append("B")
	for c in 2:
		contents.append("C")
	for d in 5:
		contents.append("D")
	for e in 13:
		contents.append("E")
	for F in 2:
		contents.append("F")
	for G in 3:
		contents.append("G")
	for H in 3:
		contents.append("H")
	for I in 9:
		contents.append("I")
		#j
	for k in 1:
		contents.append("K")
	for l in 4:
		contents.append("L")
	for m in 2:
		contents.append("M")
	for n in 6:
		contents.append("N")
	for o in 8:
		contents.append("O")
	for p in 2:
		contents.append("P")
		#q
	for r in 6:
		contents.append("R")
	for s in 5:
		contents.append("S")
	for t in 7:
		contents.append("T")
	for u in 4:
		contents.append("U")
	for v in 2:
		contents.append("V")
	for w in 2:
		contents.append("W")
	for y in 2:
		contents.append("Y")
		
	print(contents)
	
	


# Called when the node enters the scene tree for the first time.
func _ready():
	newbagnewgame()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
