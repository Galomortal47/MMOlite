extends Node

var network = NetworkedMultiplayerENet.new()
onready var port = 1909
onready var max_players = Tokendata.maxs_players
#var cert = load('user://Certificate/x509_Certificate.crt')
#var key = load('user://Certificate/x509_Key.key')
export var online_verification_disable = false

var loggedusers = {}
var userdata = {}
var entityshealth = {}
var chat = []

var NPCs = {}
var NPCdata = {}

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
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Valid", $Token.tokens[data], requester, player_id)
		loggedusers[player_id] = $Token.tokens[data]
		userdata[player_id] = {'pos':Vector2(0,0),'ani':'stop','lk':0}
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
	rpc_unreliable_id(0, "WorldPosUpdate", userdata)

func WorldNPCState():
	rpc_unreliable_id(0, "NPCUpdate", NPCs)

func WorldNPCPosition():
	rpc_unreliable_id(0, "PosNPCUpdate", NPCdata)
	NPCdata = {}

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

func DamagePlayer(instance_id,damage):
	var node = instance_from_id(instance_id)
	entityshealth[instance_id] -= damage
	if entityshealth[instance_id] > 0:
		rpc_id(0, "DamageUpdate", node.get_path(), entityshealth[instance_id])
	else:
		Kill(node)
		node.set_physics_process(false)
		if node.has_node('CollisionShape2D'):
			node.get_node('CollisionShape2D').queue_free()
		node.alive = false

func Kill(node):
	rpc_id(0, "Die", node.get_path())

remote func RequestInitialPlayerData():
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "InitialPlayerData", entityshealth)

#remote func SendSkinBack():
#	var player_id = get_tree().get_rpc_sender_id()
#	var n = ['bird', 'cat','cat2', 'cat3']
#	var number = fmod(player_id,n.size())
#	var skin = load('res://assets/sprites/'+str(n[number])+'.png')
#	rpc_id(player_id, "SkinFromServer",player_id , skin.get_data().get_format(), skin.get_data().get_data())
