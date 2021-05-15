extends Node

var file = File.new()
var packet = StreamPeerTCP.new()
var data
var string
var json2
var json = {"test":"123"}

func _ready():
	packet.connect_to_host( "::1", 8082)
	print("connected")

func _process(delta):
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		json2 = parse_json(string)
	else:
		packet.put_string(to_json(json))
