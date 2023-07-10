extends CanvasLayer


signal hand_card_pressed(pos)


@onready var cards = [$HandCard0, $HandCard1, $HandCard2, $HandCard3, $HandCard4, $HandCard5, $HandCard6]
var tiles_left = 84


func show_card(pos, glyph, sub_script):
	cards[pos].get_node("Glyph").text = glyph
	cards[pos].get_node("SubScript").text = sub_script
	cards[pos].show()


func hide_card(pos):
	cards[pos].hide()


func _on_hand_card_0_pressed():
	hand_card_pressed.emit(0)


func _on_hand_card_1_pressed():
	hand_card_pressed.emit(1)


func _on_hand_card_2_pressed():
	hand_card_pressed.emit(2)


func _on_hand_card_3_pressed():
	hand_card_pressed.emit(3)


func _on_hand_card_4_pressed():
	hand_card_pressed.emit(4)


func _on_hand_card_5_pressed():
	hand_card_pressed.emit(5)


func _on_hand_card_6_pressed():
	hand_card_pressed.emit(6)


func _on_scores_button_pressed():
	print($"../PhaseSingleton".active_step)
#	$"../HighScoresOnGameover".display_scores()
	$"../WordAI".do_debug()


func _on_new_game_button_pressed():
	$NewGameButton.hide()
	$"..".restart_game()
