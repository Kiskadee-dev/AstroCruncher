extends Node2D
signal done
func attack():
	$AnimationPlayer.play("attack")
	yield($AnimationPlayer, "animation_finished")
	$Attack_shower.shoot_pat1()
	yield($Attack_shower, "shooting_finished")
	hide()
	emit_signal("done")