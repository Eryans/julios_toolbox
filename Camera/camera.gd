extends SpringArm3D
class_name CameraControl

@export var target: Node3D
@export var target_offset: Vector3
@export var base_h_offset: float:
	set(value):
		base_h_offset = value
		if camera != null:
			camera.h_offset = value
@export var base_v_offset: float:
	set(value):
		base_v_offset = value
		if camera != null:
			camera.v_offset = value
@export var speed: float = 10
@export var rotation_speed_v: float = .25
@export var rotation_speed_h: float = .5
@export var inverse_h_axis: bool = false
@export var inverse_v_axis: bool = false

@onready var camera: Camera3D = $Camera3D
@onready var target_raycast: RayCast3D = $TargetRayCast3D
# @onready var _camera_input_dir: Vector2 = Vector2(rotation.y, rotation.x)
@onready var default_fov_value: float = camera.fov

var fov_tween: Tween

func _ready() -> void:
	camera.h_offset = base_h_offset
	camera.v_offset = base_v_offset
	if is_instance_valid(target):
		target_raycast.add_exception(target)

func _physics_process(delta: float) -> void:
	lerp_to_target(delta)
	# rotate_camera(delta)

func lerp_to_target(delta: float) -> void:
	if is_instance_valid(target):
		global_position = global_position.lerp(target.global_position + target_offset, delta * speed)
		target_raycast.target_position.z = - camera.global_position.distance_to(target.global_position)

# func rotate_camera(delta: float) -> void:
# 	var inputs: Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
# 	if inputs != Vector2.ZERO:
# 		_camera_input_dir.x += inputs.x * (delta * rotation_speed_h) * (-1. if inverse_h_axis else 1.)
# 		_camera_input_dir.y += inputs.y * (delta * rotation_speed_v) * (-1. if inverse_v_axis else 1.)
# 		_camera_input_dir.y = clamp(_camera_input_dir.y, -PI / 3, 0)

# 		basis = Basis()
# 		rotate_object_local(Vector3.UP, (_camera_input_dir.x))
# 		rotate_object_local(Vector3.RIGHT, (_camera_input_dir.y))

func shoot_ray() -> Dictionary:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_length: float = 1000
	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 8
	return space.intersect_ray(ray_query)

func get_mouse_position_in_3D() -> Vector3:
	var ray: Dictionary = shoot_ray()
	if !ray.is_empty():
		return ray["position"]
	return Vector3.ZERO

func screen_shake(strenght: float = .25, duration: float = 1) -> void:
	var tw: Tween = get_tree().create_tween()

	var apply_shake = func(delay: float) -> void:
		var x_offset = randf_range(-1, 1)
		var y_offset = randf_range(-1, 1)
		var movement = Vector2(x_offset, y_offset) * strenght * delay
		camera.h_offset = base_h_offset + movement.x
		camera.v_offset = base_v_offset + movement.y
	tw.tween_method(apply_shake, 1, 0, duration)

func tween_fov(value: float, duration: float = 1) -> void:
	if fov_tween:
		fov_tween.kill()
	fov_tween = create_tween()
	fov_tween.tween_property(camera, "fov", value, duration)

func set_camera_mode(camera_data: CameraData) -> void:
	target = camera_data.target
	base_h_offset = camera_data.h_offset
	base_v_offset = camera_data.v_offset
	spring_length = camera_data.spring_length
	speed = camera_data.speed


class CameraData:
	var target: Node3D
	var h_offset: float = 0
	var v_offset: float = 0
	var spring_length: float = 10
	var speed: float = 10
