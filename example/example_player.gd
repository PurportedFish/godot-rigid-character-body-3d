extends RigidCharacterBody3D


const SPEED: float = 5.0


func _ready() -> void:
	super()
	mass = 60.0


func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	if direction:
		linear_damp = 0.0
		target_velocity.x = SPEED * direction.x
		target_velocity.z = SPEED * direction.z
	else:
		linear_damp = 10.0
		target_velocity.x = 0.0
		target_velocity.z = 0.0
	
	print(direction.z)
	
	move_and_slide()
