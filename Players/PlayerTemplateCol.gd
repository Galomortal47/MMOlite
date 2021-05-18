extends KinematicBody2D

var motion = Vector2(0,0)

func move(dir):
	motion = (dir.normalized() * 300)
#	print(motion)


func _physics_process(delta):
	motion = move_and_slide(motion)
	motion = Vector2(0,0)
