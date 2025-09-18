## Func
class_name SoundEmission
extends Area2D

@export var radius: float = 50.0
@export var duration: float = 1.0

var kill_on_timeout := false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var emission_timer: Timer = $EmissionTimer

## Called before SoundEmission is added to the SceneTree.  Should only be called if this is meant
## to be temporary sound emission
func initialize_temporary_sound(range, time) -> void:
	kill_on_timeout = true
	duration = time
	radius = range

func _ready() -> void:
	set_radius(radius)
	emission_timer.wait_time = duration
	if kill_on_timeout:
		emission_timer.timeout.connect(queue_free)
	else:
		emission_timer.timeout.connect(hide_emission)

## Will delete the Sound Emission on finish.  Used for sounds spawned from a temporary location,
## as opposed to from a continuously potential source of sound like as a gun.
func create_temporary_sound(time := duration) -> void:
	get_tree().create_timer(time).timeout.connect(queue_free)

## Creates CircleShape and sets its radius
## NOTE: likely needs to be called after _ready()
func set_radius(radius: float) -> void:
	var circle_shape := CircleShape2D.new()
	circle_shape.radius = radius
	collision_shape_2d.shape = circle_shape

func emit() -> void:
	emission_timer.start()
	# NOTE: might need to be call deferred
	monitorable = true

func hide_emission() -> void:
	# NOTE: might need to be call deferred
	monitorable = false
