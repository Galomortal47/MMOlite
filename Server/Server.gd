extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"#"104.207.129.209" #"189.126.106.201"
export var port = 1911
var cert = load('user://Certificate/x509_Certificate.crt')

func StartServer():
	network.set_dtls_enabled(true)
	network.set_dtls_verify_enabled(false)
	network.set_dtls_certificate(cert)
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
	rpc_id(1,"AuthenticatePlayer", username, password, requester)

func Register(username, password, email, salt, requester):
	rpc_id(1,"RegisterPlayer", username, password, email, salt, requester)

remote func AuthenticateResults(state, token, requester):
	print(token)
	instance_from_id(requester).results(state)
