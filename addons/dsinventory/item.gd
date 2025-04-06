class_name Item
extends Resource

##Item Name
@export var name: String = ""
##Item Texture/Icon referenced here
@export var texture: Texture2D
##Item Mesh referenced here
@export var mesh: Mesh
##Create your own Collision Shape and reference it here
@export var collision_shape: Shape3D
