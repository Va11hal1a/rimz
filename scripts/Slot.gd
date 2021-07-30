extends Control

func init(item: ItemManager.Item, count):
	$NameLabel.text = item.name;
	$Icon.texture = item.icon;
	$CountLabel.text = String(count);
