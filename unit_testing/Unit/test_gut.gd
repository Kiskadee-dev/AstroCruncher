extends "res://addons/gut/test.gd"

func test_gut():
	gut.p("ran")
	assert_true(true, "Must pass")
