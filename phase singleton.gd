extends Node


var STEP_DEALING = 0
var STEP_PLAYING = 1
var STEP_ANIMATING = 2

var player1
var player2
var player3
var active_player
var active_step
var is_opening


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	player1 = get_parent().get_node("dealerUI").get_node("DealZone Player1")
	player2 = get_parent().get_node("dealerUI").get_node("DealZone Player2")
	player3 = get_parent().get_node("dealerUI").get_node("DealZone Player3")
	#start the game
	is_opening = true
	set_active_player(1, STEP_PLAYING)
	player1turn()


func set_active_player(n, step):
	if n == 1:
		active_player = player1
	elif n == 2:
		active_player = player2
	elif n == 3:
		active_player = player3
	active_step = step
	player1.get_node("Arrow").set_visible(n == 1)
	player2.get_node("Arrow").set_visible(n == 2)
	player3.get_node("Arrow").set_visible(n == 3)


func player1turn():
	player1.play_turn()
	active_step = STEP_ANIMATING
	$TimerFirstTurn1.start(1)


func _on_timer_first_turn_1_timeout():
	if is_opening:
		set_active_player(2, STEP_PLAYING)
		player2turn()
	else:
		nextphase()


func player2turn():
	player2.play_turn()
	active_step = STEP_ANIMATING
	$TimerFirstTurn2.start(1)


func _on_timer_first_turn_2_timeout():
	if is_opening:
		set_active_player(3, STEP_PLAYING)
		player3turn()
	else:
		nextphase()


func player3turn():
	player3.play_turn()
	active_step = STEP_ANIMATING
	$TimerFirstTurn3.start(1)


func _on_timer_first_turn_3_timeout():
	nextphase()


func play_turn():
	active_step = STEP_PLAYING
	if active_player == player1:
		player1turn()
	elif active_player == player2:
		player2turn()
	elif active_player == player3:
		player3turn()


func nextphase():
	if active_player == player1:
		set_active_player(2, STEP_DEALING)
	elif active_player == player2:
		set_active_player(3, STEP_DEALING)
	elif active_player == player3:
		set_active_player(1, STEP_DEALING)
