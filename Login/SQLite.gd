extends DatabaseManaer

func _ready():
	db.path = "user://MMOLiteDataBase"
	db.open_db()
	var tableName = 'PlayerInfo'
	var dict3 : Dictionary = Dictionary()
	db.create_table(tableName, dict3)
	CreateTable("UserLogin",['id integer PRIMARY KEY AUTOINCREMENT','username text','password text','email text','salt text','data blob'])
