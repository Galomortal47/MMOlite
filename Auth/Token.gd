extends Node

var packet = StreamPeerTCP.new()
var data
var string
var json2
var json = {"token":""}
var password = 'd4f8sa4t8ge4w89rtw'

func send_data(token, username, ip, skin):
	packet.connect_to_host( ip, 8082)
	print("Token: " + str(token) + " was sent")
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		json2 = parse_json(string)
	var datasend = {'key':token, 'user':username,'password': 'd4f8sa4t8ge4w89rtw', 'skin':skin}
	packet.put_var(datasend)
	packet.disconnect_from_host()

