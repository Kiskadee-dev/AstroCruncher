extends ParallaxLayer

export var parallax_speed:float = 100
export var parallax_direction:Vector2 = Vector2(-1, 0)
func _ready():
	pass # Replace with function body.

func _process(delta):
	motion_offset += parallax_direction*(parallax_speed*delta)
