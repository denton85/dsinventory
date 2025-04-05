extends TextureRect

@onready var item_name: Label = $ItemName
@onready var inventory_ui: InventoryUI = $"../../../.."

var slot_index: int
var hovering = false
var menu_hovering = false

func _ready():
	update(null)

func update(item: Item):
	if item == null:
		texture = null
		item_name.text = ""
		return
	item_name.text = ""
	texture = item.texture
	item_name.text = item.name

func _on_mouse_entered() -> void:
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop_item") and hovering == true:
		drop_hovered_item()
		
	if Input.is_action_just_pressed("right_click") and hovering == true:
		menu_hovering = true
		%MenuPanel.visible = true
	
	if Input.is_action_just_pressed("left_click") and hovering == true:
		inventory_ui.from_slot = slot_index
	if Input.is_action_just_released("left_click") and hovering == true:
		inventory_ui.to_slot = slot_index
		
		if inventory_ui.from_slot != null and inventory_ui.to_slot != null:
			inventory_ui.inventory.swap_two_slots(inventory_ui.from_slot, inventory_ui.to_slot)
		
		inventory_ui.from_slot = null
		inventory_ui.to_slot = null
	
	if menu_hovering == false:
		%MenuPanel.visible = false

func _on_focus_entered() -> void:
	hovering = true

func _on_focus_exited() -> void:
	hovering = false

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(32.0, 32.0)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	return preview_texture.texture
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D

func _drop_data(at_position: Vector2, data: Variant) -> void:
	pass


func _on_drop_pressed() -> void:
	%MenuPanel.visible = !%MenuPanel.visible
	drop_hovered_item()

func _on_menu_panel_mouse_exited() -> void:
	menu_hovering = false

func drop_hovered_item():
	inventory_ui.inventory.drop_item(slot_index, inventory_ui.drop_location.global_position)
