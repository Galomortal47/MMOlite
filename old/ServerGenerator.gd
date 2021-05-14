extends Node

export(PackedScene) var server

func _ready():
	for i in 5:
		var newserver =server.instance()
		newserver.port += i
		add_child(newserver)
	pass # Replace with function body.
