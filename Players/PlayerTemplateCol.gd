extends KinematicBody2D

var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100
var coyote_time = true
var alive = true
var nextshoot = true
var team = null

var BulletLoad = load('res://assets/Enemy/Bulletcol.tscn')

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

func attack(dir):
	match dir:
		'attk':
			melee_attack()
		'shot':
			shoot_attack()

func jump():
	if coyote_time:
		motion.y = 0
		motion.y -= 400
		coyote_time = false

func _physics_process(delta):
	if not is_on_floor():
		motion.y += 10
		$coyotetime.start()
	else:
		coyote_time = true
	motion = move_and_slide(motion, UP)

func aim(dir):
	$melee.rotation_degrees  = dir

func melee_attack():
	if alive:
		$melee/AnimationPlayer.play("attack")

func shoot_attack():
	if alive and nextshoot:
		$shoottimer.start()
		var bulletinstance = BulletLoad.instance()
		bulletinstance.rotation = $melee.rotation
		bulletinstance.ignorenode = self
		bulletinstance.position = position
		bulletinstance.father = self
		nextshoot = false
		get_node('../../NPCs').add_child(bulletinstance)

func die():
	pass

func _on_Timer_timeout():
	coyote_time = false
	pass # Replace with function body.

func _on_shoottimer_timeout():
	nextshoot = true
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body == self:
		return
	body.hp -= 20
	get_parent().get_parent().DamagePlayer(body.get_instance_id(),20,self)
	pass # Replace with function body.

func Respaw():
	set_physics_process(true)
	get_node('CollisionShape2D').set_deferred("disabled", false)
	alive = true
	hp = 100
	get_node('../..').entityshealth[get_instance_id()] = hp
	position = Vector2(0,0)
	get_node('../..').Revive(self)
	get_node('../..').setHealth(hp, self)
	pass # Replace with function body.

func SyncData():
	var Areadata = {}
	var count = 0
	var maxs = 25
	for i in $AreaofInterest.get_overlapping_bodies():
		if count <= maxs:
			var player_id = int(i.name)
			if not get_node('../..').userdata.has(player_id):
				return
			Areadata[player_id] = get_node('../..').userdata[player_id]
			count += 1
	get_node('../..').AreaofInterestWorldPosition(int(name),Areadata)
	pass # Replace with function body.
