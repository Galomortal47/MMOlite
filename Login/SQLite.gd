extends DatabaseManaer

func _ready():
	CreateTable("UserLogin",['id integer PRIMARY KEY AUTOINCREMENT','username text','password text','email text','salt text'])

