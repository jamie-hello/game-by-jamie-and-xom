extends Node

var runs = [] #[(total,high,low),(total,high,low)]
var newestrun = [0,0,0]

func _ready():
	runs.append([-666,-666,-666])
	runs.append([-666,-666,-666])
	runs.append([-666,-666,-666])

func RecordNewRun(totalscore,highscorer,lowscorer):
	newestrun=[totalscore,highscorer,lowscorer]
	for i in 3:
		if runs[i][0] == -666:
			runs[i][0] = totalscore
			runs[i][1] = highscorer
			runs[i][2] = lowscorer
			return
	runs.append([totalscore,highscorer,lowscorer])
	pass


func get_newest_hiscore():
	return newestrun


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
