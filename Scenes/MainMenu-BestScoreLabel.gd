extends Label

const _text = "Best Score: {0}"
func _ready():
	text = _text.format({"0":ScoreSys.getScore()})
