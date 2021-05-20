extends Node

export(NodePath) var players

func _ready():
	get_parent().StartServer()

var start = false

func data_req():
	start = true

#func _physics_process(delta):
#	if start:
#		var json = {"lineedit": str($LineEdit.get_text()), "time" : int(OS.get_system_time_msecs())}
#		get_parent().fetch(json, get_instance_id())

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
	if get_node(players).lag_compesation:
		$ping3.set_text('lag compesation is: '+ str(get_node(players).lag_compesation_ammount))
	else:
		$ping3.set_text('lag compesation is off')
	pass # Replace with function body.

func _on_Server_connected():
	get_parent().TokenVerificationResults(Tokendata.token, get_instance_id())
	pass # Replace with function body.
