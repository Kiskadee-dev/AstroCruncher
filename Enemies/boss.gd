extends Node2D

var health:float = 10000

var play_area = Rect2()

var swarm_attacker = preload("res://swarm_attacker.tscn")
var swarm_attacker2 = preload("res://swarm_attacker2_ring.tscn")
var swarm_attacker3 = preload("res://swarm_attacker3_slow_ring.tscn")
var area_attack = preload("res://Boss Attacks/Warning_area_boss_attack.tscn")
onready var bullet_explosion_effect = preload("res://explosion_bullet.tscn")

signal attack_finished

func _ready():
	play_area = get_viewport().get_visible_rect()

func start_boss():
	while health > 0:
		randomize()
		swarm_attack()
		yield(self, "attack_finished")
		swarm_attack2()
		yield(self, "attack_finished")
		warnpat()
		swarm_attack4()
		yield(self, "attack_finished")
		swarm_attack3()
		swarm_attack()
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		warnpat()
		swarm_attack3()
		swarm_attack()
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		swarm_attack()
		swarm_attack()
		swarm_attack()
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		warnpat()
		swarm_attack3()
		swarm_attack()
		asteroid_attack()
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		yield(self, "attack_finished")
		yield(self, "attack_finished")

func swarm_attack():
	for i in range(10):
		var x = rand_range(play_area.position.x+20, play_area.end.x-20)
		var y = rand_range(play_area.position.y+20, play_area.end.y-20)
		var s = swarm_attacker.instance()
		get_parent().add_child(s)
		s.global_position = Vector2(x,y)
		s.attack(10, 1000)
		yield(s, "shooting_finished")
	emit_signal("attack_finished")

func swarm_attack2():
	for i in range(10):
		var x = rand_range(play_area.position.x+20, play_area.end.x-20)
		var y = rand_range(play_area.position.y+20, play_area.end.y-20)
		var s = swarm_attacker2.instance()
		get_parent().add_child(s)
		s.global_position = Vector2(x,y)
		yield(s, "shooting_finished")
	emit_signal("attack_finished")

func swarm_attack3():
	for i in range(10):
		var x = rand_range(play_area.position.x+20, play_area.end.x-20)
		var y = rand_range(play_area.position.y+20, play_area.end.y-20)
		var s = swarm_attacker.instance()
		get_parent().add_child(s)
		s.global_position = Vector2(x,y)
		s.attack(10, 1000, false)
		yield(s, "shooting_finished")
	emit_signal("attack_finished")

func swarm_attack4():
	var pos:Vector2 = Vector2((get_viewport().get_visible_rect().end.x-get_viewport().get_visible_rect().position.x)/2,(get_viewport().get_visible_rect().end.y-get_viewport().get_visible_rect().position.y)/2)
	for i in range(4):
		var s = swarm_attacker3.instance()
		s.global_position = pos
		get_parent().add_child(s)
		yield(s, "shooting_finished")
		yield(get_tree().create_timer(10), "timeout")

func warnpat():
	var a = area_attack.instance()
	get_parent().add_child(a)
	a.start_attack()
	yield(a, "attack_finished")
	emit_signal("attack_finished")

func asteroid_attack():
	var es = get_node("../EnemySpawner")
	es.wave1()
	yield(es, "wave_finished")
	emit_signal("attack_finished")

func damage(value):
	health -= value
	health = clamp(health, 0, 10000)
	if game_configuration.sfx:
		#AudioPool.play(AudioPool.soundlib.boom)
		if health == 0:
			print("boss dead")

func _on_Damage_Area2D_area_entered(area):
	if visible:
		if area:
			area = area as Area2D
			if area.monitoring:
				var p = area.get_parent()
				if p.is_in_group("player_bullet"):
					if p.visible and not p.hit_someone:
						p.hit_someone = true
						damage(p.damage)
						var ex = bullet_explosion_effect.instance()
						get_parent().add_child(ex)
						ex.position = p.position
						p._unload()