extends Label

var highscore:bool = false
var header = "Your Score: "
var body = "Best score: "
var footer = "Congratulations on your new score!"

func _ready():
	var score = player_stats.score_sum()
	var old_highscore = ScoreSys.getScore()
	if score > old_highscore:
		highscore = true
		ScoreSys.setScore(score)
	var final = ""
	final = header+str(score)+'\n'
	if old_highscore > 0:
		final = final+body+str(old_highscore)+'\n'
	if highscore:
		final = final+footer
	text = final
