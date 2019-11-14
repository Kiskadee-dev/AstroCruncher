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

func test_blink():
	gut.simulate(player_instance, 300, .1)
	assert_true(player_instance.visible, "Jogador deve estar vivo")
	player_stats.damage(110)
	yield(yield_for(1), YIELD)
	assert_true(player_stats.dead, "Jogador morreu")
	assert_false(player_instance.visible, "Jogador invisivel")
	yield(yield_for(3), YIELD)
	assert_true(player_instance.get_node("AnimationPlayer").is_playing(), "Animador deve estar tocando")
	assert_eq(player_instance.get_node("AnimationPlayer").current_animation, "blink", "Deve estar piscando")
	
func after_each():
	player_stats.lifes = 3
	player_stats.health = 100.0
	scene_instance.queue_free()
	player_instance.queue_free()


