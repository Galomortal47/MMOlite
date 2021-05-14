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

var playerdic = {'username':'galo', 'password':'123', 'id' : '8912'}

remote func AuthenticatePlayer(username, password, requester):
	var signature = (playerdic.id + playerdic.password).sha256_text()
	if username == playerdic.username and password == signature:
		var token = (str(OS.get_unix_time()).sha256_text() + signature).sha256_text()
		instance_from_id(requester).AuthenticateResults("connection Suceess", token)
		return
	else:
		instance_from_id(requester).AuthenticateResults("connection failed")
	pass
