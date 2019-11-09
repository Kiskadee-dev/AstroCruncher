extends TextureProgress

onready var tween = $Tween

func decrease_life(new_value:float):
	tween.stop_all()
	tween.interpolate_property(self, "value", value, new_value, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
