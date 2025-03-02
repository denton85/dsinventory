class_name Inventory
extends Node

var inventory = []

signal update_inventory_ui

func _ready() -> void:
	inventory.resize(12)
	#inventory.fill(ItemSlot.new())

func add_to_inventory(item, index):
	inventory[index] = item
	update_inventory_ui.emit()
	
func remove_from_inventory(index):
	pass

func swap_two_slots(from_index, to_index):
	pass
	
func drop_item(index):
	pass
	
func pickup_item(item_scene):
	for i in inventory.size():
		var index = i
		if inventory[index] != null:
			print("Slot is full")
			continue
		elif inventory[index] == null:
			add_to_inventory(item_scene.item, index)
			print(inventory)
			print(index)
			break
			

func use_item(index):
	pass
