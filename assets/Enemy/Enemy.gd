extends KinematicBody2D

export(NodePath) var playersnode
export(NodePath) var server
var target
var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var hp = 100

func _ready():
	randomize()
	name = str(int(rand_range(0,10000000)))
	get_node(server).entityshealth[int(name)] = hp

func hunt_player():
	for i in get_node(playersnode).get_children():
		if position.distance_to(i.position) > 150:
			target = i

func move():
	if target == null:
		return
	motion.x = (target.position - position).normalized().x * 450
	if (target.position - position).y < -100:
		if is_on_floor():
			motion.y -= 900
	if not is_on_floor():
		motion.y += 30
	motion = move_and_slide(motion, UP)
