## A node capable of spawning projectiles from its position in a given direction.
## Placed at tip of gun to spawn bullets.
class_name ProjectileSpawner
extends Node2D

@export var projectile_scene: PackedScene

## The number of degrees to either side of the specified angle the projectile may travel.
@export var spread: float = 0.0

@export_category("Projectile attributes")
## The damage that the projectile will deal to what it hits
@export var damage: float
## Speed at which the projectile will travel
@export var speed: float = 500

func _ready() -> void:
	# convert spread to radians
	spread = deg_to_rad(spread)

## Performs setup for the Projectile, then sends it to Level through MessageBus.projectile_spawned
func spawn_projectile(dir: Vector2) -> void:
	var new_proj: Projectile = projectile_scene.instantiate()
	if new_proj == null:
		print("WARNING: Non-Projectile attempted to spawn as projectile")
		return
	new_proj.position = global_position
	var rot: float = dir.angle() + randf_range(-spread, spread)
	new_proj.velocity = Vector2.from_angle(rot) * speed
	new_proj.damage = damage
	MessageBus.projectile_spawned.emit(new_proj)
