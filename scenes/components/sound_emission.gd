## Serves to activate all SoundDetector nodes in its area
class_name SoundEmission
extends Area2D

@export var radius: float = 50.0
#@export var duration: float = 1.0

var kill_on_detect := false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Called before SoundEmission is added to the SceneTree.  Should only be called if this is meant
## to be temporary sound emission
func emit_temporary_sound(range) -> void:
	kill_on_detect = true
	radius = range
	emit()

func _ready() -> void:
	set_radius(radius)

## Will delete the Sound Emission on finish.  Used for sounds spawned from a temporary location,
## as opposed to from a continuously potential source of sound like as a gun.
#func create_temporary_sound(time := duration) -> void:
	#get_tree().create_timer(time).timeout.connect(queue_free)

## Creates CircleShape and sets its radius
## NOTE: likely needs to be called after _ready()
func set_radius(radius: float) -> void:
	var circle_shape := CircleShape2D.new()
	circle_shape.radius = radius
	collision_shape_2d.shape = circle_shape

func emit() -> void:
	for area: Area2D in get_overlapping_areas():
		area = area as SoundDetector
		if area == null:
			print("Layers may be messed up: failed cast")
		else:
			area.sound_detected.emit(self)
	if kill_on_detect:
		queue_free()
	
