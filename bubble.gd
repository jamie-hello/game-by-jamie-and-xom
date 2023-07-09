extends Sprite2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	scale.x = scale.x * .9 + .1
	if scale.x > 0.99:
		queue_free()
	scale.y = scale.y * .9 + .1
	var c = 1 - (scale.x * scale.x)
	self.modulate.a = c
