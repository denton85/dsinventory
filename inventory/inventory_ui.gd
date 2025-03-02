extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var inventory: Inventory = $"../Inventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.update_inventory_ui.connect(update_slots)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_slots():
	var i = 0
	for slot in grid_container.get_children():
		if inventory.inventory[i] != null:
			slot.update(inventory.inventory[i])
		i = i + 1
