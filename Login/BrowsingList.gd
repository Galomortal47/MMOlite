extends NinePatchRect

var buffer = {}
var username = ''
var password = ''

func browse_list(list):
	if list == null:
		return
	$RichTextLabel.clear()
#	print('received data') 
	var space = "                           "
	var text = ''
	$Label2.set_text(space + ' Room' +space + 'GameMode' +space + 'Map' +space + 'Playes')
	buffer = list.duplicate()
	for i in list.keys():
		text += '\n'
		text += space
		text +=  str(list[i].roomname)
		text += space
		text +=  str(list[i].gamemode)
		text += space
		text +=  str(list[i].map)
		text += space
		text += str(list[i].playeronline)
		text += ' / '
		text += str(list[i].max_players)
#		text +=  str(list[i].ip)
#		text +=  str(list[i].port)
		$RichTextLabel.add_item(text)
	pass

func _on_RichTextLabel_item_activated(index):
	Tokendata.ip = buffer[buffer.keys()[index]]['ip']
	Tokendata.PORT = buffer[buffer.keys()[index]]['port']
	get_parent().FetchServerAddress(Tokendata.ip, Tokendata.PORT)
#	get_parent().Login(username, password, get_instance_id(), Tokendata.ip)
#	get_parent().network.close_connection()
	get_tree().change_scene("res://Client/Client.tscn")
	pass # Replace with function body.
