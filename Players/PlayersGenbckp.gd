extends Node2D

var PlayerLoad = load('res://Players/PlayerTemplate.tscn')
var lag_compesation = true
var lag_compesation_ammount = 2.0
var movment_smooth = 0.4

func _physics_process(delta):
	var movment = 'stop'
	if Input.is_action_pressed("ui_left"):
		movment = 'left'
	if Input.is_action_pressed("ui_right"):
		movment = 'right'
	if Input.is_action_pressed("ui_up"):
		movment = 'jump'
	get_parent().MovePlayer(movment)
	if Input.is_action_just_pressed("ui_lagcomp"):
		lag_compesation = !lag_compesation
#	if Input.is_action_just_pressed("ui_plus"):
#		lag_compesation_ammount += 5.0
#		movment_smooth += 1.0
#	if Input.is_action_just_pressed("ui_minus"):
#		lag_compesation_ammount -= 5.0
#		movment_smooth -= 1.0

func spawn_despawn(loggedusers):
	var players = []
	for i in get_children():
		players.append(i.name)
	for i in loggedusers.keys():
		if not players.has(str(i)):
			var n = ['chick', 'cat','cat2', 'cat3']
			var number = fmod(i,n.size())
			var skin = load('res://assets/sprites/'+str(n[number])+'.png')
			var instance = PlayerLoad.instance()
			instance.name = str(i)
			instance.get_node('anims/Sprite').texture = skin
			instance.get_node('Label').set_text(loggedusers[i])
			add_child(instance)

var bufferdata = [{},{}]

func sync_position(userdata):
	bufferdata.append(userdata.duplicate())
	if bufferdata.size() > 1:
		bufferdata.remove(0)
	for i in userdata.keys():
		if has_node(str(i)):
			get_node(str(i)).playnanims(userdata[i]['ani'])
			if bufferdata[0].has(i) and lag_compesation:
				var new_delta = userdata[i]['pos'] - bufferdata[0][i]['pos']
				var new_pos = userdata[i]['pos'] + (new_delta*lag_compesation_ammount)
				get_node(str(i)).position = ((get_node(str(i)).position*movment_smooth) + lerp(userdata[i]['pos'], new_pos, 0.5))/(movment_smooth+1.0)
			else:
				get_node(str(i)).position = userdata[i]['pos']

func user_remove(player_id):
	print("Player: " +str(player_id)+" has been desconnected")
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()

func change_skin(player_id, format, skin):
	print("Image of "+str(len(skin)/1024)+" KBs had arrived")
	var image = Image.new()
	image.create_from_data(64,64, false, format, skin)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	get_node(str(player_id)).get_node('anims/Sprite').texture = texture

