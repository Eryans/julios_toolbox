extends Node
class_name HealthComponent

@export var max_hp: int
@export var hurtbox: Hurtbox

var current_hp: int

signal health_depleted

func _ready() -> void:
    current_hp = max_hp
    if hurtbox:
        hurtbox.took_hit.connect(_on_took_hit)

func _on_took_hit(_data: HitBox.AttackData) -> void:
    current_hp -= 1
    if current_hp <= 0:
        health_depleted.emit()
        hurtbox.took_hit.disconnect(_on_took_hit)