class_name WieldableGun
extends Wieldable

signal magazine_ejected(mag: Magazine)

## The weapon will continually fire only if full_auto==true
@export var full_auto: bool
## If true, can reload from mags, otherwise must round-reload
@export var mag_reloadable: bool

## The node at the tip of the barrel that spawns bullets.
@export var proj_spawner: ProjectileSpawner
## The component managing ammo and reloading.
@export var cpt_ammo: CptAmmo

## Cooldown until the gun can be fired again
@export var fire_timer: Timer
## Cooldown during reload in which the weapon cannot fire.
@export var reload_timer: Timer

func _start_use() -> void:
	if can_use():
		var rot: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rot)
		cpt_ammo.decrement_ammo()
		fire_timer.start()

func _continue_use() -> void:
	if can_use() and full_auto == true:
		var rot: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
		proj_spawner.spawn_projectile(rot)
		cpt_ammo.decrement_ammo()
		fire_timer.start()

## Return whether the weapon can fire, which is only true if there's ammo, and both the fire and
## reload timers have completed.
func can_use() -> bool:
	return cpt_ammo.has_ammo() and fire_timer.is_stopped() and reload_timer.is_stopped()

## Reload an individual round into the weapon
func round_reload() -> void:
	# check to make sure the weapon is neither still firing nor still reloading
	if not (reload_timer.is_stopped() and fire_timer.is_stopped()):
		return
	cpt_ammo.round_reload()
	reload_timer.start()

## Reload an entire mag into the weapon.
func mag_reload(mag: Magazine) -> void:
	# check to make sure the weapon is neither still firing nor still reloading
	if not (reload_timer.is_stopped() and fire_timer.is_stopped()):
		return
	cpt_ammo.mag_reload(mag)
	reload_timer.start()

"""Returns the old mag (so that it can be
## put in inventory o algo) and sets ammo equal to the ammount in the new mag"""

"""if mag.gun_type != gun_type:
		print("WARNING: Attempted to reload with incorrect type of ammo.  Should be ", ammo_type,
				" but is ", mag.ammo_type)
		return mag"""
