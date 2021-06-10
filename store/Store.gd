extends NinePatchRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var money = 2500
var lastone = null
export var price = {'chick':750,'cat':500,'cat2':1200,'cat3':1150}
var serverdata = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.set_max_text_lines(2)
	for i in price.keys():
		var icon = load('res://assets/sprites/'+i+'.png')
		$RichTextLabel.add_item(i + '\n' + ' price: ' + str(price[i]),icon)
	pass # Replace with function body.

func _on_RichTextLabel_item_activated(index):
	lastone = index
	if not serverdata.has(price.keys()[index]):
		$ConfirmationDialog.popup_centered(Vector2(200,70))
	else:
		get_parent().BuyItem(lastone)

func setmoney():
	$Label2.set_text(str(money) + ' money')
	pass # Replace with function body.

func _on_ConfirmationDialog_confirmed():
	get_parent().BuyItem(lastone)
	pass # Replace with function body.

func response(state, moneyrep,have):
	money = moneyrep
	serverdata = have
	setmoney()
	for i in have:
		$RichTextLabel.set_item_custom_bg_color(price.keys().find(i),Color(0,0.7,0.3))
	if not state == '':
		$AcceptDialog.set_text(state)
		$AcceptDialog.popup_centered(Vector2(83,58))

func _on_store_button_down():
	visible = !visible
	get_parent().StoreData()
	pass # Replace with function body.
