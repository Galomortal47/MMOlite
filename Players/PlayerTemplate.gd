extends KinematicBody2D

var hp = 100 
export(Texture) var weapon_texture_1
export(Texture) var weapon_texture_2

func hurt(damage):
	hp = damage
	$hp.set_text(str(hp)+'hp')
	$hp/icon.rect_size.x = float(hp)

#func _ready():
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
