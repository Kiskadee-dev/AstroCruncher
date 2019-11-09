extends Node

enum powerup{none, triple}

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

var powers:int = powerup.none
var shield:bool = false

onready var powerup_timer = Timer.new()
onready var shield_timer = Timer.new()

var bullet_explosion_effect = preload("res://explosion_bullet_player_damage.tscn")
var heal_box = preload("res://Heal.tscn")
onready var health_timer = Timer.new()

func _ready():
	add_child(health_timer)
	health_timer.wait_time = 20
	health_timer.one_shot = true
	health_timer.start()
	add_child(powerup_timer)
	add_child(shield_timer)
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
				health = 100
				emit_signal("health_updated")
				emit_signal("player_respawn")
				yield(get_tree().create_timer(3), "timeout")
				emit_signal("god_mode_disabled")
				dead = false
			else:
				emit_signal("game_over")

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
		powerup.triple:
			powerup_timer.wait_time = 6
			powerup_timer.start()
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
	powers = powerup.none

func spawn_thing_chance(object:Node2D):
	var heal_chance = 10
	var chance = rand_range(0, 100)
	if chance < 10:
		if health_timer.is_stopped():
			var h = heal_box.instance()
			h.position = object.position
			object.get_parent().add_child(h)
			health_timer.start()
	
func add_score(sc):
	score += sc
	if score >= 1000:
		lifes += 1
		score -= 1000