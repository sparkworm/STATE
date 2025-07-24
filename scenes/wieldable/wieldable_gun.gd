class_name WieldableGun
extends Wieldable

@export var proj_spawner: ProjectileSpawner
@export var cpt_ammo: CptAmmo

func _use() -> void:
	if cpt_ammo.has_ammo():
		var rotation: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rotation)
		cpt_ammo.decrement_ammo()
