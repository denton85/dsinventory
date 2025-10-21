class_name ItemDetect
extends Area3D

## Set Your Inventory Node Here (*Not the InventoryUI Control Node*)
@export var inventory: Inventory

var current_focused_item: ItemScene = null
var current_focused_connection: Node3D = null
var current_focused_interactable: Node3D = null
var next_focused_items: Array = []
var next_focused_connections: Array = []
var next_focused_interactables: Array = []

func _init() -> void:
	body_entered.connect(_on_item_detect_body_entered)
	body_exited.connect(_on_item_detect_body_exited)
	
func _on_item_detect_body_entered(body: Node3D) -> void:
	if body is ItemScene:
		if current_focused_item != null:
			next_focused_items.append(body)
		else:
			current_focused_item = body

func _on_item_detect_body_exited(body: Node3D) -> void:
	#TODO fix this later in case of overlapping items. (MIGHT ACTUALLY WORK FINE ALREADY?)
	if body is ItemScene:
		if current_focused_item == body:
			current_focused_item = null
			if next_focused_items.is_empty():
				return
			else:
				current_focused_item = next_focused_items[0]
				next_focused_items.remove_at(0)
		else:
			var index = next_focused_items.find(body)
			if index > -1:
				next_focused_items.remove_at(index)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup") and current_focused_item != null:
		var pickup_node = current_focused_item
		var item_to_pickup = pickup_node.item
		var quantity = pickup_node.quantity

		if DsGlobal.check_if_inventory_has_space(item_to_pickup, quantity, inventory.inventory):
			pass
			inventory.pickup_item(item_to_pickup, quantity)
			pickup_node.queue_free()
			remove_pickup_node()
			return
		for i in inventory.inventory.size():
			var partial: int = DsGlobal.check_partial_fill_at_index(item_to_pickup, quantity, i, inventory.inventory)
			if partial > 0:
			#inventory.add_to_inventory()
				inventory.increase_stack(i, partial, inventory.inventory)
				pickup_node.quantity -= partial
				if pickup_node.quantity <= 0:
					pickup_node.queue_free()
				remove_pickup_node()
		#else:
			#print("Inventory full — cannot pick up item.")

func remove_pickup_node() -> void:
	current_focused_item = null

	if not next_focused_items.is_empty():
		current_focused_item = next_focused_items[0]
		next_focused_items.remove_at(0)
