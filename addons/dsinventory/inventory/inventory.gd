class_name Inventory
extends Node

var inventory: Array[ItemSlot] = []

## Assign your inventory size here. This is how many slots there will be.
@export var inventory_size = 12

var active_item_slot: int = 1000

signal update_inventory_ui
signal active_item_changed

# Basic Item Scene

func _ready() -> void:
	inventory.resize(inventory_size)
	DsGlobal.inv = inventory
	for i in inventory.size():
		var index = i - 1
		inventory[i] = ItemSlot.new()

func add_to_inventory(item: Item, index, quantity, inv):
	inv[index].item = item
	inv[index].quantity += quantity
	update_inventory_ui.emit()
	
func remove_from_inventory(index, inv):
	inv[index].item = null
	inv[index].quantity = 0
	update_inventory_ui.emit()

# Drop an item from inventory and add it to the world
func drop_item(index, position, inv, parent):
	if inv[index].item == null:
		return
	var dropped_item
	if DsGlobal.ITEM_SCENE.can_instantiate():
		dropped_item = DsGlobal.ITEM_SCENE.instantiate()
	
	parent.add_child(dropped_item)
	dropped_item.global_position = position
	dropped_item.setup(inv[index].item, 1)  # Pass in item + quantity
	#
	if check_if_active_item(index):
		active_item_changed.emit()
	## Your main world node.
	decrease_stack(index, 1, inv)
	update_inventory_ui.emit()

func drop_full_stack(index, position, inv, parent):
	if inv[index].item == null:
		return
	if check_if_active_item(index):
		active_item_changed.emit()
	var dropped_item = DsGlobal.ITEM_SCENE.instantiate()
	dropped_item.item = inv[index].item
	dropped_item.quantity = inv[index].quantity
	dropped_item.global_position = position
	
	# Your main world node.
	parent.add_child(dropped_item)
	#decrease_stack(index, 1)
	remove_from_inventory(index, inv)
	update_inventory_ui.emit()
	
# Pickup an Item and add it to inventory
func pickup_item(item: Item, quantity):
	for i in inventory.size():
		var slot = inventory[i]

		if slot.item != null and slot.item.name == item.name:
			if not is_slot_full(i, inventory):
				if (slot.quantity + quantity) > slot.item.max_stack_size:
					var space = slot.item.max_stack_size - slot.quantity
					slot.quantity += space
					update_inventory_ui.emit()
					var remaining = quantity - space
					pickup_item(item, remaining)
					return
				slot.quantity += quantity
				update_inventory_ui.emit()
				return  # exit after success
			else:
				#print("Slot full")
				continue

	for i in inventory.size():
		var slot = inventory[i]
		if slot.item == null:
			add_to_inventory(item.duplicate(), i, quantity, inventory)
			update_inventory_ui.emit()
			return
	

# Needs Functionality Below
func use_item(index):
	pass

# Increase an item quantity by a certain amount
func increase_stack(index, amount, inv):
	inv[index].quantity += amount
	update_inventory_ui.emit()
	
# Decrease an item quantity by a certain amount
func decrease_stack(index, amount, inv):
	inv[index].quantity -= amount
	if inv[index].quantity <= 0:
		inv[index].item = null
	update_inventory_ui.emit()

# Functionality to split a stack by a certain amount, either into another stack or into an empty slot.
func split_stack(from_index: int, to_index: int, amount: int, from_inv, to_inv):
	if to_inv[to_index].item != null && to_inv[to_index].item.name != from_inv[from_index].item.name:
		return
	if to_inv[to_index].item != null && to_inv[to_index].item.name == from_inv[from_index].item.name:
		if is_slot_full(to_index, to_inv):
			return
		check_add_to_stack(from_index, to_index, amount, from_inv, to_inv)
	elif inventory[to_index].item == null:
		check_add_to_stack(from_index, to_index, amount, from_inv, to_inv)
		

# Check if a slot should be swapped, or if the quantity should be increased if the items are the same.
func check_swap_or_increase(from_index: int, to_index: int, from_inv, to_inv):
	if from_inv[from_index].item != null and to_inv[to_index].item != null:
		if from_inv[from_index].item.name != to_inv[to_index].item.name:
			swap_two_slots(from_index, to_index, from_inv, to_inv)
		elif (to_inv[to_index].quantity + from_inv[from_index].quantity) > to_inv[to_index].item.max_stack_size:
			var amount = to_inv[to_index].item.max_stack_size - to_inv[to_index].quantity
			increase_stack(to_index, amount, to_inv)
			decrease_stack(from_index, amount, from_inv)
			update_inventory_ui.emit()
		else:
			increase_stack(to_index, from_inv[from_index].quantity, to_inv)
			decrease_stack(from_index, from_inv[from_index].quantity, from_inv)
			update_inventory_ui.emit()
	else:
		swap_two_slots(from_index, to_index, from_inv, to_inv)
		
# Check how much to add to a stack from one to another.
func check_add_to_stack(from_index, to_index, amount: int, from_inv, to_inv):
	if is_slot_full(to_index, to_inv): return
	var to = to_inv[to_index]
	if from_inv[from_index].item == null:
		return
	if to.item != null and from_inv[from_index].item.name != to_inv[to_index].item.name:
		return
	if to.item == null:
		add_to_inventory(from_inv[from_index].item, to_index, amount, to_inv)
		to_inv[to_index].quantity = amount
		decrease_stack(from_index, amount, from_inv)
	elif amount + to.quantity > to.item.max_stack_size:
		var amount_to_add = to.item.max_stack_size - to.quantity
		increase_stack(to_index, amount_to_add, to_inv)
		decrease_stack(from_index, amount_to_add, from_inv)
	else:
		increase_stack(to_index, amount, to_inv)
		decrease_stack(from_index, amount, from_inv)
	update_inventory_ui.emit()

# Check if a slot is full.
func is_slot_full(index, inv):
	if inv[index].item == null:
		return false
	if inv[index].quantity == inv[index].item.max_stack_size:
		return true
	else:
		return false

func check_if_active_item(index):
	if index == active_item_slot:
		return true

func swap_two_slots(from_index, to_index, from_inv, to_inv):
	var slot1item = from_inv[from_index].item
	var slot1qty = from_inv[from_index].quantity
	
	var slot2item = to_inv[to_index].item
	var slot2qty = to_inv[to_index].quantity
	
	from_inv[from_index].item = slot2item
	from_inv[from_index].quantity = slot2qty
	
	to_inv[to_index].item = slot1item
	to_inv[to_index].quantity = slot1qty
	
	update_inventory_ui.emit()
	if from_inv != inventory and to_inv != inventory:
		return
	if check_if_active_item(from_index):
		active_item_slot = 1000
		active_item_changed.emit()
	elif check_if_active_item(to_index):
		if to_inv == inventory:
			active_item_slot = 1000
			active_item_changed.emit()

func sync_outside_inventory(inv):
	update_inventory_ui.emit()
