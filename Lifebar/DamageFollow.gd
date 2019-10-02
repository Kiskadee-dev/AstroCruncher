extends TextureProgress

onready var tween = $Tween

func _ready():
	pass
	#rect_size = get_parent().rect_size

func decrease_life(new_value:float):
	tween.stop_all()
	tween.interpolate_property(self, "value", value, new_value, 1, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
