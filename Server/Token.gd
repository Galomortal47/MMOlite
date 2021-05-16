extends Node

var socket = TCP_Server.new()
var i = 0
var packet

func _ready():
	socket.listen(8082)
	packet = socket.take_connection()
	print("listening")

func _physics_process(delta):
	if socket.is_connection_available():
		packet = socket.take_connection()
	else:
		return
	if packet.get_available_bytes() > 0:
		print("received token: "+ packet.get_string())
