extends Node

var network = NetworkedMultiplayerENet.new()
onready var port = Tokendata.PORT
onready var max_players = Tokendata.maxs_players
#var cert = load('user://Certificate/x509_Certificate.crt')
#var key = load('user://Certificate/x509_Key.key')
export var online_verification_disable = false

var loggedusers = {}
var userdata = {}
var playershealth = {}
var chat = []

var PlayerLoad = load('res://Players/PlayerTemplateCol.tscn')

func _ready():
	StartServer()

func StartServer():
#	network.set_dtls_key(key)
#	network.set_dtls_certificate(cert)
#	network.set_dtls_enabled(true)
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("serv start on port: " + str(port) + " with an limit of "+str(max_players) )
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	loggedusers.erase(player_id)
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
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Valid", $Token.tokens[data], requester)
		loggedusers[player_id] = $Token.tokens[data]
		userdata[player_id] = {'pos':Vector2(0,0),'ani':'stop','lk':0}
		playershealth[player_id] = 100
		var instance = PlayerLoad.instance()
		randomize()
		instance.position = Vector2( rand_range(0,100),rand_range(0,60))
		instance.name = str(player_id)
		$Players.add_child(instance)
		$Token.tokens.erase(data)
	else:
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Invalid", requester)

func WorldState():
	rpc_unreliable_id(0, "WorldStatUpdate", loggedusers)

func WorldPosition():
	rpc_unreliable_id(0, "WorldPositionUpdate", userdata)

func ChatState():
	if chat.size() > 0:
		rpc_unreliable_id(0, "ChatUpdate", chat)
		chat = []

remote func MovePlayer(dir, look):
	var player_id = get_tree().get_rpc_sender_id()
	var node = $Players.get_node(str(player_id))
	node.move(dir)
	node.aim(look)
	userdata[player_id]['pos'] = node.position
	userdata[player_id]['ani'] = dir
	userdata[player_id]['lk'] = look

remote func ReceiveChatMessage(message, requester):
	var player_id = get_tree().get_rpc_sender_id()
	chat.append({str(loggedusers[player_id]) : str(message)})

func DamagePlayer(player_id,damage):
	playershealth[player_id] -= damage
	if playershealth[player_id] > 0:
		rpc_id(0, "DamageUpdate", player_id,  playershealth[player_id])
	else:
		rpc_id(0, "Die", player_id)
		$Players.get_node(str(player_id)).set_physics_process(false)
		$Players.get_node(str(player_id)).get_node('CollisionShape2D').queue_free()
		$Players.get_node(str(player_id)).alive = false

#remote func SendSkinBack():
#	var player_id = get_tree().get_rpc_sender_id()
#	var n = ['bird', 'cat','cat2', 'cat3']
#	var number = fmod(player_id,n.size())
#	var skin = load('res://assets/sprites/'+str(n[number])+'.png')
#	rpc_id(player_id, "SkinFromServer",player_id , skin.get_data().get_format(), skin.get_data().get_data())
