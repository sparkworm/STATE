## A class used for decals that move before becomming stationary.  This class provides the
## movement/collision logic required to prevent the decal from going through walls.
## [br][br]
## Once this body stops, it will kill itself and seamlessly spawn the equivalent decal for
## performance reasons.
class_name DecalTransport
extends CharacterBody2D

var decal: BloodDecal
var start_time: int

@onready var velocity_component: VelocityComponent = $VelocityComponent

## Drag graphed as a function of time.
@export var drag_curve: CurveTexture

func _ready() -> void:
	print("started")
	start_time = Time.get_ticks_msec()
	# set the velocity of velocity_component
	velocity_component.velocity = velocity
	# set own velocity to 0, just to be safe that this velocity is not what's used
	velocity = Vector2.ZERO
	if decal == null:
		print("WARNING, decal is null")
		return
	add_child(decal)

func _process(delta: float) -> void:
	velocity_component.decel = \
			drag_curve.curve.sample(float(Time.get_ticks_msec() - start_time) / 1000)

func _physics_process(delta: float) -> void:
	velocity_component.resolve_decel(delta)
	var collision: KinematicCollision2D = move_and_collide(velocity_component.velocity * delta)
	# if there's been a collision, or if transport is basically stoppped, transform to decal
	if collision != null or velocity_component.velocity.length() < 1.0:
		transform_to_decal()

func transform_to_decal() -> void:
	remove_child(decal)
	decal.position = position
	decal.rotation = rotation
	MessageBus.decal_spawned.emit(decal)
	queue_free()
