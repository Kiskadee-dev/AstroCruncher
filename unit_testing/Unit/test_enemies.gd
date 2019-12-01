extends "res://addons/gut/test.gd"
onready var scene = preload("res://unit_testing/test_scene.tscn")
onready var player = preload("res://Player/player.tscn")
var scene_instance
var player_instance:KinematicBody2D

func before_each():
	scene_instance = scene.instance()
	add_child(scene_instance)
	player_instance = player.instance()
	scene_instance.add_child(player_instance)

func test_enemy01():
	pending()

func test_enemy02():
	pending()

var swarm_attacker3 = preload("res://swarm_attacker3_slow_ring.tscn")
func test_enemy03():
	var pos:Vector2 = Vector2((get_viewport().get_visible_rect().end.x-get_viewport().get_visible_rect().position.x)/2,(get_viewport().get_visible_rect().end.y-get_viewport().get_visible_rect().position.y)/2)
	for i in range(4):
		var s = swarm_attacker3.instance()
		s.global_position = pos
		scene_instance.add_child(s)
		watch_signals(s)
		yield(yield_to(s, "shooting_finished", 4), YIELD)
		assert_signal_emitted(s, "shooting_finished")
		yield(get_tree().create_timer(10), "timeout")
	yield(yield_for(10), YIELD)

func after_each():
	for i in BulletsPool.active_objects:
		for j in BulletsPool.active_objects[i]:
			j.queue_free()
	for i in BulletsPool.inactive_objects:
		for j in BulletsPool.inactive_objects[i]:
			j.queue_free()
	
	BulletsPool.active_objects = {}
	BulletsPool.inactive_objects = {}
	player_stats.lifes = 3
	player_stats.health = 100.0
	player_instance.queue_free()
	scene_instance.queue_free()