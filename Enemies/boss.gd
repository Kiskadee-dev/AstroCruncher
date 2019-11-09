extends Node2D

var health:float = 1000

var play_area = Rect2()

var swarm_attacker = preload("res://swarm_attacker.tscn")
var swarm_attacker2 = preload("res://swarm_attacker2_ring.tscn")
var area_attack = preload("res://Boss Attacks/Warning_area_boss_attack.tscn")

signal attack_finished

func _ready():
	play_area = get_viewport().get_visible_rect()

func start_boss():
	while health > 0:
		swarm_attack()
		yield(self, "attack_finished")
		swarm_attack2()
		yield(self, "attack_finished")
		warnpat()
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