extends Button

func _ready():
	connect("button_up",self,"button_up");
func button_up():
	get_parent().get_node("Inventory").visible = !get_parent().get_node("./Inventory").visible;
	print('but')
