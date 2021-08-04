class_name ItemManager


class Item:
	var icon = null
	var description = "empty"
	var name = "item"
	var actions = ["drop", "dropAll"]

	func _init(icon: Texture, description: String, name: String):
		self.icon = icon
		self.description = description
		self.name = name


class ItemEffects:
	extends Item
	var effects = {}

	func _init(icon: Texture, description: String, name: String, effects = {}).(
		icon, description, name
	):
		effects = effects

		actions.append("use")


class ItemUse:
	extends Item
	var instance = null

	func _init(icon: Texture, description: String, name: String, instance: PackedScene = null).(
		icon, description, name
	):
		if instance != null:
			self.instance = instance
		else:
			self.instance = load("res://prefabs/useItems/" + name + ".tscn")
		
		actions.append("equip")


class Slot:
	var item: Item
	var count = 0

	func _init(item: Item, count):
		self.item = item
		self.count = count


class Inventory:
	signal inventoryRefresh
	var slots = []

	func _init():
		Global.inventories.append(self)

	func findIdByName(name: String):
		var acc = 0
		for slot in slots:
			if slot.item.name == name:
				return acc
			acc += 1
		return -1

	func addItem(item: Item, count: int = 1):
		var id = findIdByName(item.name)
		if id == -1:
			slots.push_back(Slot.new(item, count))
		else:
			slots[id].count += count
		emit_signal("inventoryRefresh")

	func removeItem(item: Item, count = 1):
		var id = findIdByName(item.name)
		if id == -1:
			return false
		slots[id].count -= count
		if slots[id].count <= 0:
			slots.remove(id)
		emit_signal("inventoryRefresh")
