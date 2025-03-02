class_name ItemScene
extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var item: Item

var in_range = false

func _ready() -> void:
	mesh_instance_3d.mesh = item.mesh


func _on_interact_able_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true


func _on_interact_able_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
