class_name Inventory
extends Node

var inventory = []
@export var inventory_size = 12

signal update_inventory_ui

# Basic Item Scene
const ITEM_SCENE = preload("res://addons/dsinventory/inventory/item_scene.tscn")

func _ready() -> void:
	inventory.resize(inventory_size)

func add_to_inventory(item, index):
	inventory[index] = item
	update_inventory_ui.emit()
	
func remove_from_inventory(index):
	inventory[index] = null
	update_inventory_ui.emit()

func swap_two_slots(from_index, to_index):
	var slot1 = inventory[from_index]
	var slot2 = inventory[to_index]
	inventory[from_index] = slot2
	inventory[to_index] = slot1
	update_inventory_ui.emit()
	
func drop_item(index):
	if inventory[index] == null:
		return
	var dropped_item = ITEM_SCENE.instantiate()
	dropped_item.item = inventory[index]
	dropped_item.global_position = Global.playervar.drop_location.global_position
	Global.main.add_child(dropped_item)
	inventory[index] = null
	update_inventory_ui.emit()
	
func pickup_item(item_scene):
	for i in inventory.size():
		var index = i
		if inventory[index] != null:
			continue
		elif inventory[index] == null:
			add_to_inventory(item_scene.item, index)
			break
			

func use_item(index):
	pass
