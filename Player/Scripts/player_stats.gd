extends Node

enum powerups{none, triple}

signal health_updated
signal player_died
signal player_respawn
signal god_mode_disabled
signal game_over
signal shield_over

var health:float = 100
var lifes:int = 3
var score:int = 0
var dead:bool = false

var powers:int = powerups.none
var shield:bool = false

onready var powerup_timer = Timer.new()
onready var triple_timer = Timer.new()
onready var shield_timer = Timer.new()
onready var health_timer = Timer.new()

var bullet_explosion_effect = preload("res://explosion_bullet_player_damage.tscn")
var heal_box = preload("res://Heal.tscn")
var powerup_box = preload("res://PowerUp_TripleShoot.tscn")

func _ready():
	add_child(health_timer)
	add_child(powerup_timer)
	add_child(triple_timer)
	add_child(shield_timer)
	
	triple_timer.wait_time = 20
	health_timer.wait_time = 20
	
	triple_timer.one_shot = true
	health_timer.one_shot = true
	powerup_timer.one_shot = true
	
	triple_timer.start()
	health_timer.start()
	
	powerup_timer.connect("timeout", self, "disable_powers")
	shield_timer.connect("timeout", self, "disable_shield")

func damage(value:float):
	if not dead:
		if player_stats.shield:
			return
		health -= value
		health = clamp(health, 0, 100)
		emit_signal("health_updated")
		if health <= 0:
			if lifes > 0:
				lifes -= 1
				dead = true
				emit_signal("player_died")
				yield(get_tree().create_timer(3), "timeout")
				respawn()
			else:
				dead = true
				emit_signal("player_died")
				emit_signal("game_over")

func new_game():
	reset_stats()

signal boss_health_updated
signal show_boss_health
var boss_health = 10000

func damage_boss(value:float):
	if not dead:
		if player_stats.shield:
			return
		boss_health -= value
		boss_health = clamp(boss_health, 0, 10000)
		emit_signal("boss_health_updated")
		if boss_health <= 0:
			print("boss is dead")

func reset_stats():
	score=0
	lifes=3
	health = 100
	emit_signal("health_updated")
	emit_signal("god_mode_disabled")
	dead = false
	
func respawn():
	health = 100
	emit_signal("health_updated")
	emit_signal("player_respawn")
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("god_mode_disabled")
	dead = false

func heal(value:float):
	if not dead:
		health += value
		health = clamp(health, 0, 100)
		emit_signal("health_updated")



func collide(object:Node2D, object2:Node2D)->bool:
	if object2.is_in_group("player"):
		if not dead and not object.hit_someone and object.visible:
			var ex = bullet_explosion_effect.instance()
			object2.get_parent().add_child(ex)
			ex.position = object.position
			damage(object.damage)
			object.hit_someone = true
			return true
	return false

func powerup(up):
	match up:
		powerups.triple:
			powerup_timer.wait_time = 6
			powerup_timer.start()
			powers = powerups.triple
		_:
			pass

func shield_on():
	shield_timer.wait_time = 6
	shield_timer.start()
	shield = true

func disable_shield():
	shield = false
	emit_signal("shield_over")
	
func disable_powers():
	powers = powerups.none

func spawn_thing_chance(object:Node2D):
	var heal_chance = 10
	var triple_shoot_chance = 8
	var chance = rand_range(0, 100)

	if chance < 8 and not health_timer.is_stopped():
		if triple_timer.is_stopped():
			var h = powerup_box.instance()
			h.position = object.position
			object.get_parent().call_deferred("add_child",h)
			triple_timer.start()
	if chance < 10:
		if health_timer.is_stopped():
			var h = heal_box.instance()
			h.position = object.position
			object.get_parent().call_deferred("add_child",h)
			health_timer.start()
			
	
func add_score(sc):
	score += sc
	if score >= 1000:
		lifes += 1
		score -= 1000