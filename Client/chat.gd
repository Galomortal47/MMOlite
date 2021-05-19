extends LineEdit

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_button_down()

func _on_Button_button_down():
	get_parent().get_parent().SendChatMessage(get_text(), get_instance_id())
	set_text("")
	pass # Replace with function body.

func update_chat(chat):
	for i in chat:
		$RichTextLabel.set_bbcode($RichTextLabel.get_bbcode() +"\n"+ i) 
