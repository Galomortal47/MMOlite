extends Node

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.size() == 0:
		Tokendata.ip = '45.76.247.182'#'127.0.0.1'#"157.245.218.42"
		Tokendata.PORT = 1911
		get_tree().change_scene("res://Launcher/dowloadupdate.tscn")
#		get_tree().change_scene("res://Launcher/dowloadupdate.tscn")
		return
	match args[0]:
		"-server":
			print("player starting server...")
			Tokendata.PORT = int(args[1])
			Tokendata.maxs_players = int(args[2])
			get_tree().change_scene("res://Server/Server.tscn")
		"-login":
			print("auth starting server...")
			get_tree().change_scene("res://Auth/Server.tscn")
		"-x509":
			print("generating SSl Cert...")
			get_tree().change_scene("res://x509Gen/X509Generator.tscn")
		"-client":
			Tokendata.ip = str(args[1])
			Tokendata.PORT = int(args[2])
			get_tree().change_scene("res://Client/Client.tscn")

