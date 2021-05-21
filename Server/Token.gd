extends Node

var socket = TCP_Server.new()
var i = 0
var packet

var tokens = {}

func _ready():
	socket.listen(8082)
	packet = socket.take_connection()
	print("listening")

func _physics_process(delta):
	if socket.is_connection_available():
		packet = socket.take_connection()
	else:
		return
	if packet.get_available_packets() > 0:
		var dict = packet.get_var().duplicate()
		var key =str(dict.keys()[0])
		var value = dict[key]
		tokens[key] = value
		print("received token: "+ str(dict))
