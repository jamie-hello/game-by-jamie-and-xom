extends Sprite2D

@onready var instance = preload("res://clicksprite.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.button_index == 1:
			$Area2D.set_position(event.position)
			var clickzones = []
			clickzones = $Area2D.get_overlapping_areas()
			if clickzones.is_empty():
				var instnc = instance.instantiate()
				instnc.set_position(event.position)
				add_child(instnc)
				print("Mouse Click/Unclick at: ", event.position)
				pass
			
