extends KinematicBody2D

export(NodePath) var playersnode
export(NodePath) var server
var target
var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100
var alive = true
var team = null
var vision = 150

func _ready():
	name = str(get_instance_id())
	get_node('../..').entityshealth[get_instance_id()] = hp
	get_node('../..').NPCs[name] = 'enemy'

func hunt_player():
	for i in get_node(playersnode).get_children():
		if position.distance_to(i.position) < vision:
			target = i.get_path()

func die():
	get_node('../..').NPCdata.erase(name) 
	get_node('../..').NPCs.erase(name) 
	queue_free()

func move():
	get_node('../..').NPCdata[name] = {'pos':position}
	if get_node_or_null(target) == null or not alive:
		return
	if position.distance_to(get_node_or_null(target).position) < 64:
		if $attack.is_stopped():
			$attack.start()
	motion.x = (get_node_or_null(target).position - position).normalized().x * 450
	if (get_node_or_null(target).position - position).y < -100:
		if is_on_floor():
			motion.y -= 900
	if not is_on_floor():
		motion.y += 90
	motion = move_and_slide(motion, UP)

func attack():
	if get_node_or_null(target) == null or not alive:
		return
	if position.distance_to(get_node_or_null(target).position) < 64:
		get_parent().get_parent().DamagePlayer(get_node_or_null(target).get_instance_id(),10,self)
