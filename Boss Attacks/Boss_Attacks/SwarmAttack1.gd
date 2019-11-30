extends "res://Boss Attacks/Boss_Attacks/Base_Attack.gd"

var donext:bool = true

func _ready():
	._on_ready()
	repeated = 0
	reapeat_times = 10

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

func _process(delta):
	._on_update()
	if attacking and donext:
		donext = false
		if repeated < reapeat_times:
			repeated+=1
			var x = rand_range(play_area.position.x+20, play_area.end.x-20)
			var y = rand_range(play_area.position.y+20, play_area.end.y-20)
			var s = swarm_attacker.instance()
			get_parent().get_parent().add_child(s)
			s.global_position = Vector2(x,y)
			s.attack(10, 1000)
			s.connect("shooting_finished", self, "next")
		else:
			.finished()

func next():
	donext = true
