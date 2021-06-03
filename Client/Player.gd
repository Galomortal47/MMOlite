extends CanvasLayer

export(NodePath) var players

func _ready():
	get_parent().StartServer()

var start = false

func data_req():
	start = true

func _input(event):
	$score.visible = Input.is_action_pressed('ui_tab')

#func _physics_process(delta):
#	if start:
#		var json = {"lineedit": str($LineEdit.get_text()), "time" : int(OS.get_system_time_msecs())}
#		get_parent().fetch(json, get_instance_id())

func update_time(time):
	var text = ''
	text += str(int(time/60.0))
	text += ":"
	text += str(int(fmod(time,60)))
	$time.set_text(text)

func update_score(score):
	var space = "                   "
	var text = space+' Username '+space+'K'+space+'D'
	for i in get_node(players).get_children():
		text += '\n'
		if not get_parent().loggedusers_buffer[int(i.name)]['team'] == null:
			text += '[color='+ get_parent().loggedusers_buffer[int(i.name)]['team']+']'
		text += space
		text += i.get_node('Label').get_text()
		text += space
		text += str(score[int(i.name)]['k'])
		text += space
		text += str(score[int(i.name)]['d'])
		if not get_parent().loggedusers_buffer[int(i.name)]['team'] == null:
			text += '[/color]'
	
	$score.set_bbcode(str(text))

func consolelog(data):
	$Label.set_text(data.lineedit)
	var ping = int(OS.get_system_time_msecs() - data.time)
	$ping.set_text("Ping: " + str(ping))
#	get_node(players).lag_compesation_ammount = ping / 50
#	get_node(players).movment_smooth = ping / 250

func _on_Timer_timeout():
	var json = {"lineedit": str($LineEdit.get_text()), "time" : int(OS.get_system_time_msecs())}
	get_parent().fetch(json, get_instance_id())
	match get_parent().network.get_connection_status():
		0:
			$ping2.set_text('Disconnected T-T')
			get_parent().StartServer()
			for i in get_node(players).get_children():
				i.queue_free()
		1:
			$ping2.set_text('Trying to Connect O.O')
		2:
			$ping2.set_text('Connected UwU')
	$ping3.set_text('players online: '+ str(get_node(players).get_child_count()))
	$ping4.set_text('lag compesation is: '+ str(get_node(players).lag_compesation_ammount))
#	else:
#		$ping3.set_text('lag compesation is off')
#	pass # Replace with function body.

func _on_Server_connected():
	get_parent().TokenVerificationResults(Tokendata.token, get_instance_id())
	pass # Replace with function body.

func victory(winner, highest, gamemode):
	var win 
	match gamemode:
		'ffa':
			if not winner == null:
				if has_node(players):
					if get_node(players).has_node(str(winner)):
						win = get_node(players).get_node(str(winner)).get_node('Label').get_text()
						$Victory.set_text("The Winner is " + win + " With an Score of " +  str(highest))
		'TDM':
			$Victory.set_text('Team ' + str(winner) + " Had Won the Game ")
