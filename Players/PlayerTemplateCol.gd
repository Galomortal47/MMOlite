extends KinematicBody2D

var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100
var coyote_time = true
var alive = true

func _ready():
	get_node('../..').entityshealth[get_instance_id()] = hp

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
		'attk':
			melee_attack()

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

func aim(dir):
	$melee.rotation = dir

func melee_attack():
	if alive:
		$melee/AnimationPlayer.play("attack")

func _on_Timer_timeout():
	coyote_time = false
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body == self:
		return
	body.hp -= 20
	get_parent().get_parent().DamagePlayer(body.get_instance_id(),20)
	pass # Replace with function body.
