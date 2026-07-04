extends Node

var debug_mode: bool = false

func _ready() -> void:
    await get_tree().physics_frame
    set_debug_node_visibility()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_mode"):
        toggle_debug_mode()

func set_debug_node_visibility() -> void:
    for node: Node in get_tree().get_nodes_in_group("debug"):
        node.visible = debug_mode

func toggle_debug_mode() -> void:
    debug_mode = !debug_mode
    set_debug_node_visibility()

func get_random_circle_point(radius: float) -> Vector3:
    var random_angle: float = randf() * TAU
    return Vector3(sin(random_angle), 0, cos(random_angle)) * radius

func play_sound_and_randomize_pitch(audio: AudioStreamPlayer, amount: float = .1) -> void:
    audio.pitch_scale = randf_range(1 - amount, 1 + amount)
    audio.play()

func create_node_and_add_to_child(new_node: Variant, to: Node) -> Variant:
    to.add_child(new_node)
    return new_node

func spawn_to_world(pck_scn_path: String, position: Vector3) -> Variant:
    var new_node: Node3D = create_node_and_add_to_child(load(pck_scn_path).instantiate(), get_tree().current_scene)
    new_node.global_position = position
    return new_node

func create_one_shot_timer(duration: float, callable: Callable) -> void:
    get_tree().create_timer(duration).connect("timeout", callable, CONNECT_ONE_SHOT)

func sin_wave(amplitude: float, pulse: float, time: float) -> float:
    return amplitude * sin(pulse * time)

func get_atan2_look_at(to_rotate:float ,to: Vector3, delta:float, force:float = 10 ) -> float:
    return lerp_angle(to_rotate,atan2(to.x,to.z),delta * force)