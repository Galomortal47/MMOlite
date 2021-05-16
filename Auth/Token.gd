extends Node

var packet = StreamPeerTCP.new()
var data
var string
var json2
var json = {"token":""}

func send_data(token, username):
	packet.connect_to_host( "::1", 8082)
	print("Token: " + str(token) + " was sent")
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		json2 = parse_json(string)
	packet.put_var({token:username})
	packet.disconnect_from_host()

