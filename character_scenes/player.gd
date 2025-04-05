class_name Player
extends CharacterBody3D

const WALK_SPEED = 4.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4
const SENSITIVITY = 0.001
var speed = WALK_SPEED

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var inventory_ui: Control = $InventoryUI
@onready var inventory: Inventory = $Inventory
@onready var drop_location: Node3D = $Head/DropLocation

#var current_focused_item: ItemScene = null
#var next_focused_items: Array = []

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory_ui.parent = self
	Global.playervar = self

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		
	if Input.is_action_just_pressed("interact"):
		if inventory.current_focused_item != null:
			#TODO Check if the inventory is full
			var size = inventory.inventory.size()
			for i in size:
				if inventory.inventory[i] == null:
					inventory.pickup_item(inventory.current_focused_item)
					inventory.current_focused_item.queue_free()
					break
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
