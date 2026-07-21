extends Area3D
class_name Hurtbox

@export var has_invicibility_after_hit: bool = false
@export var invincibility_time: float = 2

@onready var impact: Sprite3D = $Impact

var is_invicible: bool = false

signal took_hit(from: HitBox.AttackData)

func _ready() -> void:
    took_hit.connect(_on_took_hit)
    impact.visible = false

func _on_took_hit(_from: HitBox.AttackData) -> void:
    if has_invicibility_after_hit:
        is_invicible = true
        Utils.create_one_shot_timer(invincibility_time, func(): is_invicible = false);
    animate_impact()

func animate_impact() -> void:
    impact.visible = true
    impact.scale = Vector3.ONE * .1
    var tw: Tween = create_tween()
    tw.tween_property(impact, "scale", Vector3.ONE, .25)
    await tw.finished
    impact.visible = false