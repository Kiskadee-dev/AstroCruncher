extends "res://Waves/Wave.gd"

func start_wave():
	.start_wave()
	cooldown_timer.one_shot = true
	spawn_quantity = rand_range(10, 15)
	started = true

func _process(delta):
	if cooldown_timer.is_stopped() and started:
		if repeated < reapeat_times:
			if spawned < spawn_quantity:
				spawned += 1
				var scale:float = rand_range(1, 3)
				var b:Node2D = BulletSystem.fire(Asteroid, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
				b.scale = Vector2(scale, scale)
				b.position.y = clamp(b.position.y, 100, screensize.y-100)
				cooldown_timer.wait_time = .2
				cooldown_timer.start()
			else:
				spawned = 0
				repeated += 1
				cooldown_timer.wait_time = rand_range(2, 4)
				cooldown_timer.start()
		else:
			.finished()
