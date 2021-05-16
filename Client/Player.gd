extends Node

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
	$ping.set_text("Current Ping is: " + str(int(OS.get_system_time_msecs() - data.time)))

func _on_Timer_timeout():
	var json = {"lineedit": str($LineEdit.get_text()), "time" : int(OS.get_system_time_msecs())}
	get_parent().fetch(json, get_instance_id())
	pass # Replace with function body.

func _on_Server_connected():
	get_parent().TokenVerificationResults("234", get_instance_id())
	pass # Replace with function body.
