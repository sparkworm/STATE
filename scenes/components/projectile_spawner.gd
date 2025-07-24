class_name ProjectileSpawner
extends Node2D
## Spawns a specified projectile on its current position in a specified direction

@export var projectile_scene: PackedScene

@export_category("Projectile attributes")
## The damage that the projectile will deal to what it hits
@export var damage: float
## Speed at which the projectile will travel
@export var speed: float = 500

func spawn_projectile(dir: Vector2) -> void:
	var new_proj: Projectile = projectile_scene.instantiate()
	if new_proj == null:
		print("WARNING: Non-Projectile attempted to spawn as projectile")
		return
	new_proj.position = global_position
	new_proj.velocity = dir * speed
	new_proj.damage = damage
	MessageBus.projectile_spawned.emit(new_proj)
