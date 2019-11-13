extends KinematicBody2D

var projectile = preload("res://Bullets/PlayerBullet.tscn")
var shield = preload("res://Shield.tscn")
var shoot_cooldown = .1
onready var cooldown_timer:Timer = $shoot_cooldown

var speed = 200
var movement_vector:Vector2
onready var inputs = $Inputs

var shoot = false
var cooldown:bool = false

onready var sprite = $player_sprite

var screensize

onready var death_sound = $AudioStreamPlayer2D_boom

func _ready():
	screensize = get_viewport_rect().size
	cooldown_timer.wait_time = shoot_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.connect("timeout", self, "cooled")
	player_stats.connect("god_mode_disabled", self, "stop_blink")
	player_stats.connect("player_respawn", self, "animate_blink")
	player_stats.connect("player_died", self, "animate_death")

func _physics_process(delta):
	movement_vector = inputs.movement_vector
	move_and_slide(speed*movement_vector)
	if movement_vector.y > 0:
		sprite.play("dir")
	elif movement_vector.y < 0:
		sprite.play("esq")
	else:
		sprite.play("default")
	position.x = clamp(position.x, 100, screensize.x-100)
	position.y = clamp(position.y, 100, screensize.y-100)

func _process(delta):
	if shoot and not cooldown and not player_stats.dead:
		cooldown = true
		cooldown_timer.start()
		
		match player_stats.powers:
			player_stats.powerups.triple:
				shoot_triple_bullet()
			_:
				shoot_bullet()

func _on_Inputs_shoot():
	shoot = true
	
func _on_Inputs_stopshooting():
	shoot = false

func cooled():
	cooldown = false

func shoot_bullet():
	BulletSystem.fire(projectile, $Shoot_pos.global_position, 0, 1000, get_parent())

func shoot_triple_bullet():
	BulletSystem.fire(projectile, $Shoot_pos.global_position, 0, 1000, get_parent())
	BulletSystem.fire(projectile, $Shoot_pos.global_position, -10, 1000, get_parent())
	BulletSystem.fire(projectile, $Shoot_pos.global_position, 10, 1000, get_parent())

func animate_blink():
	show()
	$AnimationPlayer.play("blink")
	$AnimationPlayer.get_animation("blink").loop = true
	
func stop_blink():
	$AnimationPlayer.get_animation("blink").loop = false

func animate_death():
	if game_configuration.sfx:
		AudioPool.play(AudioPool.soundlib.boom)
	hide()

func add_shield():
	player_stats.shield_on()
	var s = shield.instance()
	get_parent().add_child(s)
	s.player = self
