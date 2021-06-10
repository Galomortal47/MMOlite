extends Node

var socket = TCP_Server.new()
var i = 0
var packet

var tokens = {}
var skin_list = {}
var password = 'd4f8sa4t8ge4w89rtw'

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
		var dict = packet.get_var().duplicate()
		var value = dict['key']
		if password == dict['password']:
			tokens[value] = dict['user']
			skin_list[value] = dict['skin']
			print("received token: "+ str(dict))
		else:
			print('invalid password')
