extends Node

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.size() == 0:
		get_tree().change_scene("res://Client/Client.tscn")
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

