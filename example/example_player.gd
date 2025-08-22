extends RigidCharacterBody3D


const SPEED: float = 3.0
const JUMP_HEIGHT: float = 1.1

@onready var body: Node3D = $Body
@onready var head: Node3D = $Body/Head


func _ready() -> void:
	super()
	mass = 60.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (body.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	if direction:
		target_velocity.x = SPEED * direction.x
		target_velocity.z = SPEED * direction.z
	else:
		if is_on_floor():
			linear_velocity.x *= 0.9
			linear_velocity.z *= 0.9
		target_velocity.x = 0.0
		target_velocity.z = 0.0
	
	move_and_slide()
	
	print(Vector3(linear_velocity.x, 0.0, linear_velocity.z).length())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		body.rotate_y(-deg_to_rad(event.relative.x * 0.08))
		head.rotate_x(-deg_to_rad(event.relative.y * 0.08))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event.is_action_pressed("ui_accept") and is_on_floor():
		apply_central_impulse(mass * sqrt(2.0 * get_gravity().length() * JUMP_HEIGHT) * up_direction)
