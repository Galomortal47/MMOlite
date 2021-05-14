extends Node

func _ready():
	get_parent().StartServer()

var start = false

func data_req():
	start = true

func _physics_process(delta):
	if start:
		var json = {
"lineedit": str($LineEdit.get_text()),
 "time" : int(OS.get_system_time_msecs())
}
		get_parent().fetch(json, get_instance_id())
#		print(OS.get_unix_time())

func consolelog(data):
#	print(OS.get_unix_time())
#	print(data)
	$Label.set_text(data.lineedit)
	$ping.set_text(str(int(OS.get_system_time_msecs() - data.time)))
