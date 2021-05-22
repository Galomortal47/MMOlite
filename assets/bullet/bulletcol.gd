extends KinematicBody2D

export(NodePath) var playersnode
export(NodePath) var server
var motion = Vector2(0,0)
var UP = Vector2(0,-1)
var speed = 1500
var lifespan = 20
var ignorenode

func _ready():
	randomize()
	name += str(randi())
	get_node('../..').NPCs[name] = 'bullet'

func die():
	pass

func move():
	get_node('../..').NPCdata[name] = {'pos':position}
	var dir = Vector2(cos(get_rotation()), sin(get_rotation()))
	motion = dir * speed
	motion = move_and_slide(motion, UP)
	lifespan -= 1
	if lifespan < 0:
		get_node('../..').NPCdata.erase(name) 
		get_node('../..').NPCs.erase(name) 
		get_node('../..').Kill(self)
		queue_free()
	if $bullet.is_colliding():
		if not ignorenode == $bullet.get_collider():
			get_parent().get_parent().DamagePlayer($bullet.get_collider().get_instance_id(),10)
			get_node('../..').NPCdata.erase(name) 
			get_node('../..').NPCs.erase(name) 
			get_node('../..').Kill(self)
			queue_free()
