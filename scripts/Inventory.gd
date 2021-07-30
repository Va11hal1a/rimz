extends Control;

onready var inventory = ItemManager.Inventory.new();

export var gridContainerPath: NodePath;
onready var gridContainer = get_node(gridContainerPath);

export var slotInstance: PackedScene;

func _ready():
	inventory.connect("inventoryRefresh", self, "refresh");
	test();
func refresh():
	for child in gridContainer.get_children():
		child.queue_free();

	for slot in inventory.slots:
		var temp = slotInstance.instance();
		temp.init(slot.item, slot.count);
		gridContainer.add_child(temp);

func test():
	for i in range(0,10):
		inventory.addItem(Global.items[0]);
		yield(get_tree().create_timer(0.5),"timeout");
	inventory.addItem(Global.items[1]);
