extends Node

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.has("-server"):
		print("starting server...")
		get_tree().change_scene("res://Server/Server.tscn")
	elif args.has("-login"):
		print("starting server...")
		get_tree().change_scene("res://Auth/Server.tscn")
	else:
		get_tree().change_scene("res://Client/Client.tscn")
