extends "res://Waves/Wave.gd"

func start_wave():
	.start_wave()
	reapeat_times = 5
	spawn_quantity = 3
	cooldown_timer.one_shot = true
	started = true

var stage:int = 0
func _process(_delta):
	if cooldown_timer.is_stopped() and started:
		if repeated < reapeat_times:
			if spawned < spawn_quantity:
				match stage:
					0:
						spawned += 1
						var b:Node2D = BulletSystem.fire(Enemy01, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
						b.position.y = clamp(b.position.y, 100, screensize.y-100)
						b.shoot_pat1()
						cooldown_timer.wait_time = 1
						cooldown_timer.start()
					1:
						spawned += 1
						var b:Node2D = BulletSystem.fire(Enemy02, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
						b.position.y = clamp(b.position.y, 100, screensize.y-100)
						b.shoot_pat1()
						cooldown_timer.wait_time = 1
						cooldown_timer.start()
			else:
				spawned = 0
				repeated += 1
				cooldown_timer.wait_time = 2
				cooldown_timer.start()
				match stage:
					0:
						stage = 1
					_:
						stage = 0
		else:
			.finished()
			stage = 0
