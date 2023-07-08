extends Node

var wawawa="w"
var player1 =  ""
var player2 = ""
var player3 = ""
var active_turn

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
	player1firstturn()
	pass # Replace with function body.


func player1firstturn():
	#active_turn=player1
	player1.get_node("Arrow").set_visible(true)
	player1.play_turn()
	$TimerFirstTurn1.start(1)


func _on_timer_first_turn_1_timeout():
	player1.get_node("Arrow").set_visible(false)
	player2firstturn()
	pass # Replace with function body.

func player2firstturn():
	#active_turn=player2
	player2.get_node("Arrow").set_visible(true)
	player2.play_turn()
	$TimerFirstTurn2.start(1)


func _on_timer_first_turn_2_timeout():
	player2.get_node("Arrow").set_visible(false)
	player3firstturn()
	pass # Replace with function body.
	
func player3firstturn():
	#active_turn=player3
	player3.get_node("Arrow").set_visible(true)
	player3.play_turn()
	$TimerFirstTurn3.start(1)
	pass


func _on_timer_first_turn_3_timeout():
	player3.get_node("Arrow").set_visible(false)
	player1nextturn()
	pass # Replace with function body.

func nextphase():
	if active_turn == player1:
		player2nextturn()
	elif active_turn == player2:
		player3nextturn()
	elif active_turn == player3:
		player1nextturn()
	pass

func player1nextturn():
	active_turn=player1
	print("active player: ",active_turn)
	player3.get_node("Arrow").set_visible(false)
	player1.get_node("Arrow").set_visible(true)
	#get_parent().player1hand.size()
	
func player2nextturn():
	active_turn=player2
	print("active player: ",active_turn)
	player1.get_node("Arrow").set_visible(false)
	player2.get_node("Arrow").set_visible(true)
	#get_parent().player2hand.size()
func player3nextturn():
	active_turn=player3
	print("active player: ",active_turn)
	player2.get_node("Arrow").set_visible(false)
	player3.get_node("Arrow").set_visible(true)
	#get_parent().player3hand.size()
	
