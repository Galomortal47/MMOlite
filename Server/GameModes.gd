extends Node

var last_team = 'red'

func chooseteam(gamemode):
	match gamemode:
		'ffa':
			return FreeForAll()
		'TDM':
			return TeamDeathMatch()
		'PVE':
			return PVE()
	pass

func FreeForAll():
	return null

func TeamDeathMatch():
	if last_team == 'red':
		last_team = 'blue'
		return 'blue'
	if last_team == 'blue':
		last_team = 'red'
		return 'red'

func PVE():
	get_parent().get_node("MonsterSpawner").start()
	return 'red'
	pass

func victory(kill_death, team, gamemode):
	var highest = 0
	var winner = 'Draw'
	match gamemode:
		'ffa':
			for i in kill_death.keys():
				if kill_death[i]['k'] > highest:
					highest =  kill_death[i]['k'] 
					winner =  i
		'TDM':
			for i in team.keys():
				if team[i] > highest:
					highest =  team[i]
					winner =  i
		'PVE':
			for i in team.keys():
				if team[i] > highest:
					highest =  team[i]
					winner =  i
	return [winner, highest]
