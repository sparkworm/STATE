class_name WieldableGun
extends Wieldable

signal magazine_ejected(mag: Magazine)

@export var ID: Globals.Weapons
## The weapon will continually fire only if full_auto==true
@export var full_auto: bool
## If true, can reload from mags, otherwise must round-reload
@export var mag_reloadable: bool

@export var proj_spawner: ProjectileSpawner
@export var cpt_ammo: CptAmmo

@export var fire_timer: Timer
@export var reload_timer: Timer

func _start_use() -> void:
	if can_use():
		var rotation: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rotation)
		cpt_ammo.decrement_ammo()
		fire_timer.start()

func _continue_use() -> void:
	if can_use() and full_auto == true:
		var rotation: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rotation)
		cpt_ammo.decrement_ammo()
		fire_timer.start()

func can_use() -> bool:
	# TEST: MAKE SURE THAT is_stopped() is the right function
	return cpt_ammo.has_ammo() and fire_timer.is_stopped()


func round_reload() -> void:
	cpt_ammo.round_reload()

func mag_reload(mag: Magazine) -> void:
	cpt_ammo.mag_reload(mag)

"""Returns the old mag (so that it can be
## put in inventory o algo) and sets ammo equal to the ammount in the new mag"""

"""if mag.gun_type != gun_type:
		print("WARNING: Attempted to reload with incorrect type of ammo.  Should be ", ammo_type,
				" but is ", mag.ammo_type)
		return mag"""
