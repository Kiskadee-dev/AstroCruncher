extends Node2D

var play_area = Rect2()

onready var asteroid_attack = preload("res://Boss Attacks/Boss_Attacks/Scenes/AsteroidAttack.tscn")
onready var swarm_attack1 = preload("res://Boss Attacks/Boss_Attacks/Scenes/SwarmAttack1.tscn")
onready var swarm_attack2 = preload("res://Boss Attacks/Boss_Attacks/Scenes/SwarmAttack2.tscn")
onready var swarm_attack3 = preload("res://Boss Attacks/Boss_Attacks/Scenes/SwarmAttack3.tscn")
onready var swarm_attack4 = preload("res://Boss Attacks/Boss_Attacks/Scenes/SwarmAttack4.tscn")
onready var warning_pattern = preload("res://Boss Attacks/Boss_Attacks/Scenes/WarningPattern.tscn")

onready var bullet_explosion_effect = preload("res://explosion_bullet.tscn")
signal attack_finished
signal boss_death_animation_finished
var attack_function_state:GDScriptFunctionState

func _ready():
	play_area = get_viewport().get_visible_rect()
	player_stats.connect("boss_dead", self, "die")

func start_boss():
	player_stats.emit_signal("show_boss_health")
	randomize()
	start_attacking = true
	return

func damage(value):
	player_stats.damage_boss(value)

func _on_Damage_Area2D_area_entered(area):
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

onready var t = Timer.new()
func explode():
	add_child(t)
	t.wait_time = .2
	t.one_shot = false
	t.connect("timeout", self, "spawn_explosion_effect")
	t.start()
	player_stats.emit_signal("hide_boss_health")

var count = 0
func spawn_explosion_effect():
	if count > 50:
		t.queue_free()
	var b:Node2D = bullet_explosion_effect.instance()
	b.position.x = rand_range(-100, 100)
	b.position.y = rand_range(-100, 100)
	add_child(b)
	if game_configuration.sfx:
		AudioPool.play(AudioPool.soundlib.boom)
	count += 1

func disable_collision():
	$Damage_Area2D.set_deferred("monitoring", false)

func die():
	$AnimationPlayer.play("Die")

var grupo:Array = []
var iniciado:bool = false
var onda:int = 0
var start_attacking:bool = false

func _process(delta):
	if start_attacking and not iniciado and player_stats.boss_health > 0:
		match onda:
			0:
				register_attack(swarm_attack1)
				iniciado = true
			1:
				register_attack(swarm_attack2)
				iniciado = true
			2:
				register_attack(warning_pattern)
				register_attack(swarm_attack4)
				iniciado = true
			3:
				register_attack(swarm_attack3)
				register_attack(swarm_attack1)
				iniciado = true
			4:
				register_attack(warning_pattern)
				register_attack(swarm_attack3)
				register_attack(swarm_attack1)
				iniciado = true
			5:
				register_attack(swarm_attack1)
				register_attack(swarm_attack1)
				register_attack(swarm_attack1)
				iniciado = true
			6:
				register_attack(warning_pattern)
				register_attack(swarm_attack3)
				register_attack(swarm_attack1)
				register_attack(asteroid_attack)
				iniciado = true
			_:
				onda = 0
	elif player_stats.boss_health <= 0 and not $AnimationPlayer.is_playing():
		iniciado = false
		start_attacking = false
		emit_signal("boss_death_animation_finished")


func register_attack(attack:PackedScene):
	var a = create_attack(attack)
	a.connect("attack_finished", self, "group_ready")
	grupo.append(a)
	return a

func create_attack(attack)->Node2D:
	attack = attack.instance()
	add_child(attack)
	attack.start_attack()
	return attack

func group_ready()->bool:
	for i in grupo:
		if i.attacking:
			return false
	while not grupo.empty():
		grupo.pop_front().queue_free()
	iniciado = false
	onda += 1
	return true
