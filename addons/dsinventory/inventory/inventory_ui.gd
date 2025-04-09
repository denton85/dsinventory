@tool
class_name InventoryUI
extends Control

## Assign a Node3D to your player as a drop location, then set it here. This will be where the item spawns when dropping items from your inventory. Make sure the Node3D is in a sensible place, rotating relative to the player so the items don't get dropped behind them if possible.
@export var drop_location: Node3D

@onready var grid_container: GridContainer = %GridContainer
@onready var inventory: Inventory = $"../Inventory"
const SLOT = preload("res://addons/dsinventory/inventory/slot_ui.tscn")

var from_slot = null
var to_slot = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in (inventory.inventory_size):
		var slot = SLOT.instantiate()
		grid_container.add_child(slot)
		
	inventory.update_inventory_ui.connect(update_slots)
	
	var i = 0
	for slot in grid_container.get_children():
		slot.slot_index = i
		i = i + 1

func update_slots():
	var i = 0
	for slot in grid_container.get_children():
		if inventory.inventory[i].item != null:
			slot.update(inventory.inventory[i])
		else:
			slot.update(null)
		i = i + 1

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = !visible
		if visible == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
