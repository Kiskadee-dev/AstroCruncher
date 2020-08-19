extends Node2D

var projectile = preload("res://Bullets/EnemyBullet.tscn")
onready var timer = Timer.new()
var shooting:bool = false
signal shooting_finished
var locked_target:bool
var lock_on:bool = true
func _ready():
	add_child(timer)

func attack(projectile_count:int, projectile_speed:float, lock:bool=true):
	lock_on=lock
	$AnimationPlayer.play("spawn")
	yield($AnimationPlayer, "animation_finished")
	shoot_pat1(projectile_count, projectile_speed)
	yield(self, "shooting_finished")
	$AnimationPlayer.play("despawn")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

var shooted:int = 0

func start_pattern(projectile_count:int, projectile_speed:float):
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .1
	shooting = true
	shooted = 0
	#timer.start()

func _process(delta):
	if shooting and not player_stats.dead:
		if timer.is_stopped(): 
			if shooted < 10:
				var p = get_tree().get_nodes_in_group("player")
				timer.start()
				if len(p) > 0 and not locked_target:
					look_at(p[0].position)
					if lock_on:
						locked_target = true
				shoot()
				shooted += 1
			else:
				shooting = false
				emit_signal("shooting_finished")

func shoot_pat1(projectile_count:int, projectile_speed:float):
	#timer.stop()
	#timer.wait_time = 0
	timer.one_shot = true
	timer.connect("timeout", self, "start_pattern")
	start_pattern(projectile_count, projectile_speed)
	#timer.start()

func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, $shoot_point.global_position, rotation_degrees+rand_range(-15, 15), 1000, get_parent())
		i.damage = 10
	else:
		return
