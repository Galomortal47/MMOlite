extends Node

var network = NetworkedMultiplayerENet.new()
export var port = 1909
var max_players = 100
var cert = load('user://Certificate/x509_Certificate.crt')
var key = load('user://Certificate/x509_Key.key')

func _ready():
	StartServer()

func StartServer():
	network.set_dtls_key(key)
	network.set_dtls_certificate(cert)
	network.set_dtls_enabled(true)
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

var playerdic = {'username':'galo', 'password':'b12a26e761a2518cf4d37114e9a0b94c47e2d48b7f9790a72a98db06a438f9d7', 'id' : '8912', 'salt' : 'salt', 'email':''}

remote func AuthenticatePlayer(username, password, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var signature = encryptor(playerdic.salt, password)
	if username == playerdic.username and playerdic.password == signature:
		randomize()
		var token = (str(randi()).sha256_text() + signature).sha256_text() + str(OS.get_unix_time())
		rpc_id(player_id, "AuthenticateResults", "Welcome back: " + str(username), token, requester)
		print('connection sucess')
		return
	else:
		rpc_id(player_id, "AuthenticateResults", "connection failed", {}, requester)
		print('connection failed')
	pass

remote func RegisterPlayer(username, password, email, salt, requester):
	var player_id = get_tree().get_rpc_sender_id()
	playerdic['username'] = username
	playerdic['password'] = encryptor(salt, password)
	playerdic['email'] = email
	playerdic['salt'] = salt
	rpc_id(player_id, "AuthenticateResults", "Thanks for Registering: " + str(username), {}, requester)
	pass

func encryptor(salt, password):
	var crypt = password
	var time = int(OS.get_system_time_msecs())
	for i in 2048:
		crypt = (salt + crypt).sha256_text()
	print("encryption time is: "+str(int(OS.get_system_time_msecs()-time)))
	return crypt
