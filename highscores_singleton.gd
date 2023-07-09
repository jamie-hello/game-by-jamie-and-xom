extends Node


var runs = [] #[(total,high,low),(total,high,low)]
var newestrun = [0,0,0]


func _ready():
#	runs.append([-666,-666,-666])
#	runs.append([-666,-666,-666])
#	runs.append([-666,-666,-666])
	pass
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)
#	RecordNewRun(randi() %1000,randi() %1000,randi() %1000)


func load_scores():
	if FileAccess.file_exists("user://scores.json"):
		var file = FileAccess.open("user://scores.json", FileAccess.READ)
		if file != null:
			var data = file.get_var()
			runs = data
	while runs.size() < 3:
		runs.append([-666,-666,-666])


func save_scores():
	var file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	if file != null:
		file.store_var(runs)


func RecordNewRun(totalscore,highscorer,lowscorer):
	newestrun=[totalscore,highscorer,lowscorer]
	load_scores()
	for i in 3:
		if runs[i][0] == -666:
			runs[i][0] = totalscore
			runs[i][1] = highscorer
			runs[i][2] = lowscorer
			return
	runs.append([totalscore,highscorer,lowscorer])
	save_scores()


func get_newest_hiscore():
	return newestrun


func get_three_highest_scores():
	return sort_highest_scores()


func get_three_lowest_scores():
	return sort_lowest_scores()


func sort_highest_scores():
	var result_p = [[], [], []]
	for col in 3:
		for line in runs:
			result_p[col].append(line[col])
	for col in 3:
		result_p[col].sort()
	return [[result_p[0][result_p[0].size() - 1], result_p[1][result_p[1].size() - 1], result_p[2][result_p[2].size() - 1]], [result_p[0][result_p[0].size() - 2], result_p[1][result_p[1].size() - 2], result_p[2][result_p[2].size() - 2]], [result_p[0][result_p[0].size() - 3], result_p[1][result_p[1].size() - 3], result_p[2][result_p[2].size() - 3]]]


func sort_lowest_scores():
	var result_p = [[], [], []]
	for col in 3:
		for line in runs:
			result_p[col].append(line[col])
	for col in 3:
		result_p[col].sort()
	return [[result_p[0][2], result_p[1][2], result_p[2][2]], [result_p[0][1], result_p[1][1], result_p[2][1]], [result_p[0][0], result_p[1][0], result_p[2][0]]]
