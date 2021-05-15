extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1911
var max_players = 100

func _ready():
	StartServer()

func StartServer():
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("serv start")
	
	network.connect("peer_connected",self,"_peer_conected")
	network.connect("peer_disconnected",self,"_peer_disconected")

func _peer_conected(player_id):
	print("User " +str(player_id)+ " Connected")

func _peer_disconected(player_id):
	print("User " +str(player_id)+ " Disconnected")


