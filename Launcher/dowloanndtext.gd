extends Node

var currentversion = 100
var status = 0
var downloaded_bytes = 0
var body_size = 0
var dowload = true

func _ready():
	if ResourceLoader.exists('user://patches/currentversion.tres'):
		var loader = load("user://patches/currentversion.tres")
		currentversion = loader.data[0]['version']
		print(currentversion)
	var directory = Directory.new()
	if directory.dir_exists("user://patches"):
		pass
	else:
		directory.make_dir("user://patches")
	$HTTPRequest2.request('https://git.galodev.net/galo/gittest/raw/master/version.json')

func dowloadupdate():
	print('dowloading patch')
	$HTTPRequest.set_download_file('user://patches/newpatch.pck')
	$HTTPRequest.request('https://git.galodev.net/galo/gittest/raw/master/MMOlite.pck')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		ProjectSettings.load_resource_pack('user://patches/newpatch.pck')
		get_tree().change_scene_to(load("res://Client/Client.tscn"))

func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var data = JSON.parse(body.get_string_from_ascii())
	var dataprocess = data.result
	print(body.get_string_from_ascii())
	print(dataprocess)
	body_size = dataprocess['size']
	if dataprocess['version'] > currentversion:
		dowloadupdate()
		dowload = false
		var data2 = load("res://Launcher/dataresource.gd").new()
		data2.data = [dataprocess]
		ResourceSaver.save('user://patches/currentversion.tres', data2)
	else:
		print('no version to dowload')
		$Label.text = 'you are on the most recent version!!!'
	pass # Replace with function body.

func _process(delta):
	status = $HTTPRequest.get_http_client_status()
	downloaded_bytes = $HTTPRequest.get_downloaded_bytes()
	if not dowload:
		$Label.text = 'dowloading '+str(downloaded_bytes/1024) +' kbs of '+ str(int(body_size)/1024) +' kbs'
