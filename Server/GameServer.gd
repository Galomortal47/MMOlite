extends Node

var network = NetworkedMultiplayerENet.new()
export var port = 1909
var max_players = 100
#var cert = load('user://Certificate/x509_Certificate.crt')
#var key = load('user://Certificate/x509_Key.key')

var loggedusers = {}

func _ready():
	StartServer()

func StartServer():
#	network.set_dtls_key(key)
#	network.set_dtls_certificate(cert)
#	network.set_dtls_enabled(true)
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("serv start")
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	loggedusers.erase(player_id)
	print("User " +str(player_id)+ " Disconnected")

remote func fetch(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_unreliable_id(player_id, "return_data", data, requester)

remote func ReturnTokenVerification(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	print('token is being verified')
	if $Token.tokens.has(data):
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Valid", $Token.tokens[data], requester)
		loggedusers[player_id] = $Token.tokens[data]
		$Token.tokens.erase(data)
	else:
		rpc_id(player_id, "ReturnTokenVerificationResults", "Token Invalid", requester)

func WorldState():
	rpc_id(0, "WorldStatUpdate", loggedusers)
