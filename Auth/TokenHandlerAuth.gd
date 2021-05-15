extends Node

var packet = StreamPeerTCP.new()
var peerstream = PacketPeerStream.new()

var ip = "127.0.0.1"#"104.207.129.209" #"189.126.106.201"
var port = 1911

func _ready():
	packet.connect_to_host(ip, port)

func _physics_process(delta):
	if peerstream.get_available_packet_count() > 0:
		var string = peerstream.get_packet().get_string_from_ascii()
		print(string)
		var recive_data = parse_json(string)
