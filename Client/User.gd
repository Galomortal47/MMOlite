extends Node

var network = NetworkedMultiplayerENet.new()
var ip =  '127.0.0.1'
var port = 1909
signal connected

func StartServer():
	network = NetworkedMultiplayerENet.new()
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
	$UI.data_req()
	emit_signal("connected")

remote func return_data(data, requester):
	instance_from_id(requester).consolelog(data)

func TokenVerificationResults(token, requester):
	print('verification token send')
	rpc_id(1,"ReturnTokenVerification", token, requester)

#var PlayerLoad = load('res://Players/PlayerTemplate.tscn')

remote func ReturnTokenVerificationResults(data, username, requester, player_id):
	$Players.main_user = str(player_id)
#	if data == 'Token Valid':
#		var instance = $Players.PlayerLoad.instance()
#		instance.name = username
#		$Players.add_child(instance)
	pass

remote func WorldStatUpdate(loggedusers):
	$Players.spawn_despawn(loggedusers)
	
remote func WorldPosUpdate(userdata):
	$Players.sync_position(userdata)

remote func NPCUpdate(loggedusers):
	$NPCs.spawn_despawn(loggedusers)
	
remote func PosNPCUpdate(userdata):
	$NPCs.sync_position(userdata)

remote func UserDisconnected(player_id):
	$Players.user_remove(player_id)

remote func ChatUpdate(chat):
	$UI/chat.update_chat(chat)

remote func DamageUpdate(nodepath, damage):
	if has_node(nodepath):
		get_node(nodepath).hurt(damage)

func MovePlayer(dir, look, attack):
	rpc_unreliable_id(1,"MovePlayer", dir, look, attack)

func SendChatMessage(message, requester):
	rpc_id(1,"ReceiveChatMessage", message, requester)

remote func Die(nodepath):
	if has_node(nodepath):
		get_node(nodepath).visible = false

remote func InitialPlayerData(playershealth):
	for player_id in playershealth.keys():
		if $Players.has_node(str(player_id)):
			$Players.get_node(str(player_id)).hurt(playershealth[player_id ])

func GetInitialPlayerData():
	rpc_id(1,"RequestInitialPlayerData")

#func GetSkin():
#	rpc_id(1,"SendSkinBack")

#remote func SkinFromServer(player_id,format, skin):
#	get_node("Players").change_skin(player_id,format, skin)
