class_name WieldableGun
extends Wieldable

@export var full_auto: bool

@export var proj_spawner: ProjectileSpawner
@export var cpt_ammo: CptAmmo

@export var fire_timer: Timer
@export var reload_timer: Timer

func _use() -> void:
	if can_use():
		var rotation: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rotation)
		cpt_ammo.decrement_ammo()
		fire_timer.start()

func can_use() -> bool:
	# TEST: MAKE SURE THAT is_stopped() is the right function
	return cpt_ammo.has_ammo() and fire_timer.is_stopped()
