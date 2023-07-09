extends Control


@onready var CurrentScore = $CurrentScore
@onready var newscorepopup = $"newScore Popup"


func _on_deal_zone_player_new_score(wordscore,word,isOpening):
	if not isOpening:
		CurrentScore.set_text(str(get_parent().score))
		CurrentScore.show()
		newscorepopup.get_node("Label").set_visible(0)
		newscorepopup.set_text(word+" +"+str(wordscore))
	else:
		newscorepopup.set_text(word+" ("+str(wordscore)+")")
	newscorepopup.set_position(Vector2(-218,10))
	newscorepopup.set_modulate(Color(1,1,1,1))
	newscorepopup.get_node("Label").set_text("(First turn, No Score)")
	var tween = newscorepopup.create_tween()
	tween.tween_property(newscorepopup,"position",Vector2(-186,-20),1.50)
	tween.tween_property(newscorepopup,"modulate",Color(1,1,1,0),.90)
