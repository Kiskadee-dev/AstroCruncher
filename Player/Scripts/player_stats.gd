extends Node

enum powerup{none, triple}

signal health_updated
signal player_died
signal player_respawn
signal god_mode_disabled
signal game_over

var health:float = 100
var lifes:int = 3
var dead:bool = false

var powers:int = powerup.triple

onready var powerup_timer = Timer.new()

func _ready():
	add_child(powerup_timer)
	powerup_timer.connect("timeout", self, "disable_powers")
func damage(value:float):
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

func collide(object:Node2D, object2:Node2D)->bool:
	if object2.is_in_group("player"):
		if not dead and not object.hit_someone and object.visible:
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

func disable_powers():
	powers = powerup.none