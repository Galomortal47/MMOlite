extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
onready var db = SQLite.new()
export var db_name = "res://DataStore/database3"

func _ready():
	db.path = db_name
	db.open_db()
	var table = 'PlayerInfo8'
	CreateTable(table,['id integer PRIMARY KEY AUTOINCREMENT','Name text','Score integer','Item text','Level integer'])
	DeleteItem(table,"Name",'Player')
	CreateItem(table,"Player",'Name, Score, Item, Level',[33, '"backpack"', 999])
	UpdateItem(table,"Name","Item",'Player','"pickaxe"')
	var itemResult =  ReadItem(table,"Name","Player")
	print(itemResult)
#CREATE TABLE IF NOT EXISTS projects (id integer PRIMARY KEY AUTOINCREMENT,Name text,Score integer);
func CreateTable(table,dict):
	db.query("CREATE TABLE IF NOT EXISTS "+table+" ("+ArraytoText(dict)+");")
#INSERT INTO PlayerInfo(Name, Score) VALUES(Player,1000);
func CreateItem(table,id,keys,values):
	id = "'"+id+"'"
	db.query("INSERT INTO "+table+"("+keys+") VALUES("+id+","+ArraytoText(values)+");")
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

func ArraytoText(values):
	return str(values).rstrip(']').lstrip('[')
