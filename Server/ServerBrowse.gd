extends Node

var packet = StreamPeerTCP.new()
var data
var string
var json2
var json = {"data":""}

func _ready():
	send_data()

func send_data():
	packet.connect_to_host( "127.0.0.1", 2909)
	print("Data to Server Browser was sent")
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		json2 = parse_json(string)
	packet.put_var({
'roomname': get_parent().roomname,
'gamemode' : get_parent().gamemode,
'map' : get_parent().map,
'playeronline' : get_parent().loggedusers.size(),
'max_players' : get_parent().max_players,
'ip' :  get_parent().ip,
'port' : get_parent().port
})
	packet.disconnect_from_host()

