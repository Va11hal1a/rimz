class_name ItemManager

class Item:
	var icon = null;
	var description = "empty";
	var name = "item"
	var actions = ["drop","dropAll"]
	func _init(icon:Texture,description:String, name: String):
		self.icon = icon;
		self.description = description;
		self.name = name;
class ItemEffects extends Item:
	var effects = {}
	func _init(icon:Texture,description:String,name: String,effects = {}).(icon,description,name):
		effects = effects;

		actions.append("use")
class ItemUse extends Item:
	var instance = null
	func _init(icon:Texture,description:String,name: String,istance).(icon,description, name):
		self.instance = instance;

		actions.append("equip")
	func do():
		print("use " + self.name);

class Slot:
	var item: Item;
	var count = 0;
	func _init(item: Item, count):
		self.item = item;
		self.count = count;

class Inventory:
	signal inventoryRefresh;
	var slots = []
	func findIdByName(name: String):
		var acc = 0;
		for slot in slots:
			if(slot.item.name == name):
				return acc;
			acc+=1;
		return -1;
	func addItem(item: Item):
		var id = findIdByName(item.name);
		if(id == -1):
			slots.push_back(Slot.new(item,1));
		else:
			slots[id].count+=1;
		emit_signal("inventoryRefresh");
	func removeItem(item: Item, count = 1):
		var id = findIdByName(item.name);
		if(id == -1):
			return false;
		slots[id].count-=count;
		if(slots[id].count <= 0):
			slots.remove(id);
		emit_signal("inventoryRefresh");

	
