class_name ItemDetect
extends Area3D

@export var inventory = Node3D

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
	#TODO fix this later in case of overlapping items
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
			next_focused_items.remove_at(index)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		if current_focused_item != null:
			#TODO Check if the inventory is full
			var size = inventory.inventory.size()
			for i in size:
				if inventory.inventory[i] == null:
					inventory.pickup_item(current_focused_item)
					current_focused_item.queue_free()
					break
