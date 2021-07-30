extends Control
signal next
signal chosed(i)

var chosed_id = -1
var _name = '' setget set_name
var path = "/root/Scene/CanvasLayer/Dialogue";
onready var base = get_node(path);
onready var label = get_node(path+ "/Panel/Text");
onready var tween = get_node(path+ "/Panel/Tween");
onready var container =  get_node(path+ "/Panel/CenterContainer/GridContainer");
onready var portrait =  get_node(path+ "/Panel/Portrait");
onready var pname =  get_node(path+ "/Panel/Name");

export var time = 0.1
export var waitForClick = true
export var offsetX = 30

var active = false;

func msg(text) -> void:
	if(not base.visible): show()
	label.percent_visible = 0.0
	label.text = text
	tween.interpolate_property(label, 'percent_visible', 0.0,1.0,time*len(text), Tween.TRANS_CUBIC)
	tween.start()
	yield(tween,'tween_all_completed')
	label.percent_visible = 1.0
	if(waitForClick):
		yield(self,'next')
	else:
		yield(get_tree().create_timer(0.4), "timeout")
func close():
	visible = false
func _input(event):
	if(event is InputEventMouseButton):
		emit_signal("next")
func query(msgs) -> void:
	for msg in msgs:
		yield(msg(msg),'completed')
func set_name(name):
	_name = name
	pname.text = _name
func clear_name():
	self._name = ''
func begin():
	if(base.visible):
		return;
	Utils.fade_start(self, 1.0)
	base.visible =true
func end():
	label.text = ''
	clear_name()
	yield(Utils.fade_end(self, 1.0),"completed")
	base.visible = false
func test():
	begin()
	set_name('someone')
	yield(query(['hi there', 'sfsaf', 'sfsdfa']),"completed")
	hide_portrait()
	yield(choices(['1','2']), 'completed')
	end()
func button(id):
	emit_signal("chosed")
	chosed_id = id
func choices(chs:Array):
	for i in range(0,len(chs)):
		container.get_child(i).visible = true
		container.get_child(i).text = chs[i]
	yield(self, 'chosed')
	for i in range(0,len(chs)):
		container.get_child(i).visible = false
func set_portrait(portrait: Texture):
	portrait.texture = portrait
	label.rect_position.x += portrait.rect_size.x
	label.rect_size.x -= portrait.rect_size.x
func hide_portrait():
	portrait.texture = null
	label.rect_position.x -= portrait.rect_size.x
	label.rect_size.x += portrait.rect_size.x
