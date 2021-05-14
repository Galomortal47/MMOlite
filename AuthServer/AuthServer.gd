extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1911
var max_servers = 5

func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	print("AuthServer has started")
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(gateway_id):
	print("Gateway " +str(gateway_id)+ " Connected")

func _peer_disconected(gateway_id):
	print("Gateway " +str(gateway_id)+ " Disconnected")

var playerdic = {'username':'galo', 'password':'123', 'id' : '8912'}

remote func AuthenticatePlayer(username, password, requester):
	var signature = (playerdic.id + playerdic.password).sha256_text()
	if username == playerdic.username and password == signature:
		var token = (str(OS.get_unix_time()).sha256_text() + signature).sha256_text()
		instance_from_id(requester).consolelog({"connection":"Suceess",'Token': token})
		
		return
	else:
		instance_from_id(requester).consolelog({"connection":"failed"})
	pass
