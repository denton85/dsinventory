class_name Player
extends CharacterBody3D

const WALK_SPEED = 4.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4
const SENSITIVITY = 0.001
var speed = WALK_SPEED

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var drop_location: Node3D = $Head/DropLocation
@onready var item_detect: ItemDetect = $Head/Camera3D/ItemDetect

@export var inventory_ui : InventoryUI
@export var inventory: Inventory

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	if Input.is_action_just_pressed("toggle_inventory"):
		if inventory_ui.visible == true:
			inventory_ui.toggle_inventory_ui(false)
		else:
			inventory_ui.toggle_inventory_ui(true)
			

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, (speed * 4) * delta)
			velocity.z = move_toward(velocity.z, 0, (speed * 4) * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		
	move_and_slide()
