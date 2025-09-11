class_name DecalSpawner
extends Node2D

## The decal that is meant to be spawned by this DecalSpawner
@export var decal_scene: PackedScene = preload("res://scenes/effects/blood_decal.tscn")
## The min number of decals to be spawned by this DecalSpawner
@export var num_decal_min: int
## The max number of decals to be spawned by this DecalSpawner
@export var num_decal_max: int
## The magnitude of the velocity that will be assigned to the DecalTransport objects
@export var decal_launch_velocity: float
## decal_launch_velocity will have randf_range(-value, +value) for this value added to it when
## assigning velocity to a DecalTransport
@export var launch_velocity_variation: float
## The spawned DecalTransport may have a rotational velocity from (-value, +value) for this value
@export var rotational_velocity_max: float

@export_range(0,180) var spread: float
@export_range(0,1) var reverse_direction_chance: float


func _ready() -> void:
	spread = deg_to_rad(spread)

func spawn_decals(direction := Vector2.ZERO) -> void:
	var num_to_spawn: int = randi_range(num_decal_min, num_decal_max)
	for num in range(num_to_spawn):
		var transport: DecalTransport = \
				preload("res://scenes/effects/decal_transport.tscn").instantiate()
		var angle: float
		if direction == Vector2.ZERO:
			print("NOTE: direction not specified in spawn_decals()")
			angle = randf_range(0,2*PI)
		else:
			angle = direction.angle() + randf_range(-spread, spread)
		if randf() < reverse_direction_chance:
			angle += PI
		var force: float = decal_launch_velocity \
				+ randf_range(-launch_velocity_variation, launch_velocity_variation)
		#transport.apply_impulse(Vector2.from_angle(angle) * decal_launch_velocity)
		transport.decal = decal_scene.instantiate()
		transport.decal.pick_random_frame()
		transport.position = global_position
		transport.rotational_velocity = \
				randf_range(-rotational_velocity_max, rotational_velocity_max)

		transport.velocity = Vector2.from_angle(angle) * (decal_launch_velocity \
				+ randf_range(-launch_velocity_variation, launch_velocity_variation))
		print(transport.velocity.length())
		MessageBus.decal_spawned.emit(transport)
