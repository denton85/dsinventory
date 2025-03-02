extends Panel

@onready var item_display: Sprite2D = $ItemDisplay
@onready var item_name: Label = $ItemName

func update(item: Item):
	if item == null:
		return
	item_display.texture = item.texture
	item_name.text = item.name
