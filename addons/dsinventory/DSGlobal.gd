extends Node

#Global API
var inv = null
@export var ITEM_SCENE: PackedScene = load("res://addons/dsinventory/inventory/item_scene.tscn")

func get_item_at_index(index: int) -> Item:
	if inv[index].item != null:
		return inv[index].item
	else:
		push_error("No Item in this Slot - get_item_at_index(index)")
		return null

func get_item_and_quantity_at_index(index: int):
	if inv[index].item != null:
		return [inv[index].item, inv[index].quantity]
	else:
		push_error("No Item or Quantity in this Slot - get_item_and_quantity_at_index(index)")
		return null
		
	
func get_item_scene_path_at_index(index: int):
	if inv[index].item.item_scene_path:
		return inv[index].item.item_scene_path
	else:
		push_error("No Scene Path in this Slot - get_item_scene_path_at_index(index)")
		return null
		
func get_total_quantity_of_item(item_to_find: Item) -> int:
	var total := 0
	for i in inv:
		if i.item != null and i.item.name == item_to_find.name:
			total += i.quantity
	return total
	
func check_if_has_item(item_to_find: Item) -> bool:
	if item_to_find in inv:
		return true
	else:
		push_error("No Item in this Slot - check_if_has_item(item_to_find)")
		return false

func remove_quantity_of_item(item_to_find: Item, cost: int) -> void:
	var total: int = cost
	for i in Global.playervar.inventory.inventory.size():
		if inv[i - 1].item != null and inv[i - 1].item.name == item_to_find.name:
			if total >= inv[i - 1].quantity:
				total -= inv[i - 1].quantity
				Global.playervar.inventory.decrease_stack((i - 1), inv[i - 1].quantity, inv)
			else:
				Global.playervar.inventory.decrease_stack((i - 1), total, inv)
				break
		if total <= 0:
			return

func check_if_inventory_has_space(item_to_find: Item, quantity: int) -> bool:
	for i in inv:
		if i.item == null:
			return true
	for i in inv:
		if i.item.name == item_to_find.name and i.quantity + quantity < i.item.max_stack_size:
			return true
		else:
			continue
	return false

func check_partial_fill_at_index(item_to_find: Item, quantity: int, index) -> int:
	if inv[index].item.name == item_to_find.name and inv[index].quantity < inv[index].item.max_stack_size:
		var remainder: int = inv[index].item.max_stack_size - inv[index].quantity
		return remainder
	return 0
