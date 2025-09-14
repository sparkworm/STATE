## TODO: Create a separate state for going to the last known position of a player as opposed to
## pursuing them while they are in line of sight
class_name PursueState
extends State


## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	pass

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	pass

## Called when the state is made active
func _enter(args:={}) -> void:
	pass

## Called before state is made inactive
func _exit() -> void:
	pass
