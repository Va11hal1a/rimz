extends Node

onready var joystick = get_node("/root/Scene/CanvasLayer/Analog")
onready var useJoystick = get_node("/root/Scene/CanvasLayer/Use")

var players = []
var inventories = []

var items = [
	ItemManager.Item.new(preload("res://images/tiles.png"), "test item", "Item"),
	ItemManager.Item.new(preload("res://images/tiles.png"), "test item", "Item1"),
	ItemManager.ItemUse.new(preload("res://images/icons.tres"), "test item", "Pistol")
]


func _ready():
	randomize()
