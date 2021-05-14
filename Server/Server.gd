extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"#"104.207.129.209" #"189.126.106.201"
var port = 1909

func StartServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	print("serv start")
	
	network.connect("connection_failed",self,"_connection_failed")
	network.connect("connection_succeeded",self,"_connection_succeeded")

func fetch(data, requester):
	rpc_unreliable_id(1,"fetch", data, requester)

func _connection_failed():
	print("connection_failed")

func _connection_succeeded():
	print("connection_succeeded")
	$Node.data_req()

remote func return_data(data, requester):
	instance_from_id(requester).consolelog(data)

func Login(username, password, requester):
	rpc_unreliable_id(1,"AuthenticatePlayer", username, password, requester)

func Register(username, password, email, requester):
	rpc_unreliable_id(1,"fetch", username, password, requester)

remote func AuthenticateResults(state, token, requester):
	print(token)
	instance_from_id(requester).results(state)
