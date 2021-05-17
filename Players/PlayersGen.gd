extends Node2D

var PlayerLoad = load('res://Players/PlayerTemplate.tscn')

func _input(event):
	if Input.is_action_pressed("ui_down"):
		get_parent().MovePlayer(Vector2(0,1))
	if Input.is_action_pressed("ui_up"):
		get_parent().MovePlayer(Vector2(0,-1))
	if Input.is_action_pressed("ui_left"):
		get_parent().MovePlayer(Vector2(-1,0))
	if Input.is_action_pressed("ui_right"):
		get_parent().MovePlayer(Vector2(1,0))

func spawn_despawn(loggedusers):
	var players = []
	for i in get_children():
		players.append(i.name)
	for i in loggedusers.keys():
		if not players.has(str(i)):
			var instance = PlayerLoad.instance()
			instance.name = str(i)
			instance.get_node('Label').set_text(loggedusers[i])
			add_child(instance)

func sync_position(userdata):
	for i in userdata.keys():
		if has_node(str(i)):
			get_node(str(i)).position = userdata[i]['pos']

func user_remove(player_id):
	print("Player: " +str(player_id)+" has been desconnected")
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
