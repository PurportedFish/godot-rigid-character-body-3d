extends RigidCharacterBody3D


const SPEED: float = 5.0

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
		linear_damp = 0.0
		target_velocity.x = SPEED * direction.x
		target_velocity.z = SPEED * direction.z
	else:
		linear_damp = 10.0
		target_velocity.x = 0.0
		target_velocity.z = 0.0
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		body.rotate_y(-deg_to_rad(event.relative.x * 0.08))
		head.rotate_x(-deg_to_rad(event.relative.y * 0.08))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
