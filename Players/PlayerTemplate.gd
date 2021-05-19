extends KinematicBody2D

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
