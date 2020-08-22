extends "res://BulletSystem/Bullet2D.gd"

onready var projectile = preload("res://Bullets/EnemyBullet.tscn")
onready var bullet_explosion_effect = player_stats.bullet_explosion_effect_enemy
var timer:Timer = Timer.new()

var damage:float
var health:float
var player_score:int
var shooting:bool
var speed:float
var shooted:int

var original_health:float
var original_rotation:float
var original_damage:float


func start_pattern():
	pass

func _process(delta):
	pass

func shoot_pat1():
	pass

func shoot():
	pass

func on_ready():
	force_physics = true
	use_lifespan = false
	pooleable = false
	add_child(timer)
	.on_ready()

func _reset():
	health = original_health
	damage = original_damage
	rotation = original_rotation
	._reset()

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
		player_stats.add_score(player_score)
		if game_configuration.sfx:
			AudioPool.play(AudioPool.soundlib.boom)
		player_stats.spawn_thing_chance(self)
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
						var ex = bullet_explosion_effect.instance()
						get_parent().add_child(ex)
						ex.position = p.position
						p._unload()
