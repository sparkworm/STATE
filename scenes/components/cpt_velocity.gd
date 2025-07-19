class_name VelocityComponent
extends Node
## A component for common functions associated with the velocity of a character
## or object


## Hard cap on the magnitude of velocity
@export var max_speed: float
## The assumed acceleration of the object used in accel()
@export var acceleration: float
## A flat decceleration meant to be applied every frame
@export var decel: float

var velocity: Vector2

func resolve_decel(delta: float) -> void:
	var new_mag: float = max(0,velocity.length() - decel * delta)
	velocity = velocity.normalized() * new_mag

func accel(delta: float, direction: Vector2) -> void:
	velocity += direction * acceleration * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

func custom_accel(delta: float, amnt: Vector2) -> void:
	velocity += amnt * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
