class_name RigidCharacterBody3D
extends RigidBody3D


var target_velocity: Vector3 = Vector3.ZERO
var acceleration_magnitude: float = 10.0


func _ready() -> void:
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = 0.0
	
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true


func move_and_slide() -> void:
	if not target_velocity:
		return
	
	var move_magnitude: float = mass * acceleration_magnitude
	var move_force: Vector3 = move_magnitude * target_velocity.normalized()
	
	var drag_scale: float = linear_velocity.length() / target_velocity.length()
	var drag_force: Vector3 = move_magnitude * drag_scale * -linear_velocity.normalized()
	
	apply_force(move_force + drag_force)
