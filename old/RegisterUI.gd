extends NinePatchRect

func _on_Button_button_down():
	var username = $VBoxContainer/LineEdit.get_text()
	var password = $VBoxContainer/LineEdit2.get_text()
	var password2 = $VBoxContainer/LineEdit3.get_text()
	var email = $VBoxContainer/LineEdit4.get_text()
	if password != password2:
		$VBoxContainer/Label3.set_text("Password doesen't match")
		return
	if password.length() < 6:
		$VBoxContainer/Label3.set_text("Password is too short")
		return
	if username.length() < 3 or username.replace(" ","").length() < 1:
		$VBoxContainer/Label3.set_text("Username is too short")
		return
	$VBoxContainer/Label3.set_text("... Connecting to Server")
	get_parent().Register(username, password.sha256_text(), email, get_instance_id())
	pass # Replace with function body.

func _on_Button2_button_down():
	self.hide()
	get_parent().get_node("Register").show()
	pass # Replace with function body.

func results(state):
	$VBoxContainer/Label2.set_text(state)

func _on_CheckBox_toggled(button_pressed):
	$VBoxContainer/Button.disabled = !button_pressed
	pass # Replace with function body.
