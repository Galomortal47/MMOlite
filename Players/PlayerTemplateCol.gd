extends KinematicBody2D

var motion = Vector2(0,0)
var UP = Vector2(0,-1)

func move(dir):
	match dir:
		'jump':
			jump()
		'left':
			motion.x = -400
		'right':
			motion.x = 400
		'stop':
			motion.x *= 0.9

func jump():
	if is_on_floor():
		print('jump')
		motion.y = 0
		motion.y -= 400

func _physics_process(delta):
	if not is_on_floor():
		motion.y += 10
	motion = move_and_slide(motion, UP)


