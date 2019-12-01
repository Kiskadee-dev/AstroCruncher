extends Node2D

var play_area = Rect2()
onready var swarm_attacker = preload("res://swarm_attacker.tscn")
onready var swarm_attacker2 = preload("res://swarm_attacker2_ring.tscn")
onready var swarm_attacker3 = preload("res://swarm_attacker3_slow_ring.tscn")
onready var area_attack = preload("res://Boss Attacks/Warning_area_boss_attack.tscn")

signal attack_finished

onready var cooldown_timer:Timer = Timer.new()

var reapeat_times:int
var repeated:int
var attacking:bool = false

func _on_ready():
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	play_area = get_viewport().get_visible_rect()

func _on_update():
	if player_stats.boss_health <= 0 and attacking:
		finished()

func finished():
	attacking = false
	emit_signal("attack_finished")

func start_attack():
	attacking = true
