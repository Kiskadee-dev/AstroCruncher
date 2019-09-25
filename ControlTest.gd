extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/TextureProgress.decrease_life(50)
	$PanelContainer/TextureProgress.decrease_life(20)