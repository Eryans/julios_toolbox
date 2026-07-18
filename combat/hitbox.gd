extends Area3D
class_name HitBox

signal hit

func activate() -> void:
	hit.emit()
	for area: Area3D in get_overlapping_areas():
		if area is Hurtbox && area.owner != owner:
			var data: AttackData = AttackData.new()
			data.hitbox = self
			data.from = owner
			area.took_hit.emit(data)

class AttackData:
	var hitbox: HitBox
	var from: Node3D
