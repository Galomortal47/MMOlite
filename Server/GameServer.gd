extends Node

var network = NetworkedMultiplayerENet.new()
onready var port =1909
onready var max_players = Tokendata.maxs_players
#var cert = load('user://Certificate/x509_Certificate.crt')
#var key = load('user://Certificate/x509_Key.key')
export var online_verification_disable = false

var roomname = 'room1'
var gamemode = 'ffa'
var map = 'ffa_dust'
var ip = '157.245.218.42'
var compression = 0
var data = {
	'room':'room2',
	'gamemode':'ffa',
	'map':'ffa_forest',
	'ip':'127.0.0.1',
	"online ver off": true,
	"compression":0,
	"tickspersecond":20
	}

var userdata = {}
var NPCdata = {}
var skin_list2 = {}

var loggedusers = {}
var entityshealth = {}
var chat = []
var NPCs = {}
var userroom = {}
var team = {'red':0,'blue':0}
export var spawn1 = [Vector2(-1500,-220), Vector2(1700,200)]

var kill_death = {}

var PlayerLoad = load('res://Players/PlayerTemplateCol.tscn')

func server_config():
	if ResourceLoader.exists("user://serverconfig.tres"):
		var loader = load("user://serverconfig.tres")
		print(loader.data[0])
		roomname = loader.data[0]['room']
		gamemode = loader.data[0]['gamemode']
		map = loader.data[0]['map']
		ip = loader.data[0]['ip']
		online_verification_disable  = loader.data[0]["online ver off"]
		compression = loader.data[0]["compression"]
		Engine.iterations_per_second = loader.data[0]["tickspersecond"]
	else:
		var data2 = load("res://Launcher/dataresource.gd").new()
		data2.data.append(data)
		ResourceSaver.save("user://serverconfig.tres", data2)

func _ready():
	server_config()
	StartServer()

func StartServer():
#	network.set_dtls_key(key)
#	network.set_dtls_certificate(cert)
#	network.set_dtls_enabled(true)
	network.create_server(port, max_players)
	network.set_compression_mode(compression) 
	get_tree().set_network_peer(network)
	print("serv start on port: " + str(port) + " with an limit of "+str(max_players) )
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	loggedusers.erase(player_id)
	if userroom.has(player_id):
		userdata.erase(player_id)
		$Players.get_node(str(player_id)).queue_free()
		rpc_id(0, "UserDisconnected", player_id)
		print("User " +str(player_id)+ " Disconnected")

remote func fetch(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_unreliable_id(player_id, "return_data", data, requester)

remote func ReturnTokenVerification(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	print('token is being verified')
	if online_verification_disable:
		$Token.tokens[data] = str(player_id)
	if $Token.tokens.has(data):
		var team = $GameModes.chooseteam(gamemode)
		print('added player to team: ' + str(team))
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Valid", $Token.tokens[data], requester, player_id)
		loggedusers[player_id] = {'name':$Token.tokens[data],'team':team}
		skin_list2[player_id] = $Token.skin_list[data]
		var room_id = 0
		userdata[player_id] = {'pos':Vector2(0,0),'ani':'stop','lk':0,'atk':''}
		userroom[player_id] = room_id 
		kill_death[player_id] = {'d':0,'k':0}
		var instance = PlayerLoad.instance()
		randomize()
		instance.position = Vector2( rand_range(spawn1[0].x,spawn1[1].x),rand_range(spawn1[0].y,spawn1[1].y))
		instance.name = str(player_id)
		instance.team = team
		$Players.add_child(instance)
#		$Token.tokens.erase(data)
		print('token is valid')
	else:
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Invalid", requester)
		print('token is invalid')
	WorldState()

func WorldState():
	if loggedusers.size() == 0:
		return
	rpc_unreliable_id(0, "WorldStatUpdate", loggedusers)
#	rpc_unreliable_id(0, "WorldTeamUpdate", teams)

func WorldPosition():
	for j in loggedusers.keys():
		rpc_unreliable_id(j, "WorldPosUpdate", userdata)

func WorldNPCState():
	if loggedusers.size() == 0:
		return
	rpc_unreliable_id(0, "NPCUpdate", NPCs)

func WorldNPCPosition():
	for j in loggedusers.keys():
		rpc_unreliable_id(j, "PosNPCUpdate", NPCdata)
#		room_array[userroom[j]].NPCdata = {}

func ChatState():
	if chat.size() > 0:
		rpc_unreliable_id(0, "ChatUpdate", chat)
		chat = []

func ScoreState():
	if loggedusers.size() == 0:
		return
	rpc_unreliable_id(0, "ScoreUpdate", kill_death, $GameEnd.time_left)

remote func MovePlayer(dir, look, attack):
	var player_id = get_tree().get_rpc_sender_id()
	if $Players.has_node(str(player_id)):
		var node = $Players.get_node(str(player_id))
		node.attack(attack)
		node.move(dir)
		node.aim(look)
		userdata[player_id]['pos'] = node.position
		userdata[player_id]['ani'] = dir
		userdata[player_id]['lk'] = look
		userdata[player_id]['atk'] = attack

remote func ReceiveChatMessage(message, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var newmsg = {str(loggedusers[player_id]) : str(message)}
	chat.append(newmsg)
	print(newmsg)

func DamagePlayer(instance_id,damage, attacker):
	var node = instance_from_id(instance_id)
	if not attacker.team == null:
		if attacker.team == node.team:
			return
	entityshealth[instance_id] -= damage
	if entityshealth[instance_id] > 0:
		rpc_id(0, "DamageUpdate", node.get_path(), entityshealth[instance_id])
	else:
		if node.alive == false:
			return
		node.die()
		Kill(node)
		if attacker.get_parent() == get_node("Players"):
			kill_death[int(attacker.name)]['k'] += 1 
			if not attacker.team == null:
				team[attacker.team] += 1
		if node.get_parent() == get_node("Players"):
			kill_death[int(node.name)]['d'] += 1 
			node.get_node('Respaw').start()
			print('player ' +loggedusers[node.name]+ ' was killed by: ' + loggedusers[attacker.name])
		node.set_physics_process(false)
		if node.has_node('CollisionShape2D'):
			node.get_node('CollisionShape2D').set_deferred("disabled", true)
		node.alive = false

func setHealth(hp, node):
	rpc_id(0, "getHealth", hp, node.get_path())

func Kill(node):
	rpc_id(0, "Die", node.get_path())

func Revive(node):
	rpc_id(0, "Spawn", node.get_path())

remote func RequestInitialPlayerData():
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "InitialPlayerData", entityshealth)

#remote func SendSkinBack():
#	var player_id = get_tree().get_rpc_sender_id()
#	var n = ['bird', 'cat','cat2', 'cat3']
#	var number = fmod(player_id,n.size())
#	var skin = load('res://assets/sprites/'+str(n[number])+'.png')
#	rpc_id(player_id, "SkinFromServer",player_id , skin.get_data().get_format(), skin.get_data().get_data())

func GameEnd():
	var winner = ''
	var highest = 0
	var value = $GameModes.victory(kill_death, team, gamemode)
	winner = value[0]
	highest = value[1]
	print('the winner is: ' + winner)
	rpc_id(0, "VictoryScreen", winner, highest, gamemode)
	$MatchRestart.start()

func RestartMatch():
	print('restarting match')
	rpc_id(0, "LoadNextScene", 'res://Client/Client.tscn')
	for i in kill_death.keys():
		kill_death[i]['k'] = 0
		kill_death[i]['d'] = 0
	for i in team.keys():
		team[i] = 0
	$GameEnd.start()
#	get_tree().reload_current_scene()
	pass # Replace with function body.

func AreaofInterestWorldPosition(player_id, data):
	rpc_unreliable_id(player_id, "WorldPosUpdate", data)

remote func GetPlayerSkin(requester,namerq):
	var player_id = get_tree().get_rpc_sender_id()
	var skin = skin_list2[namerq]
	print('send skin: ' + skin)
	rpc_id(player_id,"GetPlayerSkinResponse", skin, requester)
