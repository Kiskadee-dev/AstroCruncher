extends Node2D

var projectile = preload("res://Bullets/EnemyBullet.tscn")
var shooted:int = 0
onready var timer = Timer.new()
var shooting:bool = false
signal shooting_finished

func _ready():
	add_child(timer)

func start_pattern():
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .1
	shooting = true
	shooted = 0
	#timer.start()

func _process(_delta):
	if shooting and not player_stats.dead:
		if timer.is_stopped(): 
			if shooted < 30:
				timer.start()
				shoot()
				shooted += 1
			else:
				shooting = false
				emit_signal("shooting_finished")

func shoot_pat1():
	#timer.stop()
	#timer.wait_time = 0
	timer.one_shot = true
	timer.connect("timeout", self, "start_pattern")
	start_pattern()
	#timer.start()

func shoot():
	if visible:
		var i
		if round(global_rotation_degrees) == 90:
			i = BulletSystem.fire(projectile, Vector2(global_position.x+rand_range(-100, 100), global_position.y), global_rotation_degrees, 2000, get_parent().get_parent().get_parent().get_parent())
		else:
			i = BulletSystem.fire(projectile, Vector2(global_position.x, global_position.y+rand_range(-100, 100)), global_rotation_degrees, 2000, get_parent().get_parent().get_parent().get_parent())
		i.damage = 10
	else:
		return
