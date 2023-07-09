extends Control

@onready var CurrentScore = $CurrentScore
@onready var newscorepopup = $"newScore Popup"
func _process(delta):
	CurrentScore.set_text(str(get_parent().score))
	pass
	




func _on_deal_zone_player_new_score(wordscore,word):
	newscorepopup.set_position(Vector2(-218,10))
	newscorepopup.set_modulate(Color(1,1,1,1))
	newscorepopup.set_text(word+" +"+str(wordscore))
	var tween = newscorepopup.create_tween()
	tween.tween_property(newscorepopup,"position",Vector2(-186,-20),1.50)
	tween.tween_property(newscorepopup,"modulate",Color(1,1,1,0),.90)
	print("newscorepopup")
