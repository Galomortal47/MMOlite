extends Node

func _ready():
	if ResourceLoader.exists('user://patches/baidu.png'):
		$Sprite.texture = ResourceLoader.load('res://Development/DLC/baidu.png')
	else:
		$HTTPRequest.request('https://www.baidu.com/img/bd_logo1.png')

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var img = Image.new()
		if img.load_png_from_buffer(body) == 0:
			var directory = Directory.new()
			if directory.dir_exists("user://patches"):
				pass
			else:
				directory.make_dir("user://patches")
			img.save_png('user://patches/baidu.png')
			var texture = ImageTexture.new()
			texture.create_from_image(img)
			$Sprite.texture = texture
