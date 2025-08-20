class_name RigidCharacterBody3D
extends RigidBody3D


@export var up_direction: Vector3 = Vector3.UP
@export var neck_height: float = 1.5
@export var knee_height: float = 0.5
@export var ceiling_min_angle: float = deg_to_rad(105.0)
@export var floor_max_angle: float = deg_to_rad(45.0)
@export var slide_on_slope: bool = false

var target_velocity: Vector3 = Vector3.ZERO
var acceleration_magnitude: float = 10.0

var _state: PhysicsDirectBodyState3D
var _is_on_ceiling: bool = false
var _is_on_floor: bool = false
var _is_on_wall: bool = false


func _ready() -> void:
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = 0.0
	
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	
	contact_monitor = true
	max_contacts_reported = 16


func move_and_slide() -> void:
	_detect_ceiling_floor_wall()
	
	if not target_velocity:
		return
	
	var move_magnitude: float = mass * acceleration_magnitude
	var move_force: Vector3 = move_magnitude * target_velocity.normalized()
	
	var drag_scale: float = linear_velocity.length() / target_velocity.length()
	var drag_force: Vector3 = move_magnitude * drag_scale * -Vector3(linear_velocity.x, 0.0, linear_velocity.z).normalized()
	
	apply_force(move_force + drag_force)


func _detect_ceiling_floor_wall() -> void:
	_state = PhysicsServer3D.body_get_direct_state(get_rid())
	
	_is_on_ceiling = false
	_is_on_floor = false
	_is_on_wall = false
	
	for i in _state.get_contact_count():
		var contact_position: Vector3 = to_local(_state.get_contact_collider_position(i))
		var normal: Vector3 = _state.get_contact_local_normal(i)
		var contact_angle: float = acos(normal.dot(up_direction))
		
		if (
			contact_position.y > knee_height 
			and contact_position.y < neck_height
			and contact_angle > floor_max_angle
			and contact_angle < ceiling_min_angle
		):
			_is_on_wall = true
			continue
		
		if (
			contact_position.y >= neck_height 
			and (
				contact_angle >= ceiling_min_angle 
				or is_equal_approx(contact_angle, ceiling_min_angle)
			)
		):
			_is_on_ceiling = true
			# TODO: Add ceiling behavior
			continue
		
		_is_on_floor = true
		
		if slide_on_slope:
			continue
		
		if contact_angle <= floor_max_angle or is_equal_approx(contact_angle, floor_max_angle):
			apply_central_force(-get_gravity().length() * mass * Vector3.DOWN.slide(normal))


func is_on_ceiling() -> bool:
	return _is_on_ceiling


func is_on_ceiling_only() -> bool:
	return _is_on_ceiling and not (_is_on_floor or _is_on_wall)


func is_on_floor() -> bool:
	return _is_on_floor


func is_on_floor_only() -> bool:
	return _is_on_floor and not (_is_on_ceiling or _is_on_wall)


func is_on_wall() -> bool:
	return _is_on_wall


func is_on_wall_only() -> bool:
	return _is_on_wall and not (_is_on_ceiling or _is_on_wall)
