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

## Particle emitter for muzzle flash
@export var fire_particles_scene: PackedScene \
		= preload("res://scenes/effects/fire_particles.tscn")

@onready var projectile_spawner: ProjectileSpawner = $ProjectileSpawner

func _start_use() -> void:
	if can_use():
		fire()

func _continue_use() -> void:
	if can_use() and full_auto == true:
		fire()

## Makes WieldableGun fire its projectile.  Should only be called if can_use() is true
func fire() -> void:
	# spawn projectile
	var rot: Vector2 = Vector2.from_angle(get_global_transform().get_rotation())
	proj_spawner.spawn_projectile(rot)
	# consume ammo
	cpt_ammo.decrement_ammo()
	# create fire particles
	var fire_particles: GPUParticles2D = fire_particles_scene.instantiate()
	fire_particles.emitting = true
	fire_particles.position = projectile_spawner.global_position
	fire_particles.rotation = global_rotation
	get_tree().create_timer(fire_particles.lifetime).timeout.connect(fire_particles.queue_free)
	MessageBus.effect_spawned.emit(fire_particles)
	# start fire cooldown
	fire_timer.start()

## Return whether the weapon can fire, which is only true if there's ammo, and both the fire and
## reload timers have completed.
func can_use() -> bool:
	return cpt_ammo.has_ammo() and fire_timer.is_stopped() and reload_timer.is_stopped()

## Reload an individual round into the weapon.  Returns whether the reload was successful.
func round_reload() -> bool:
	cpt_ammo.round_reload()
	reload_timer.start()
	return true

## Reload an entire mag into the weapon.  Returns whether the reload was successful.
func mag_reload(mag: Magazine) -> bool:
	cpt_ammo.mag_reload(mag)
	reload_timer.start()
	return true

## Returns whether all cooldowns have ended, allowing the weapon to reload.
func can_reload() -> bool:
	return (reload_timer.is_stopped() and fire_timer.is_stopped())

"""Returns the old mag (so that it can be
## put in inventory o algo) and sets ammo equal to the ammount in the new mag"""

"""if mag.gun_type != gun_type:
		print("WARNING: Attempted to reload with incorrect type of ammo.  Should be ", ammo_type,
				" but is ", mag.ammo_type)
		return mag"""
