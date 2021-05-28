extends Node

var network = NetworkedMultiplayerENet.new()
export var port = 1909
var max_players = 100
var cert = load('user://Certificate/x509_Certificate.crt')
var key = load('user://Certificate/x509_Key.key')
var server_list
var room_list = {}

var token_list = {}

func _ready():
	StartServer()

func StartServer():
	network.set_dtls_key(key)
	network.set_dtls_certificate(cert)
	network.set_dtls_enabled(true)
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("serv start at port: " +str(port))
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	print("User " +str(player_id)+ " Disconnected")

remote func fetch(data, requester):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "return_data", data, requester)

var playerdic = {}

remote func AuthenticatePlayer(username, password, requester):
	var sql = $SQLite.ReadItem("UserLogin","username",username)
	if not sql.size() > 0:
		return
	playerdic = sql[0]
	var player_id = get_tree().get_rpc_sender_id()
	var signature = encryptor(playerdic.salt, password)
	if username == playerdic.username and playerdic.password == signature:
		randomize()
		var token = (str(randi()).sha256_text() + signature).sha256_text() + str(OS.get_unix_time())
		token_list[player_id] = {'tk':token,'usr':playerdic.username}
		rpc_id(player_id, "AuthenticateResults", "Welcome back", token, requester)
		print('connection sucess')
		return
	else:
		rpc_id(player_id, "AuthenticateResults", "connection failed", {}, requester)
		print('connection failed')
	pass

remote func ServerAddress(ip, port):
	var player_id = get_tree().get_rpc_sender_id()
	print('fetching server: ' + ip + ":" + str(port))
#	print(token_list)
	if token_list.has(player_id):
		$Token.send_data(token_list[player_id]['tk'],token_list[player_id]['usr'] , ip)

remote func RegisterPlayer(username, password, email, salt, requester):
	var player_id = get_tree().get_rpc_sender_id()
	if $SQLite.ReadItem("UserLogin","username",username).size() > 0:
		rpc_id(player_id, "AuthenticateResults", "username is taken", {}, requester)
		return
	$SQLite.CreateItem("UserLogin",username,'username, password, email, salt',[encryptor(salt, password),email,salt])
	rpc_id(player_id, "AuthenticateResults", "Thanks for Registering: " + str(username), {}, requester)
	pass

func encryptor(salt, password):
	var crypt = password
	var time = int(OS.get_system_time_msecs())
	for i in 1024:
		crypt = (salt + crypt).sha256_text()
	print("encryption time is: "+str(int(OS.get_system_time_msecs()-time)))
	return crypt

remote func fetch_servers():
#	print('data requested')
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "return_server_list", server_list)
