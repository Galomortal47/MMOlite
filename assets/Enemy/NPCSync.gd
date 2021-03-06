extends Node2D

var PlayerLoad = load('res://assets/Enemy/NPC.tscn')
var BulletLoad = load('res://assets/bullet/Bullet.tscn')
var lag_compesation = true
var lag_compesation_ammount = 2.0
var movment_smooth = 0.0

func spawn_despawn(loggedusers):
	var players = []
#	print(loggedusers)
	for i in get_children():
		players.append(i.name)
	for i in loggedusers.keys():
#		print(i)
		if not players.has(str(i)):
			var instance
			match loggedusers[i]:
				'enemy':
					instance = PlayerLoad.instance()
				'bullet':
					instance = BulletLoad.instance()
			instance.name = str(i)
			add_child(instance)

var bufferdata = [{},{}]

func sync_position(userdata):
	bufferdata.append(userdata.duplicate())
	if bufferdata.size() > 1:
		bufferdata.remove(0)
	for i in userdata.keys():
		if has_node(str(i)):
				get_node(str(i)).position = userdata[i]['pos']
