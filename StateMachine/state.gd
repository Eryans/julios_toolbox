@warning_ignore_start("unused_parameter")
extends Node
class_name State

var state_machine: StateMachine

func enter(additionnal_data: Variant) -> void:
    pass
func input(event: InputEvent) -> void:
    pass

func update_physics(delta: float) -> void:
    pass

func exit() -> void:
    pass

func transition_to(new_state_name: Variant):
    state_machine.change_state(new_state_name)

func is_in_state(state: String) -> bool:
    return state_machine.is_in_state(state)

func not_in_state(state: String) -> bool:
    return !state_machine.is_in_state(state)
