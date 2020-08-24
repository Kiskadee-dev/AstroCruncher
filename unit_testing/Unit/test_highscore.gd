extends "res://addons/gut/test.gd"

func before_each():
	player_stats.new_game()
	var d = Directory.new()
	d.remove(ScoreSys.path)

func test_hs():
	for i in range(30):
		player_stats.add_score(100)
	assert_eq(player_stats.score, 0, "Level score must be 0")
	assert_eq(player_stats.score_sum(), 3000, "Sum of score must be 3000")
	assert_eq(player_stats.lifes, 6, "Lifes must be 6")

func test_saved_hs():
	ScoreSys.createFile()
	assert_eq(ScoreSys.getScore(), 0, "Initial saved score must be 0")
	ScoreSys.setScore(20)
	assert_eq(ScoreSys.getScore(), 20, "Saved score must be 20")

func after_each():
	player_stats.new_game()
	var d = Directory.new()
	d.remove(ScoreSys.path)
