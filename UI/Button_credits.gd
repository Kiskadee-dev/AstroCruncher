extends Button

var credit_panel:bool




func _on_Button_close_credits_button_down():
	$PanelContainer_credits.hide()


func _on_Button_credits_button_down():
	$PanelContainer_credits.show()
