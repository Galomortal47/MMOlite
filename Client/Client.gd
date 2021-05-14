extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("serv start")
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	print("User " +str(player_id)+ " Disconnected")

remote func fetch(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "return_data", data, requester)

var playerdic = {'username':'galo', 'password':'b12a26e761a2518cf4d37114e9a0b94c47e2d48b7f9790a72a98db06a438f9d7', 'id' : '8912'}

remote func AuthenticatePlayer(username, password, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var signature = (playerdic.id + password).sha256_text()
	if username == playerdic.username and playerdic.password == signature:
		var token = (str(OS.get_unix_time()).sha256_text() + signature).sha256_text()
		rpc_id(player_id, "AuthenticateResults", "connection sucess", token, requester)
		print('connection sucess')
		return
	else:
		rpc_id(player_id, "AuthenticateResults", "connection failed", {}, requester)
		print('connection failed')
	pass
