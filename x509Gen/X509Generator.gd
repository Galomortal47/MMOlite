extends Node

var x509_cert_filename = "x509_Certificate.crt"
var x509_key_filename = "x509_Key.key"
onready var x509_cert_path = "user://Certificate/" + x509_cert_filename
onready var x509_key_path = "user://Certificate/" + x509_key_filename

var CN = "MultiplayerProject"
var O = "Galo"
var C = "BR"
var not_before = "20201023000000"
var not_after = "20211022235900"

func _ready():
	var directory = Directory.new()
	if directory.dir_exists("user://Certificate"):
		pass
	else:
		directory.make_dir("user://Certificate")
	CreateX509Cert()
	print("Certificate Create")

func CreateX509Cert():
	print('generating cert')
	var CNOC = "CN=" + CN + ",0=" + O + ",C=" + C
	var crypto = Crypto.new()
	var crypto_key = crypto.generate_rsa(4096)
	var x509_cert = crypto.generate_self_signed_certificate(crypto_key, CNOC, not_before, not_after)
	x509_cert.save(x509_cert_path)
	crypto_key.save(x509_key_path)

