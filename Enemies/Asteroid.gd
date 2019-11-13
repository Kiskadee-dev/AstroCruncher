extends "res://Enemies/EnemyClass.gd"

func _ready():
	damage = 30
	health = 30
	player_score = 20
	original_damage = damage
	original_health = health
	original_rotation = rotation
	on_ready()

func on_ready():
	force_physics = true
	use_lifespan = false
	default_lifespan = 15
	use_screen_visibility = true
	.on_ready()

func _load():
	._load()

func _unload():
	._unload()

func _reset():
	scale = Vector2(1,1)
	var chance = rand_range(0, 100)
	if chance < 50:
		$AnimatedSprite.play("Rotate up")
	else:
		$AnimatedSprite.play("Rotate right")
	var frame = int(rand_range(0,len($AnimatedSprite.frames.frames)))
	$AnimatedSprite.frame = frame
	._reset()

func damage(value):
	.damage(value)

func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)

func _on_Area2D_area_entered(area):
	._on_Area2D_area_entered(area)
