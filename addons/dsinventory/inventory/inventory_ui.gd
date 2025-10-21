@tool
class_name InventoryUI
extends Control

## Assign a Node3D to your player as a drop location, then set it here. This will be where the item spawns when dropping items from your inventory. Make sure the Node3D is in a sensible place, rotating relative to the player so the items don't get dropped behind them if possible.
@export var drop_location: Node3D

@onready var grid_container: GridContainer = %GridContainer
@onready var secondary_gridcontainer: GridContainer = %SecondaryGridcontainer
@onready var crafting_grid_container: GridContainer = %CraftingGridContainer

@onready var inventory: Inventory = $"../Inventory"

const SLOT = preload("res://addons/dsinventory/inventory/slot_ui.tscn")

var from_slot = null
var to_slot = null
var from_inv = null
var to_inv = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in (inventory.inventory_size):
		var slot = SLOT.instantiate()
		slot.inventory_ui = self
		grid_container.add_child(slot)
		
	inventory.update_inventory_ui.connect(update_slots)
	
	var i = 0
	for slot in grid_container.get_children():
		slot.slot_index = i
		i = i + 1
		
func update_slots():
	var i = 0
	for slot in grid_container.get_children():
		if inventory.inventory[i].item != null:
			slot.update(inventory.inventory[i])
		else:
			slot.update(null)
		i = i + 1
	
	#if Global.playervar.current_outside_inventory != null:
		#update_secondary_slots()
	#else:
		#clear_secondary_slots()

func update_secondary_slots():
	if Global.playervar.current_outside_inventory == null:
		return
	for i in Global.playervar.current_outside_inventory.size():
		var slot = secondary_gridcontainer.get_child(i)
		if slot == null:
			return
		if Global.playervar.current_outside_inventory[i].item != null:
			slot.update(Global.playervar.current_outside_inventory[i])
		else:
			slot.update(null)

func clear_secondary_slots():
	for slot in secondary_gridcontainer.get_children():
		slot.queue_free()

func add_new_inventory_slots():
	for i in Global.playervar.current_outside_inventory:
		var slot = SLOT.instantiate()
		slot.inventory_ui = self
		slot.secondary = true
		secondary_gridcontainer.add_child(slot)
	
	var j = 0
	for slot in secondary_gridcontainer.get_children():
		slot.slot_index = j
		j = j + 1

func toggle_inventory_ui(value: bool):
	visible = value
	if visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
