extends "res://Enemies/EnemyClass.gd"

func _ready():
	damage = 10
	health = 30
	player_score = 10
	original_damage = damage
	original_health = health
	original_rotation = rotation
	on_ready()

func start_pattern():
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .1
	shooting = true
	shooted = 0
	timer.start()

func _process(_delta):
	if shooting and not player_stats.dead:
		if timer.is_stopped(): 
			if shooted < 12:
				timer.start()
				current_speed = 0
				rotation_degrees = shooted*30
				shoot()
				shooted += 1
			else:
				change_speed(speed)
				rotation = original_rotation
				shooting = false
				shooted = 0
				timer.wait_time = 4
				timer.stop()
				timer.connect("timeout", self, "start_pattern")
				timer.start()

func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, $shoot_point.global_position, rotation_degrees, 100, get_parent())
		i.scale = Vector2(.2,.2)
	else:
		return

func shoot_pat1():
	original_rotation = rotation
	speed = current_speed
	timer.stop()
	timer.wait_time = 4
	timer.one_shot = true
	timer.connect("timeout", self, "start_pattern")
	timer.start()

func on_ready():
	force_physics = true
	use_lifespan = true
	pooleable = false
	default_lifespan = 20
	.on_ready()

func _reset():
	._reset()

func _load():
	._load()

func _unload():
	._unload()

func damage(value):
	.damage(value)

func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)

func _on_Area2D_area_entered(area):
	._on_Area2D_area_entered(area)
