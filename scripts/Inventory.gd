extends Control

onready var inventory = ItemManager.Inventory.new()

export var gridContainerPath: NodePath
onready var gridContainer = get_node(gridContainerPath)

export var slotInstance: PackedScene
var selectedSlot setget setSlot

onready var nameLabel = $Panel/Container/Name
onready var descriptionLabel = $Panel/Container/Description

onready var pickUpScene = preload("res://prefabs/PickUp.tscn")
onready var attachedPlayerId = 0

onready var tween = $Tween

onready var pickup = get_parent().get_node("Pickup")

var debug = false


func clearActions(slot):
	for action in slot.item.actions:
		for child in $Panel/Container.get_children():
			if child is Button:
				child.queue_free()


func clearDefnName():
	nameLabel.text = ""
	descriptionLabel.text = ""


func setSlot(slot):
	if selectedSlot == slot:
		return

	clearActions(slot)

	nameLabel.text = slot.item.name
	descriptionLabel.text = slot.item.description

	for action in slot.item.actions:
		var button = preload("res://prefabs/ActionButton.tscn").instance()
		button.text = action
		button.connect("button_up", self, action, [slot])
		$Panel/Container.add_child(button)


func _ready():
	if attachedPlayerId > Global.players.size() || attachedPlayerId == -1:  #in case if player is not initialized or attached
		get_parent().get_node("InventoryButton").visible = false
		return

	inventory.connect("inventoryRefresh", self, "refresh")
	test()

	Global.players[attachedPlayerId].get_node("PickUpArea").connect(
		"area_entered", self, "itemEntered"
	)
	Global.players[attachedPlayerId].get_node("PickUpArea").connect(
		"area_exited", self, "itemExited"
	)

	pickup.connect("button_up", self, "pickupClick")


func refresh():
	for child in gridContainer.get_children():
		child.queue_free()

	var id = 0

	for slot in inventory.slots:
		var temp = slotInstance.instance()
		temp.init(slot.item, slot.count)
		temp.connect("button_up", self, "slot_select", [id])
		gridContainer.add_child(temp)

		id += 1


func test():
	for i in range(0, 10):
		inventory.addItem(Global.items[0])
	inventory.addItem(Global.items[1])
	inventory.addItem(Global.items[2])


func slot_select(id):
	print(inventory.slots)
	setSlot(inventory.slots[id])

# SLOT ACTIONS

func use(slot):
	if debug:
		print("use item ", slot.item.name)


func drop(slot, count = 1):
	var pickUpInstance = pickUpScene.instance()
	pickUpInstance.global_position = Global.players[attachedPlayerId].global_position
	pickUpInstance.init(slot.item, count)
	get_parent().get_parent().add_child(pickUpInstance)
	dropItemAnimation(pickUpInstance)

	if debug:
		print("drop item", slot.item.name)
	inventory.removeItem(slot.item, count)

	if slot.count == 0:  #clear name, definition and actions
		clearDefnName()
		clearActions(slot)


func dropAll(slot):
	drop(slot, slot.count)


func dropItemAnimation(instance):
	var xDeviation = rand_range(-1, 1) * 20.0
	var yDeviation = rand_range(0, 1) * 20.0

	tween.interpolate_property(
		instance,
		"position:x",
		instance.position.x,
		instance.position.x + xDeviation,
		0.5,
		tween.TRANS_CUBIC
	)

	tween.interpolate_property(
		instance,
		"position:y",
		instance.position.y,
		instance.position.y - yDeviation,
		0.5,
		tween.TRANS_CUBIC
	)

	tween.start()


func equip(slot):
	Global.players[attachedPlayerId].setUse(slot.item)

# PICK UP
var enteredList = []


func itemEntered(item):
	if item is PickUpInstance:
		enteredList.append(item)
		refreshPickup()


func itemExited(item):
	enteredList.erase(item)
	refreshPickup()


func refreshPickup():
	pickup.visible = ! (enteredList.size() == 0)


func pickupClick():
	inventory.addItem(enteredList[-1].item, enteredList[-1].count)
	enteredList.remove(-1)
	enteredList[-1].queue_free()
