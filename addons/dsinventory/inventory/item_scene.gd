@tool
class_name ItemScene
extends RigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var item: Item

var in_range = false

func _ready() -> void:
	mesh_instance_3d.mesh = item.mesh

# in_range is not used, but could be for if an item can be interacted with besides getting picked up.
func _on_interact_able_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true


func _on_interact_able_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
