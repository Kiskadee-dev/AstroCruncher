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
	player_stats.damage(80)
	yield(yield_for(7), YIELD)
	assert_eq(player_stats.health, 100.0, "HP no máximo")
	assert_eq(player_stats.lifes, 2, "2 vidas")

func test_powerup():
	gut.simulate(player_instance, 20, .1)
	gut.simulate(player_stats, 300, .1)
	assert_eq(player_stats.powers, player_stats.powerups.none, "Nao deve ter poderes ainda")
	player_stats.powerup(player_stats.powerups.triple)
	assert_eq(player_stats.powers, player_stats.powerups.triple)
	assert_false(player_stats.triple_timer.is_stopped(), "Poder triplo ativo")
	yield(yield_for(7), YIELD)
	assert_true(player_stats.powerup_timer.is_stopped(), "Tempo de poder triplo acaba")
	assert_eq(player_stats.powers, player_stats.powerups.none, "Nao deve ter mais poderes")
func after_each():
	scene_instance.queue_free()


