extends Spatial


const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_name = "res://DataStore/database"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	InsertItem("haha",55)
	DeleteItem('haha')
	InsertItem("haha",33)
	UpdateItem('haha',88)
	var itemResult =  ReadItem("haha")
	print(itemResult)
	pass # Replace with function body.

func UpdateItem(id, value):
	id = "'"+id+"'"
	db.query("UPDATE PlayerInfo SET Score = "+str(value)+" WHERE Name = " + id + ";")

func DeleteItem(id):
	id = "'"+id+"'"
	db.query("DELETE FROM PlayerInfo WHERE Name = " + id + ";")

func InsertItem(id,value):
	id = "'"+id+"'"
	db.query("INSERT INTO PlayerInfo(Name, Score) VALUES("+id+","+str(value)+");")

func ReadItem(id):
	id = "'"+id+"'"
	db.query("SELECT * from PlayerInfo WHERE Name LIKE "+id+";")
	return db.query_result

func commitDataToDB():
	var tableName = "PlayerInfo"
	var dict : Dictionary = Dictionary()
	dict["Name"] = "14"
	dict["Score"] = 77
	db.insert_row(tableName,dict)

func readFromDB():
	var tableName = "PlayerInfo"
	db.query("select * from " + tableName + ";")
	for i in range(0, db.query_result.size()):
		print("Qurey results ", db.query_result[i]["Name"], " : " , db.query_result[i]["Score"])

func getItemsByUserID(id):
	db.open_db()
	db.query("select playerinfo.name as pname, iteminventory.name as iname from playerinfo left join ItemInventory on playerinfo.ID = ItemInventory.PlayerID where playerinfo.id = " + str(id))
	for i in range(0, db.query_result.size()):
		print("Qurey results ", db.query_result[i]["pname"], " : " , db.query_result[i]["iname"])
	return db.query_result

func training():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	var tableName = 'PlayerInfo'
	var dict : Dictionary = Dictionary()
	dict["Name"] = 'this is a test user3333'
	dict["Score"] = 50003333
	var dict3 : Dictionary = Dictionary()
	dict3["id"] = {
	"data_type":"int", 
	"primary_key": true, 
	"auto_increment":true
	}
	dict3["Name"] = {
	"data_type":"text", 
	"primary_key": false, 
	"auto_increment":false
	}
	dict3["Score"] = {
	"data_type":"int",
	"primary_key": false, 
	"auto_increment":false
	}
	db.create_table(tableName, dict3 )
	db.insert_row(tableName,dict)
