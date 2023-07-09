extends Node

var runs = [] #[(total,high,low),(total,high,low)]
var newestrun = [0,0,0]

func _ready():
	runs.append([0,0,0])
	runs.append([0,0,0])
	runs.append([0,0,0])

func RecordNewRun(totalscore,highscorer,lowscorer):
	newestrun=[totalscore,highscorer,lowscorer]
	runs.append([totalscore,highscorer,lowscorer])
	pass


func get_newest_hiscore():
	return newestrun
	pass
func get_three_highest_scores():
	sort_highest_scores()
	var threehighest = []
	for i in 3:
		threehighest.append(runs[i])
	return threehighest

func get_three_lowest_scores():
	sort_highest_scores()
	var threelowest = []
	for i in 3:
		threelowest.append(runs[-(i+1)])
	return threelowest

func sort_highest_scores():
	runs.sort_custom(func(a,b): return a[0] > b[0])
	pass
