class_name Body
extends Node2D

## Maximum angle the head can turn from straight, in degrees
## NOTE: is converted to radians in _ready()
@export var max_head_look_angle: float = 70

@onready var legs: Sprite2D = $Legs
@onready var torso: Sprite2D = $Torso
@onready var arms: Sprite2D = $Torso/Arms
@onready var head: Sprite2D = $Head

func _ready() -> void:
	# convert max_head_look_angle to radians so it can be used normally
	max_head_look_angle = deg_to_rad(max_head_look_angle)

## Move the head to look towards a point.  The head will not turn further than it is allowed by
## max_head_look_angle. [br] [br]
## This can be useful if the torso is locked and cannot rotate (such as when running or guarding)
func head_look_towards(global_coords: Vector2) -> void:
	head.look_at(global_coords)
	var ang_diff: float = angle_difference(torso.rotation, head.rotation)
	if ang_diff > 0 and ang_diff > max_head_look_angle:
		head.rotation = max_head_look_angle
	elif ang_diff < 0 and -ang_diff > max_head_look_angle:
		head.rotation = -max_head_look_angle

func head_and_torso_look_towards(global_coords: Vector2) -> void:
	head.look_at(global_coords)
	torso.look_at(global_coords)
