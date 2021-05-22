extends KinematicBody2D

export(NodePath) var playersnode
export(NodePath) var server
var target
var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100
var alive = true

func _ready():
	get_node('../..').entityshealth[get_instance_id()] = hp
	get_node('../..').NPCs[name] = 'enemy'

func hunt_player():
	for i in get_node(playersnode).get_children():
		if position.distance_to(i.position) > 150:
			target = i

func die():
	get_node('../..').NPCdata.erase(name) 
	get_node('../..').NPCs.erase(name) 

func move():
	get_node('../..').NPCdata[name] = {'pos':position}
	if target == null or not alive:
		return
	if position.distance_to(target.position) < 64:
		if $attack.is_stopped():
			$attack.start()
	motion.x = (target.position - position).normalized().x * 450
	if (target.position - position).y < -100:
		if is_on_floor():
			motion.y -= 900
	if not is_on_floor():
		motion.y += 30
	motion = move_and_slide(motion, UP)

func attack():
	if target == null or not alive:
		return
	if position.distance_to(target.position) < 64:
		get_parent().get_parent().DamagePlayer(target.get_instance_id(),10)
