extends "res://addons/gut/test.gd"

onready var scene = preload("res://unit_testing/test_scene.tscn")
onready var player = preload("res://Player/player.tscn")
var scene_instance
var player_instance

func before_each():
	scene_instance = scene.instance()
	add_child(scene_instance)
	player_instance = player.instance()
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

func test_shoot():
	assert_eq(player_instance.get_parent(), scene_instance)
	gut.simulate(player_instance, 300, .1)
	var b = player_instance.shoot_bullet()

func test_collision():
	assert_false(player_stats.dead, "Player não pode estar morto aqui")
	gut.simulate(player_instance, 300, .1)
	var asteroid = preload("res://Enemies/Asteroid.tscn")
	asteroid = asteroid as PackedScene
	player_instance.position = Vector2(100, 100)
	var b = asteroid.instance()
	b.position = Vector2(300,300)
	scene_instance.add_child(b)
	b.scale = Vector2(3,3)
	gut.simulate(b, 300, .1)
	yield(yield_for(5), YIELD)
	assert_is(b, Node2D, "b é um node2D")
	assert_true(b.is_in_group("enemy"), "b está no grupo enemy")
	assert_true(player_instance.is_in_group("player"), "Jogador está no grupo jogador")
	player_instance.position = b.position
	yield(yield_for(5), YIELD)
	assert_lt(player_stats.health, 100, "A vida precisa estar menor já que tomou dano")

func after_each():
	for i in BulletsPool.active_objects:
		for j in BulletsPool.active_objects[i]:
			j.queue_free()
	for i in BulletsPool.inactive_objects:
		for j in BulletsPool.inactive_objects[i]:
			j.queue_free()
	
	player_stats.dead = false

	BulletsPool.active_objects = {}
	BulletsPool.inactive_objects = {}
	player_stats.lifes = 3
	player_stats.health = 100.0
	player_instance.queue_free()
	scene_instance.queue_free()

