extends KinematicBody2D

var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 4
var coyote_time = true

func move(dir):
	match dir:
		'jump':
			jump()
		'left':
			if motion.x > -200:
				if is_on_floor():
					motion.x += -20
				else:
					motion.x += -10
		'right':
			if motion.x < 200:
				if is_on_floor():
					motion.x += 20
				else:
					motion.x += 10
		'stop':
			if is_on_floor():
				motion.x *= 0.8

func jump():
	if coyote_time:
		motion.y = 0
		motion.y -= 400
		coyote_time = false

func _physics_process(delta):
	if not is_on_floor():
		motion.y += 10
		$Timer.start()
	else:
		coyote_time = true
	motion = move_and_slide(motion, UP)


func _on_Timer_timeout():
	coyote_time = false
	pass # Replace with function body.
