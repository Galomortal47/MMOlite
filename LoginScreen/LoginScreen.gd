extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"#"104.207.129.209" #"189.126.106.201"
var port = 1911

func StartServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	print("serv start")
	
	network.connect("connection_failed",self,"_connection_failed")
	network.connect("connection_succeeded",self,"_connection_succeeded")

func fetch(data, requester):
	rpc_unreliable_id(1,"fetch", data, requester)

func _connection_failed():
	print("Failed to connect to authentication server")

func _connection_succeeded():
	print("Succesfully connected to authentication server")
	$Node.data_req()

remote func AuthenticatePlayer(username, password, player_id):
	pass

remote func AuthenticateResults(username, password, player_id):
	pass
