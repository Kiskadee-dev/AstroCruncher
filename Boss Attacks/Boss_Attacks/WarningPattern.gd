extends "res://Boss Attacks/Boss_Attacks/Base_Attack.gd"

var donext:bool = true

func _ready():
	._on_ready()
	repeated = 0
	reapeat_times = 1

func warnpat():
	var a = area_attack.instance()
	get_parent().add_child(a)
	a.start_attack()
	yield(a, "attack_finished")
	emit_signal("attack_finished")

func _process(delta):
	._on_update()
	if attacking and donext:
		donext = false
		if repeated < reapeat_times:
			repeated+=1
			var a = area_attack.instance()
			get_parent().get_parent().add_child(a)
			a.start_attack()
			a.connect("attack_finished", self, "next")
		else:
			.finished()

func next():
	donext = true
