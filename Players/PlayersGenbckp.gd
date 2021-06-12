extends Node2D

var PlayerLoad = load('res://Players/PlayerTemplate.tscn')
var lag_compesation = true
var lag_compesation_ammount = 0.0
var movment_smooth = 0.4
var hp = 100
var main_user = ''
var weapon_selected = 1
var lag = 0.250
var bufferdata = [{},{}]
var loggedusersbuffer = {}

func _physics_process(delta):
#	yield(get_tree().create_timer(lag), "timeout")
	var attack = ''
	var movment = 'stop'
	if Input.is_action_pressed("ui_left"):
		movment = 'left'
	if Input.is_action_pressed("ui_right"):
		movment = 'right'
	if Input.is_action_pressed("ui_up"):
		movment = 'jump'
	if Input.is_action_pressed("ui_attack"):
		match weapon_selected:
			1:
				attack = 'attk'
			2:
				attack = 'shot'
	if Input.is_action_pressed("ui_1"):
		weapon_selected = 1
		attack = 'change1'
	if Input.is_action_pressed("ui_2"):
		weapon_selected = 2
		attack = 'change2'
	var look_at =  self
	if has_node(main_user):
		look_at = get_node(main_user)
	var look = int(rad2deg(look_at.get_angle_to(get_global_mouse_position())))
	get_parent().MovePlayer(movment,look, attack)
	if Input.is_action_just_pressed("ui_lagcomp"):
		lag_compesation = !lag_compesation
	if Input.is_action_just_pressed("ui_plus"):
		lag_compesation_ammount += 1.0
		movment_smooth += 0.2
	if Input.is_action_just_pressed("ui_minus"):
		lag_compesation_ammount -= 1.0
		movment_smooth -= 0.2

func spawn_despawn(loggedusers):
	loggedusersbuffer = loggedusers

func spawn_despawn2(loggedusers):
	if loggedusersbuffer == {}:
		return
	var players = []
	for i in get_children():
		players.append(i.name)
	for i in loggedusers.keys():
		if not players.has(str(i)):
			var instance = PlayerLoad.instance()
			instance.name = str(i)
			add_child(instance)
		if loggedusersbuffer.has(i):
			var instance = get_node(str(i))
			match loggedusersbuffer[i]['team']:
				'red':
					instance.get_node('Label').modulate = Color(1,0,0)
				'green':
					instance.get_node('Label').modulate = Color(0,1,0)
				'blue':
					instance.get_node('Label').modulate = Color(0,0,1)
			instance.get_node('Label').set_text(loggedusersbuffer[i]['name'])

func sync_position(userdata):
#	yield(get_tree().create_timer(lag), "timeout")
	bufferdata.append(userdata.duplicate())
	if bufferdata.size() > 1:
		bufferdata.remove(0)
	for i in userdata.keys():
		if has_node(str(i)):
			get_node(str(i)).playnanims(userdata[i]['ani'])
			get_node(str(i)).playnanims(userdata[i]['atk'])
			if bufferdata[0].has(i) and lag_compesation:
				var new_delta = userdata[i]['pos'] - bufferdata[0][i]['pos']
				var new_pos = userdata[i]['pos'] + (new_delta*lag_compesation_ammount)
				var old_pos = get_node(str(i)).position
				get_node(str(i)).tween('position', old_pos,new_pos)
			else:
				get_node(str(i)).position = userdata[i]['pos']
			get_node(str(i)).get_node('melee').rotation_degrees = userdata[i]['lk']

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

func _on_AreaOfInterestData_timeout():
	spawn_despawn2(bufferdata[0])
	pass # Replace with function body.
