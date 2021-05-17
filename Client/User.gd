extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"#"104.207.129.209" #"189.126.106.201"
export var port = 1911
#var cert = load('user://Certificate/x509_Certificate.crt')
signal connected

func StartServer():
#	network.set_dtls_enabled(true)
#	network.set_dtls_verify_enabled(false)
#	network.set_dtls_certificate(cert)
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
	emit_signal("connected")

remote func return_data(data, requester):
	instance_from_id(requester).consolelog(data)

func TokenVerificationResults(token, requester):
	print('verification token send')
	rpc_id(1,"ReturnTokenVerification", token, requester)

#var PlayerLoad = load('res://Players/PlayerTemplate.tscn')

remote func ReturnTokenVerificationResults(data, username, requester):
#	if data == 'Token Valid':
#		var instance = PlayerLoad.instance()
#		instance.name = username
#		$Players.add_child(instance)
	pass

remote func WorldStatUpdate(loggedusers):
	$Players.spawn_despawn(loggedusers)
	
remote func WorldPositionUpdate(userdata):
	$Players.sync_position(userdata)

remote func UserDisconnected(player_id):
	$Players.user_remove(player_id)

func MovePlayer(dir):
	rpc_unreliable_id(1,"MovePlayer", dir)
