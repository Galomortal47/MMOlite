extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
onready var db = SQLite.new()
export var db_name = "res://DataStore/database"

func _ready():
	db.path = db_name
	db.open_db()
	CreateTable('PlayerInfo4',$TableDict.data)
	CreateItem('PlayerInfo4',"Player",'Name, Score',55)
	DeleteItem('PlayerInfo ',"Name",'haha')
	CreateItem('PlayerInfo4',"Player",'Name, Score',33)
	UpdateItem('PlayerInfo4',"Name","Score",'Player',18)
	var itemResult =  ReadItem('PlayerInfo4',"Name","Player")
	print(itemResult)
#CREATE TABLE IF NOT EXISTS projects (id integer PRIMARY KEY AUTOINCREMENT,Name text,Score integer);
func CreateTable(table,dict):
	db.create_table(table, dict)
#INSERT INTO PlayerInfo(Name, Score) VALUES(Player,1000);
func CreateItem(table,id,keys,values):
	id = "'"+id+"'"
	db.query("INSERT INTO "+table+"("+keys+") VALUES("+id+","+str(values)+");")
#SELECT * from PlayerInfo WHERE Name LIKE Player;
func ReadItem(table,key,id):
	id = "'"+id+"'"
	db.query("SELECT * from "+table+" WHERE "+key+" LIKE "+id+";")
	return db.query_result
#UPDATE PlayerInfo SET Score = 1000 WHERE Name = Player;
func UpdateItem(table,key,valuekey,id,value):
	id = "'"+id+"'"
	db.query("UPDATE "+table+" SET "+valuekey+" = "+str(value)+" WHERE "+key+" = " + id + ";")
#DELETE FROM PlayerInfo" WHERE Name = Player;
func DeleteItem(table,key,id):
	id = "'"+id+"'"
	db.query("DELETE FROM "+table+" WHERE "+key+" = " + id + ";")
