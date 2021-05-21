extends KinematicBody2D

var hp = 100 

func hurt(damage):
	hp = damage
	$hp.set_text(str(hp)+'hp')

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
			melee_attack()

func melee_attack():
	$melee/AnimationPlayer.play("attack")

func chat(text):
	$chatbubble/text.set_text(text)
	$chatbubble/text/AnimationPlayer.play("anim")
