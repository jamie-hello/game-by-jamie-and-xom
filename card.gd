extends Sprite2D


signal done_moving(id)


var SPEED = 16
var signal_id = 0
var destination_x = 0
var destination_y = 0
var destination_scale = 1
var moving = false


func _ready():
	pass # Replace with function body.


func _process(delta):
	if moving:
		var old_scale = scale.x
		var old_x = position.x
		var old_y = position.y
		if destination_x < old_x:
			position.x -= SPEED * (old_scale + 1)
			position.x = clamp(position.x, destination_x, old_x)
		else:
			position.x += SPEED * (old_scale + 1)
			position.x = clamp(position.x, old_x, destination_x)
		if destination_y < old_y:
			position.y -= SPEED * (old_scale + 1)
			position.y = clamp(position.y, destination_y, old_y)
		else:
			position.y += SPEED * (old_scale + 1)
			position.y = clamp(position.y, old_y, destination_y)
		if position.x == destination_x and position.y == destination_y:
			scale.x = destination_scale
			scale.y = destination_scale
			moving = false
			var old_signal_id = signal_id
			signal_id = 0
			done_moving.emit(old_signal_id)
		else:
			scale.x = old_scale * .95 + destination_scale * .05
			scale.y = scale.x
