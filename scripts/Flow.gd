extends Camera2D
export var target : NodePath;
var node = null
func _ready():
	node = get_node(target);
func _process(delta):
	position = lerp(position,node.position,0.025);
