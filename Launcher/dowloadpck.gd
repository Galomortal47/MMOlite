extends Node

func _ready():
	$HTTPRequest.request('https://git.galodev.net/galo/Aulas-Conexao/raw/master/Aula%201%20-%20Intodru%c3%a7ao.md')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var directory = Directory.new()
		if directory.dir_exists("user://patches"):
			pass
		else:
			directory.make_dir("user://patches")
		var data = load("res://Launcher/dataresource.gd").new()
		data.data = [body]
		ResourceSaver.save('user://patches/readme.tres', data)
		var loader = load("user://patches/readme.tres")
		$Label.set_text(loader.data[0].get_string_from_ascii())

