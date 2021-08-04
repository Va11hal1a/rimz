extends Entity

var inventoryId = 0
func _ready():
	._ready();
	add_to_group("player");
	Global.players.push_back(self);

func _process(delta):
	._process(delta);
	self.direction = Vector2();
	if(Global.joystick.currentForce!=Vector2(0,0)):
		self.direction = Global.joystick.currentForce*self.speed*Vector2(1,-1);
	if(self.use != null && Global.useJoystick.currentForce!=Vector2(0,0)):
		self.use.do(Global.useJoystick.currentForce*Vector2(1,-1));

