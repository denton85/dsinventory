# Tool is used to show the item mesh in editor
@tool
class_name ItemScene
extends RigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
#Reference the item resource here. Make sure your items have all fields filled out.
@export var item: Item

#TODO use quantity for picking up and dropping stacks of items
@export var quantity: int

var in_range = false

func _ready() -> void:
	mesh_instance_3d.mesh = item.mesh
	collision_shape_3d.shape = item.collision_shape

# in_range is not used, but could be for if an item can be interacted with besides getting picked up.
func _on_interact_able_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true

func _on_interact_able_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
