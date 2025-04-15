class_name ItemDetect
extends Area3D

## Set Your Inventory Node Here (*Not the InventoryUI Control Node*)
@export var inventory: Inventory

var current_focused_item: ItemScene = null
var next_focused_items: Array = []

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
		print(current_focused_item)
		print(next_focused_items)
		if current_focused_item == body:
			current_focused_item = null
			if next_focused_items.is_empty():
				return
			else:
				current_focused_item = next_focused_items[0]
				next_focused_items.remove_at(0)
		else:
			var index = next_focused_items.find(body)
			next_focused_items.remove_at(index)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup") and current_focused_item != null:
		var pickup_node = current_focused_item
		var item_to_pickup = pickup_node.item
		var slots = inventory.inventory
		var has_space = false
		
		for slot in slots:
			var slot_item = slot.item
			
			if slot_item == null:
				has_space = true
				break
			
			if slot_item.name == item_to_pickup.name and slot.quantity < slot_item.max_stack_size:
				has_space = true
				break
		
		if has_space:
			inventory.pickup_item(item_to_pickup)
			pickup_node.queue_free()
			current_focused_item = null
			
			if not next_focused_items.is_empty():
				current_focused_item = next_focused_items[0]
				next_focused_items.remove_at(0)
		else:
			print("Inventory full — cannot pick up item.")
