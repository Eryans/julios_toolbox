extends Area3D
class_name HitBox

signal hit(data: AttackData)

func activate() -> void:
	var data: AttackData = AttackData.new()
	for area: Area3D in get_overlapping_areas():
		if area is Hurtbox && area.owner != owner:
			if area.is_invicible: return
			data.hitbox = self
			data.from = owner
			area.took_hit.emit(data)
	hit.emit(data)

class AttackData:
	var hitbox: HitBox
	var from: Node3D
