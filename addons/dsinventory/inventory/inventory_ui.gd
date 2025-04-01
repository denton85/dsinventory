class_name InventoryUI
extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var inventory: Inventory = $"../Inventory"

var from_slot = null
var to_slot = null
var parent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.update_inventory_ui.connect(update_slots)
	var i = 0
	for slot in grid_container.get_children():
		slot.slot_index = i
		i = i + 1

func update_slots():
	var i = 0
	for slot in grid_container.get_children():
		if inventory.inventory[i] != null:
			slot.update(inventory.inventory[i])
		else:
			slot.update(null)
		i = i + 1
