extends "res://Boss Attacks/Boss_Attacks/Base_Attack.gd"

var donext:bool = true

func _ready():
	._on_ready()
	repeated = 0
	reapeat_times = 4
	cooldown_timer.wait_time = 10

func swarm_attack4():
	var pos:Vector2 = Vector2((get_viewport().get_visible_rect().end.x-get_viewport().get_visible_rect().position.x)/2,(get_viewport().get_visible_rect().end.y-get_viewport().get_visible_rect().position.y)/2)
	for i in range(4):
		var s = swarm_attacker3.instance()
		s.global_position = pos
		get_parent().add_child(s)
		yield(s, "shooting_finished")
		yield(get_tree().create_timer(10), "timeout")

var state:int = 0
func _process(delta):
	._on_update()
	match state:
		0:
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
					state = 1
					cooldown_timer.start()

				else:
					.finished()
		1:
			if donext and cooldown_timer.is_stopped():
				state = 0
		_:
			state = 0

func next():
	donext = true
