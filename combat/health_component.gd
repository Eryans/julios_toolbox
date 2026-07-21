extends Node
class_name HealthComponent

@export var max_hp: int

var current_hp: int

signal health_depleted

func _ready() -> void:
	current_hp = max_hp

func damage(value: int = 1) -> void:
	current_hp -= value
	check_if_dead()

func kill() -> void:
	current_hp = 0
	check_if_dead()

func check_if_dead() -> void:
	if current_hp <= 0:
		health_depleted.emit()
