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

# Swapping to items in your inventory
func swap_two_slots(from_index, to_index):
	var slot1 = inventory[from_index]
	var slot2 = inventory[to_index]
	inventory[from_index] = slot2
	inventory[to_index] = slot1
	update_inventory_ui.emit()

# Drop an item from inventory and add it to the world
func drop_item(index, position):
	if inventory[index].item == null:
		return
	var dropped_item = ITEM_SCENE.instantiate()
	dropped_item.item = inventory[index].item
	dropped_item.global_position = position
	
	# Your main world node.
	DsGlobal.main.add_child(dropped_item)
	decrease_stack(index, 1)
	update_inventory_ui.emit()
	
# Pickup an Item and add it to inventory
func pickup_item(item: Item):
	for i in inventory.size():
		var slot = inventory[i]

		if slot.item != null and slot.item.name == item.name:
			if not is_slot_full(i):
				slot.quantity += 1
				update_inventory_ui.emit()
				return  # exit after success
			else:
				print("Slot full")
				continue

	for i in inventory.size():
		var slot = inventory[i]
		if slot.item == null:
			add_to_inventory(item.duplicate(), i)
			update_inventory_ui.emit()
			return
	

# Needs Functionality Below
func use_item(index):
	pass

# Increase an item quantity by a certain amount
func increase_stack(index, amount):
	inventory[index].quantity += amount
	
# Decrease an item quantity by a certain amount
func decrease_stack(index, amount):
	inventory[index].quantity -= amount
	if inventory[index].quantity <= 0:
		inventory[index].item = null
		update_inventory_ui.emit()

# Functionality to split a stack by a certain amount, either into another stack or into an empty slot.
func split_stack(from_index: int, to_index: int, amount: int):
	if inventory[to_index].item != null && inventory[to_index].item.name != inventory[from_index].item.name:
		return
	if inventory[to_index].item != null && inventory[to_index].item.name == inventory[from_index].item.name:
		#print(inventory[to_index].item)
		if is_slot_full(to_index):
			return
		check_add_to_stack(from_index, to_index, amount)
	elif inventory[to_index].item == null:
		check_add_to_stack(from_index, to_index, amount)
		

# Check if a slot should be swapped, or if the quantity should be increased if the items are the same.
func check_swap_or_increase(from_index: int, to_index: int):
	if inventory[from_index].item != null and inventory[to_index].item != null:
		if inventory[from_index].item.name != inventory[to_index].item.name:
			swap_two_slots(from_index, to_index)
		elif (inventory[to_index].quantity + inventory[from_index].quantity) > inventory[to_index].item.max_stack_size:
			var amount = inventory[to_index].item.max_stack_size - inventory[to_index].quantity
			increase_stack(to_index, amount)
			decrease_stack(from_index, amount)
			update_inventory_ui.emit()
		else:
			increase_stack(to_index, inventory[from_index].quantity)
			decrease_stack(from_index, inventory[from_index].quantity)
			update_inventory_ui.emit()
	else:
		swap_two_slots(from_index, to_index)
		
# Check how much to add to a stack from one to another.
func check_add_to_stack(from_index, to_index, amount: int):
	if is_slot_full(to_index): return
	var to = inventory[to_index]
	if inventory[from_index].item == null:
		return
	if to.item != null and inventory[from_index].item.name != inventory[to_index].item.name:
		return
	if to.item == null:
		add_to_inventory(inventory[from_index].item, to_index)
		inventory[to_index].quantity = amount
		decrease_stack(from_index, amount)
	elif amount + to.quantity > to.item.max_stack_size:
		var amount_to_add = to.item.max_stack_size - to.quantity
		increase_stack(to_index, amount_to_add)
		decrease_stack(from_index, amount_to_add)
	else:
		increase_stack(to_index, amount)
		decrease_stack(from_index, amount)
	update_inventory_ui.emit()

# Check if a slot is full.
func is_slot_full(index):
	if inventory[index].item == null:
		return false
	if inventory[index].quantity == inventory[index].item.max_stack_size:
		return true
	else:
		return false
