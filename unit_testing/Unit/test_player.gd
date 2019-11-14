extends "res://addons/gut/test.gd"

onready var scene = preload("res://unit_testing/test_scene.tscn")
onready var player = preload("res://Player/player.tscn")
var scene_instance
var player_instance

func before_each():
	scene_instance = scene.instance()
	player_instance = player.instance()
	add_child(scene_instance)
	scene_instance.add_child(player_instance)

func test_life():
	assert_eq(player_stats.lifes, 3, "Vidas no máximo")
	assert_eq(player_stats.health, 100.0, "HP no máximo")
	player_stats.damage(50)
	assert_eq(player_stats.health, 50.0, "HP na metade devido ao dano")

func after_each():
	scene_instance.queue_free()


