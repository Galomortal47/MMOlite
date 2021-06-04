extends KinematicBody2D

var hp = 100 
var team = 'white'
export(Texture) var weapon_texture_1
export(Texture) var weapon_texture_2

func hurt(damage):
	hp = damage
	$hp.set_text(str(hp)+'hp')
	$hp/icon.rect_size.x = float(hp)

func _ready():
	add_camera()
#	get_parent().get_parent().GetSkin()

func playnanims(anim):
	match anim:
		'stop':
			$AnimationPlayer.play('stop')
		'jump':
			$AnimationPlayer.play('jump')
		'right':
			$AnimationPlayer.play('walk')
			$anims.scale.x = -1
		'left':
			$AnimationPlayer.play('walk')
			$anims.scale.x = 1
		'attk':
			$melee/axe.texture =  weapon_texture_1
			melee_attack()
		'shot':
			$melee/axe.texture =  weapon_texture_2
		'change1':
			$melee/axe.texture =  weapon_texture_1
		'change2':
			$melee/axe.texture =  weapon_texture_2

func melee_attack():
	$melee/AnimationPlayer.play("attack")

func chat(text):
	$chatbubble/text.set_text(text)
	$chatbubble/text/AnimationPlayer.play("anim")

func tween(variable, value1, value2):
	var tween = get_node("Tween")
	tween.interpolate_property(self, variable, value1, value2, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func add_camera():
	if str(get_tree().get_network_unique_id()) == name:
		var camera = Camera2D.new()
		print('adding camera to player')
		add_child(camera)
		camera.set_h_drag_enabled(true)
		camera.set_v_drag_enabled(true)
		camera._set_current(true)
		camera.position.y -= 90
