extends Node2D

var PlayerLoad = load('res://Players/PlayerTemplate.tscn')

func spawn_despawn(loggedusers):
	var players = []
	for i in get_children():
		if not loggedusers.values().has(i.name):
			i.queue_free()
		players.append(i.name)
	for i in loggedusers.values():
		if not players.has(str(i)):
			var instance = PlayerLoad.instance()
			instance.name = str(i)
			add_child(instance)
