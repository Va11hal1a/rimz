extends Control;

onready var inventory = ItemManager.Inventory.new();

export var gridContainerPath: NodePath;
onready var gridContainer = get_node(gridContainerPath);

export var slotInstance: PackedScene;
var selectedSlot setget setSlot;

onready var nameLabel = $Panel/Container/Name;
onready var descriptionLabel = $Panel/Container/Description;

var debug = false;

func clearActions(slot):
	for action in slot.item.actions:

		for child in $Panel/Container.get_children():
			if(child is Button):
				child.queue_free();

func clearDefnName():
	nameLabel.text = "";
	descriptionLabel.text = "";	
				
func setSlot(slot):
	if(selectedSlot == slot):
		return;

	clearActions(slot);

	nameLabel.text = slot.item.name;
	descriptionLabel.text = slot.item.description;

	for action in slot.item.actions:
		var button = preload("res://prefabs/ActionButton.tscn").instance();
		button.text = action;
		button.connect("button_up",self,action,[slot]);
		$Panel/Container.add_child(button);
	

func _ready():
	inventory.connect("inventoryRefresh", self, "refresh");
	test();

func refresh():
	for child in gridContainer.get_children():
		child.queue_free();

	var id = 0;

	for slot in inventory.slots:
		var temp = slotInstance.instance();
		temp.init(slot.item, slot.count);
		temp.connect("button_up",self,"slot_select",[id]);
		gridContainer.add_child(temp);

		id+=1;

func test():
	for i in range(0,10):
		inventory.addItem(Global.items[0]);
	inventory.addItem(Global.items[1]);

func slot_select(id):
	print(inventory.slots)
	setSlot(inventory.slots[id]);

func use(slot):
	if(debug): print("use item ", slot.item.name)

func drop(slot):
	if(debug): print("drop item", slot.item.name);
	inventory.removeItem(slot.item);

	if(slot.count == 0): #clear name, definition and actions
		clearDefnName();
		clearActions(slot);
