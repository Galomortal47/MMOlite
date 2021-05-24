extends Node

var socket = TCP_Server.new()
var i = 0
var packet

var data = {}

func _ready():
	socket.listen(2909)
	packet = socket.take_connection()
	print("listening")

func _physics_process(delta):
	if socket.is_connection_available():
		packet = socket.take_connection()
	else:
		return
	if packet.get_available_bytes() > 0:
		data[packet.get_connected_host()] = packet.get_var().duplicate()
		print("received server data from: " + str(packet.get_connected_host()))
		get_parent().server_list = data
