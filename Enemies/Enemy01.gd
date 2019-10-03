extends "res://BulletSystem/Bullet2D.gd"

onready var projectile = preload("res://Bullets/EnemyBullet.tscn")

var damage = 10
var health = 30
var timer:Timer = Timer.new()
var shooting:bool = false

var original_rotation
var speed

var shooted:int = 0

func start_pattern():
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .5
	shooting = true
	shooted = 0
	timer.start()

func _process(delta):
	if shooting and not player_stats.dead:
		if timer.is_stopped(): 
			if shooted < 3:
				var p = get_tree().get_nodes_in_group("player")
				timer.start()
				if len(p) > 0:
					current_speed = 0
					look_at(p[0].position)
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

func shoot_pat1():
	original_rotation = rotation
	speed = current_speed
	timer.stop()
	timer.wait_time = 4
	timer.one_shot = true
	timer.connect("timeout", self, "start_pattern")
	timer.start()

func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, $shoot_point.global_position, rotation_degrees, 1000, get_parent())
	else:
		return

func on_ready():
	force_physics = true
	use_lifespan = false
	pooleable = false
	.on_ready()
	shoot_pat1()

func _ready():
	add_child(timer)
	on_ready()

func _reset():
	._reset()
	health = 30

func _load():
	._load()
	$Area2D.set_deferred("monitoring", true)

func _unload():
	._unload()
	$Area2D.set_deferred("monitoring", false)

func damage(value):
	health -= value
	health = clamp(health, 0, 100)
	if health == 0:
		_unload()

func _on_Area2D_body_entered(body):
	if visible:
		if body:
			body = body as Node2D
			if player_stats.collide(self, body):
				_unload()

func _on_Area2D_area_entered(area):
	if visible:
		if area:
			area = area as Area2D
			if area.monitoring:
				var p = area.get_parent()
				if p.is_in_group("player_bullet"):
					if p.visible and not p.hit_someone:
						p.hit_someone = true
						damage(p.damage)
						p._unload()
