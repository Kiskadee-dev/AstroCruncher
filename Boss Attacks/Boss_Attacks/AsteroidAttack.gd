extends "res://Boss Attacks/Boss_Attacks/Base_Attack.gd"

var donext:bool = true

func _ready():
	._on_ready()
	repeated = 0
	reapeat_times = 1

func asteroid_attack():
	var es = get_node("../EnemySpawner")
	es.register_wave(es.Wave1)
	emit_signal("attack_finished")

func _process(_delta):
	if attacking and donext:
		donext = false
		if repeated < reapeat_times:
			repeated+=1
			var es = get_parent().get_node("../EnemySpawner")
			var asteroid = es.register_wave(es.Wave1, false)
			asteroid.connect("wave_finished", self, "next")
		else:
			attacking = false
			emit_signal("attack_finished")

func next(a):
	donext = true
