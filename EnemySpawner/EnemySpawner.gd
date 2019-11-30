extends Node2D

var SpawnPositions:Line2D

var max_position:Vector2
var min_position:Vector2

onready var screensize = get_viewport_rect().size

onready var Wave1 = preload("res://Waves/scenes/Wave1.tscn")
onready var Wave2 = preload("res://Waves/scenes/Wave2.tscn")
onready var Wave3 = preload("res://Waves/scenes/Wave3.tscn")

onready var boss_spawn_cooldown:Timer = Timer.new()
var boss_spawned:int = 0
onready var music_tween:Tween = Tween.new()
onready var boss = get_node("../boss")

func _ready():
	add_child(music_tween)
	add_child(boss_spawn_cooldown)
	randomize()
	get_viewport().connect("size_changed", self, "update_spawn")
	update_spawn()
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("spawn_enemies")

func spawn_enemies():
	start_spawning = true
	return

func update_spawn():
	max_position = get_viewport().get_visible_rect().end
	max_position.y = 0
	min_position = get_viewport().get_visible_rect().end

var start_spawning:bool = false
var onda:int = 0
var iniciado:bool = false
var grupo:Array = []

func _process(delta):
	if start_spawning and not iniciado:
		match onda:
			0:
				register_wave(Wave1)
				iniciado = true
			1:
				register_wave(Wave2)
				iniciado = true
			2:
				register_wave(Wave1)
				register_wave(Wave2)
				iniciado = true
			3:
				register_wave(Wave3)
				iniciado = true
			4:
				register_wave(Wave3)
				register_wave(Wave2)
				register_wave(Wave1)
				iniciado = true
			5:
				match boss_spawned:
					0:
						var m = $Level_Music
						music_tween.interpolate_property(m, "volume_db", 0, -80, 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
						music_tween.start()
						boss_spawn_cooldown.wait_time = 4
						boss_spawn_cooldown.one_shot = true
						boss_spawn_cooldown.start()
						boss_spawned = 1
					1:
						if boss_spawn_cooldown.is_stopped():
							$Level_Music.stop()
							$BOSS_Music.start_music()
							music_tween.queue_free()
							boss_spawned = 2
					2:
							boss.get_node("AnimationPlayer").play("spawn")
							boss_spawned = 3
					3:
							if not boss.get_node("../boss/AnimationPlayer").is_playing():
								boss.start_boss()
								boss.get_node("AnimationPlayer").play("idle")
								boss.connect("boss_death_animation_finished", self, "win")
								iniciado = true
					4:
						$BOSS_Music.stop()
						$WIN_Jingle.play()
						boss_spawned = 5
					5:
						if not $WIN_Jingle.is_playing():
							start_spawning = false
							onda = 6
							player_stats.win()
							iniciado = true

			_:
				onda = 0
func win():
	boss_spawned = 4
	iniciado = false

func group_ready(increment = true)->bool:
	for i in grupo:
		if i.started:
			return false
	while not grupo.empty():
		grupo.pop_front().queue_free()
	if increment:
		iniciado = false
		onda += 1
	return true

func register_wave(w, increment = true):
	var a = start_wave(w)
	a.connect("wave_finished", self, "group_ready")
	grupo.append(a)
	return a

func start_wave(w)->Node2D:
	w = w.instance()
	add_child(w)
	w.start_wave()
	return w
