extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "157.245.218.42"#"104.207.129.209" #"189.126.106.201"
var port = 1911

func StartServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	print("serv start")
	
	network.connect("connection_failed",self,"_connection_failed")
	network.connect("connection_succeeded",self,"_connection_succeeded")

func Login(username, password, requester):
	rpc_unreliable_id(1,"AuthenticatePlayer", username, password, requester)

func Register(username, password, email, requester):
	rpc_unreliable_id(1,"fetch", username, password, requester)

func _connection_failed():
	print("Failed to connect to authentication server")

func _connection_succeeded():
	print("Succesfully connected to authentication server")
	$Node.data_req()

remote func AuthenticatePlayer(username, password, requester):
	pass

remote func AuthenticateResults(state, token):
	$Login/VBoxContainer/Label2.set_text(state)
	$Register/VBoxContainer/Label2.set_text(state)
