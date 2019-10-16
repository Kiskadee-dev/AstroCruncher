extends Node

var movement_vector:Vector2 = Vector2()
signal shoot
signal stopshooting

var shooting:bool = false

var use_joystick:bool = false

func _ready():
	if OS.has_feature("Android"):
		use_joystick = true

func _process(delta):
	if use_joystick:
		movement_vector = joystick_output.joystick_output
		if not shooting:
			if joystick_output.b1:
				shooting = true
				emit_signal("shoot")
		else:
			if not joystick_output.b1:
				shooting = false
				emit_signal("stopshooting")

func _input(event):
	if not use_joystick:
		movement_vector = Vector2()
		event = event as InputEvent
		if Input.is_action_pressed("cima"):
			movement_vector.y -= 1
		if Input.is_action_pressed("baixo"):
			movement_vector.y += 1
		if Input.is_action_pressed("direita"):
			movement_vector.x += 1
		if Input.is_action_pressed("esquerda"):
			movement_vector.x -= 1
		if event.is_action_pressed("shoot"):
			emit_signal("shoot")
		if event.is_action_released("shoot"):
			emit_signal("stopshooting")
