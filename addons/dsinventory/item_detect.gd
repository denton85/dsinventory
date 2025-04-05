class_name ItemDetect
extends Area3D

@export var inventory = Node3D

func _init() -> void:
	body_entered.connect(_on_item_detect_body_entered)
	body_exited.connect(_on_item_detect_body_exited)
	

func _on_item_detect_body_entered(body: Node3D) -> void:
	print("Entered")
	if body is ItemScene:
		if inventory.current_focused_item != null:
			inventory.next_focused_items.append(body)
		else:
			inventory.current_focused_item = body

func _on_item_detect_body_exited(body: Node3D) -> void:
	#TODO fix this later in case of overlapping items
	if body is ItemScene:
		if inventory.current_focused_item == body:
			inventory.current_focused_item = null
			if inventory.next_focused_items.is_empty():
				return
			else:
				inventory.current_focused_item = inventory.next_focused_items[0]
				inventory.next_focused_items.remove_at(0)
		else:
			var index = inventory.next_focused_items.find(body)
			inventory.next_focused_items.remove_at(index)
