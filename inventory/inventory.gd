class_name Inventory
extends Node

var inventory = []

signal update_inventory_ui

func _ready() -> void:
	inventory.resize(4)
	inventory.fill(ItemSlot.new())

func add_to_inventory(item):
	pass
	
func remove_from_inventory(index):
	pass

func swap_two_slots(from_index, to_index):
	pass
	
func drop_item(index):
	pass
	
func pickup_item(item_scene):
	pass

func use_item(index):
	pass
