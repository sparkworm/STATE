## A class used for decals that move before becomming stationary.  This class provides the
## movement/collision logic required to prevent the decal from going through walls.
## [br][br]
## Once this body stops, it will kill itself and seamlessly spawn the equivalent decal for
## performance reasons.
class_name DecalTransport
extends RigidBody2D

var decal: BloodDecal

func _ready() -> void:
	print("started")
	if decal == null:
		print("WARNING, decal is null")
		return
	add_child(decal)

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() < 1.0:
		transform_to_decal()

func transform_to_decal() -> void:
	remove_child(decal)
	decal.position = position
	decal.rotation = rotation
	MessageBus.decal_spawned.emit(decal)
	queue_free()
