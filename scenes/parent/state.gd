## Parent node for state
class_name State
extends Node

## Called with a reference of a specific state to change to that state
## NOTE: This must never be called if the state is inactive.
signal state_changed(new_state: State)

## The object that the state machine is meant to control
var target: Node

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	pass

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	pass

func _set_target(new_value: Node) -> void:
	target = new_value

## Called when the state is made active
func _enter(args:={}) -> void:
	pass

## Called before state is made inactive
func _exit() -> void:
	pass
