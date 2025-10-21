extends Node3D

#This will reference your main node, for adding items to the scene tree. This can be changed if you have a better way of doing it.
func _ready() -> void:
	Global.main = self
