extends KinematicBody2D

var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100
var coyote_time = true
var alive = true
var nextshoot = true
var team = null

var lk = 0
var ani = "stop"
var atk = ""
var pos = Vector2()

var BulletLoad = load('res://assets/Enemy/Bulletcol.tscn')

func _ready():
	get_node('../..').entityshealth[get_instance_id()] = hp

func move():
	match ani:
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
				motion.x *= 0.95

func aim():
	$melee.rotation_degrees  = lk

func attack():
	match atk:
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
		motion.y += 30
		$coyotetime.start()
	else:
		coyote_time = true
	motion = move_and_slide(motion, UP)

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

var add = 10
var thread = Thread.new()
var mutex = Mutex.new()
var Areadata = {}

func SyncData():
	_on_load_pressed()
	attack()
	move()
	aim()

func _bg_load(path):
	var tex = lightpos()
	call_deferred("_bg_load_done")
	return tex # return it

func _bg_load_done():
	var tex = thread.wait_to_finish()
	get_node('../..').rpc_unreliable_id(int(name), "WorldPosUpdate", Areadata)
	add = tex

func _on_load_pressed():
	if (thread.is_active()):
		return
	thread.start(self, "_bg_load", add)

func lightpos():
	Areadata = {}
	var bodies = $AreaofInterest.get_overlapping_bodies()
	if bodies.size() > 20:
		bodies.resize(20)
		bodies.append(self)
	for i in bodies:
		mutex.lock()
		var player_id = int(i.name)
		Areadata[player_id] = {}
		Areadata[player_id]['pos'] = i.position
		Areadata[player_id]['ani'] = i.ani
		Areadata[player_id]['lk'] = i.lk
		Areadata[player_id]['atk'] = i.atk
		mutex.unlock()
	pass # Replace with function body.
