extends KinematicBody2D

export(NodePath) var playersnode
export(NodePath) var server
var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var speed = 3000
var lifespan = 30
var ignorenode
var room = 0
var father

func _ready():
	randomize()
	name += str(randi())
	get_node('../..').NPCs[name] = 'bullet'

func die():
	pass

func move():
#	print(room)
	get_node('../..').room_array[room].NPCdata[name] = {'pos':position}
	var dir = Vector2(cos(get_rotation()), sin(get_rotation()))
	motion = dir * speed
	motion = move_and_slide(motion, UP)
	lifespan -= 1
	if lifespan < 0:
		get_node('../..').room_array[room].NPCdata.erase(name) 
		get_node('../..').NPCs.erase(name) 
		get_node('../..').Kill(self)
		queue_free()
	if $bullet.is_colliding():
		if not ignorenode == $bullet.get_collider():
			get_parent().get_parent().DamagePlayer($bullet.get_collider().get_instance_id(),10, father)
			get_node('../..').room_array[room].NPCdata.erase(name) 
			get_node('../..').NPCs.erase(name) 
			get_node('../..').Kill(self)
			queue_free()
