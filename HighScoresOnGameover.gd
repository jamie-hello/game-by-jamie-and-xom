extends Control

@onready var HighTotal = $highscores_/total
@onready var HighWinner = $highscores_/winner
@onready var HighLoser = $highscores_/loser
@onready var LowTotal = $lowscores_/total
@onready var LowWinner = $lowscores_/winner
@onready var LowLoser = $lowscores_/loser
@onready var resultofthisgame = $"result of this game"



func display_scores():
	var threehighest = HighscoresSingleton.get_three_highest_scores()
	HighTotal.text = (str(threehighest[0][0]) + "\n" + str(threehighest[1][0]) + "\n" + str(threehighest[2][0]))
	HighWinner.text = (str(threehighest[0][1]) + "\n" + str(threehighest[1][1]) + "\n" + str(threehighest[2][1]))
	HighLoser.text = (str(threehighest[0][2]) + "\n" + str(threehighest[1][2]) + "\n" + str(threehighest[2][2]))
	var threelowest = HighscoresSingleton.get_three_lowest_scores()
	LowTotal.text = (str(threehighest[0][0]) + "\n" + str(threehighest[1][0]) + "\n" + str(threehighest[2][0]))
	LowWinner.text = (str(threehighest[0][1]) + "\n" + str(threehighest[1][1]) + "\n" + str(threehighest[2][1]))
	LowLoser.text = (str(threehighest[0][2]) + "\n" + str(threehighest[1][2]) + "\n" + str(threehighest[2][2]))
	var newestrun = HighscoresSingleton.get_newest_hiscore()
	resultofthisgame.text = (str(newestrun[0])+"                    "+str(newestrun[1])+"                       "+str(newestrun[2]))
	
	var tweeen = create_tween()
	tweeen.tween_property(self,"position",Vector2(100,150),1)

func _on_button_pressed():
	#close the scores
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(100,1000),1)
