extends Node
class_name StateMachine

@export var current_state: State

var previous_state: State

var states: Array[State]

func _ready() -> void:
	for state: State in get_children():
		states.append(state)
		state.state_machine = self
		if current_state == null:
			current_state = state
		if current_state != state:
			state.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update_physics(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)

func change_state(new_state_name: Variant, additionnal_data: Variant = null) -> void:
	var state_name: String = str(new_state_name).to_lower()
	if current_state:
		current_state.exit()
	var state_found: bool = false
	for state in get_children():
		if state.name.to_lower() == state_name:
			state.process_mode = Node.PROCESS_MODE_INHERIT
			previous_state = current_state
			current_state = state
			state_found = true
		else:
			state.process_mode = Node.PROCESS_MODE_DISABLED
	if !state_found:
		printerr("STATE NOT FOUND : ", state_name)
	current_state.enter(additionnal_data)

func is_in_state(state: String) -> bool:
	return current_state.name.to_lower() == state.to_lower()

func not_in_state(state: String) -> bool:
	return !is_in_state(state)
