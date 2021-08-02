extends Node2D
var count = 1;

func init(item: ItemManager.Item, count = 1):
    $Label.text = item.name;
    $Sprite.texture = item.icon;

    self.count = count;
    if(self.count > 1):
        $Label.text += " x"+String(count);