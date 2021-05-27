extends Node

func _ready():
	$HTTPRequest.set_download_file('user://patches/patch.pck')
	$HTTPRequest.request('https://git.galodev.net/galo/gittest/raw/master/backpack.pck')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var directory = Directory.new()
		if directory.dir_exists("user://patches"):
			pass
		else:
			directory.make_dir("user://patches")
		ProjectSettings.load_resource_pack('user://patches/patch.pck')
		get_tree().change_scene_to(load("res://Tests/TestZone.tscn"))
