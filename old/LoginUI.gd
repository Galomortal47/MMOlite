extends NinePatchRect

func _on_Button_button_down():
	var username = $VBoxContainer/LineEdit.get_text()
	var password = $VBoxContainer/LineEdit2.get_text().sha256_text()
	get_parent().Login(username, password, get_instance_id())
	pass # Replace with function body.

func _on_Button2_button_down():
	self.hide()
	get_parent().get_node("Register").show()
	pass # Replace with function body.

func results(state):
#	print(Tokendata.token)
	$VBoxContainer/Label2.set_text(state)
	print(state)
	if state == "Welcome back":
		self.hide()
		get_parent().get_node("BrowsingList").show()
	
