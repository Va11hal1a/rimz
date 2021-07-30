extends Entity

export var radius = 100.0;
export var targetGroup = "player"

onready var roamState = RoamState.new();
onready var targetFollowing = TargetFollowing.new();


func _ready():
	._ready();
	roamState.init(self);
	targetFollowing.init(self);
	$Scan.connect("body_entered",self,"enteredArea");
	self.curState = roamState;

func _process(delta):
	._process(delta);

func stateControl():
	.stateControl();

func enteredArea(body):
	if("player" in body.get_groups()):
		targetFollowing.target = body;
		self.curState = targetFollowing;
