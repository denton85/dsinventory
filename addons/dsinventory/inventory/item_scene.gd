# Tool is used to show the item mesh in editor. It should automatically update the mesh in editor when you switch out items.
@tool
class_name ItemScene
extends RigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

#Reference the item resource here. Make sure your items have all fields filled out.
@export var item: Item

func _ready() -> void:
	_update_item_display()

#TODO use quantity for picking up and dropping stacks of items
@export var quantity: int = 1

func setup(p_item, p_quantity):
	item = p_item
	quantity = p_quantity
	_update_item_display()
	
func _update_item_display() -> void:
	if item:
		if mesh_instance_3d and item.mesh:
			mesh_instance_3d.mesh = item.mesh
		if collision_shape_3d:
			var shape = item.mesh.create_convex_shape()
			collision_shape_3d.shape = shape
