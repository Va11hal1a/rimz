extends Area2D
class_name PickUpInstance
var count = 1
var item


func init(item: ItemManager.Item, count = 1):
	
	self.item = item
	$Label.text = item.name
	$Sprite.texture = item.icon

	self.count = count
	if self.count > 1:
		$Label.text += " x" + String(count)
