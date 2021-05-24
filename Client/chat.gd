extends LineEdit

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_button_down()

func _on_Button_button_down():
	if len(get_text()) == 0:
		return
	get_parent().get_parent().SendChatMessage(get_text(), get_instance_id())
	set_text("")
	pass # Replace with function body.

func update_chat(chat):
	for i in chat:
		$RichTextLabel.set_bbcode($RichTextLabel.get_bbcode() +"\n"+ str(i).rstrip('}').lstrip("{")) 
		var node = get_parent()
		var node2 = node.get_node(get_parent().players)
		var node3 
		var lb = get_parent().get_parent().loggedusers_buffer
		for j in lb.keys():
			if lb[j] == i.keys()[0]:
				node3 = j
		print(lb.keys())
		print(i.keys()[0])
		node2.get_node(str(node3)).chat(i.values()[0])
