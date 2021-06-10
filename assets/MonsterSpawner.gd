extends Timer

var zombie = load('res://assets/Enemy/NPCcol.tscn')
var maxzombie = 32

func _on_MonsterSpawner_timeout():
	var z_count = 0
	for i in get_parent().get_node('NPCs').get_children():
		if i.is_in_group('zombie'):
			z_count += 1
	if z_count < maxzombie:
		var z = zombie.instance()
		z.vision = 5000
		var c = []
		for i in get_children():
			c.append(i.position)
		c.shuffle()
		get_parent().get_node('NPCs').add_child(z)
		z.position = c[0]
	pass # Replace with function body.
