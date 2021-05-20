extends KinematicBody2D

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

func chat(text):
	$chatbubble/text.set_text(text)
	$chatbubble/text/AnimationPlayer.play("anim")
