## A class used for decals that move before becomming stationary.  This class provides the
## movement/collision logic required to prevent the decal from going through walls.
## [br][br]
## Once this body stops, it will kill itself and seamlessly spawn the equivalent decal for
## performance reasons.
class_name DecalTransport
extends CharacterBody2D

## Drag graphed as a function of time.
@export var drag_curve: CurveTexture

var decal: BloodDecal
var start_time: int
## The change in rotation, in radians per second.
var rotational_velocity: float
## The amount by which rotational_velocity decreases per second
var rotational_drag: float

@onready var velocity_component: VelocityComponent = $VelocityComponent

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	# set the velocity of velocity_component
	velocity_component.velocity = velocity
	# set own velocity to 0, just to be safe that this velocity is not what's used
	velocity = Vector2.ZERO
	if decal == null:
		print("WARNING, decal is null")
		return
	add_child(decal)

func _process(_delta: float) -> void:
	velocity_component.decel = \
			drag_curve.curve.sample(float(Time.get_ticks_msec() - start_time) / 1000)

func _physics_process(delta: float) -> void:
	velocity_component.resolve_decel(delta)
	var collision: KinematicCollision2D = move_and_collide(velocity_component.velocity * delta)
	# if there's been a collision, or if transport is basically stoppped, transform to decal
	if collision != null or velocity_component.velocity.length() < 1.0:
		transform_to_decal()
	
	# handle rotation
	rotation += rotational_velocity * delta
	rotational_velocity = max(0, rotational_velocity - rotational_drag * delta)

## Make Level add an equivalent BloodDecal, then kill self
func transform_to_decal() -> void:
	remove_child(decal)
	decal.position = position
	decal.rotation = rotation
	MessageBus.decal_spawned.emit(decal)
	queue_free()
