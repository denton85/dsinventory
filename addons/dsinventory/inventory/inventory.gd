class_name Inventory
extends Node

var inventory: Array[ItemSlot] = []

## Assign your inventory size here. This is how many slots there will be.
@export var inventory_size = 12

signal update_inventory_ui

# Basic Item Scene
const ITEM_SCENE = preload("res://addons/dsinventory/inventory/item_scene.tscn")

func _ready() -> void:
	inventory.resize(inventory_size)
	for i in inventory.size():
		var index = i - 1
		inventory[i] = ItemSlot.new()

func add_to_inventory(item: Item, index):
	inventory[index].item = item
	inventory[index].quantity += 1
	update_inventory_ui.emit()
	
func remove_from_inventory(index):
	inventory[index].item = null
	inventory[index].quantity = 0
	update_inventory_ui.emit()

func check_swap_or_increase(from_index: int, to_index: int):
	if inventory[from_index].item != null and inventory[to_index].item != null:
		if inventory[from_index].item != inventory[to_index].item:
			swap_two_slots(from_index, to_index)
		elif (inventory[to_index].quantity + inventory[from_index].quantity) > inventory[to_index].item.max_stack_size:
			swap_two_slots(from_index, to_index)
		else:
			increase_stack(to_index, inventory[from_index].quantity)
			decrease_stack(from_index, inventory[from_index].quantity)
			update_inventory_ui.emit()
	else:
		swap_two_slots(from_index, to_index)

func swap_two_slots(from_index, to_index):
	var slot1 = inventory[from_index]
	var slot2 = inventory[to_index]
	inventory[from_index] = slot2
	inventory[to_index] = slot1
	update_inventory_ui.emit()
	
func drop_item(index, position):
	if inventory[index].item == null:
		return
	var dropped_item = ITEM_SCENE.instantiate()
	dropped_item.item = inventory[index].item
	dropped_item.global_position = position
	
	DsGlobal.main.add_child(dropped_item)
	decrease_stack(index, 1)
	update_inventory_ui.emit()
	
func pickup_item(item: Item):
	for i in inventory.size():
		var slot = inventory[i]

		if slot.item != null and slot.item.name == item.name:
			if not is_slot_full(i):
				slot.quantity += 1
				print("Added to stack")
				update_inventory_ui.emit()
				return  # exit after success
			else:
				print("Slot full")
				continue

	for i in inventory.size():
		var slot = inventory[i]
		if slot.item == null:
			add_to_inventory(item.duplicate(), i)
			print("Added to null slot")
			update_inventory_ui.emit()
			return
	
	print("Inventory full — item could not be added.")

# Needs Functionality Below
func use_item(index):
	pass

func increase_stack(index, amount):
	inventory[index].quantity += amount
	
func decrease_stack(index, amount):
	inventory[index].quantity -= amount
	if inventory[index].quantity <= 0:
		inventory[index].item = null
		update_inventory_ui.emit()

func is_slot_full(index):
	if inventory[index].quantity == inventory[index].item.max_stack_size:
		return true
	else:
		return false
