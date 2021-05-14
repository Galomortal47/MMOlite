extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

func _ready():
	StartServer()

func StartServer():
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
	data = get_node("Player").dataprocess(data)
	rpc_id(player_id, "return_data", data, requester)
