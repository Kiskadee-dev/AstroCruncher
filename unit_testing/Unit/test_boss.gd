extends "res://addons/gut/test.gd"

func test_boss_health():
	assert_eq(player_stats.boss_health, 5000, "Boss health is 5000")
