## Class to manage state machines
class_name StateMachine
extends Node

## Exported to set first state, but will be set to new state when states change
@export var active_state: State

func _ready() -> void:
	# connect state_changed signals of state to the appropriate function
	for state: State in get_children():
		if state == null:
			print("WARNING, non-state cast as State")
		else:
			state.state_changed.connect(change_state_to)
	if active_state != null:
		change_state_to(active_state)
	else:
		print("WARNING: active_state is null")

func _process(delta: float) -> void:
	active_state._update(delta)

func _physics_process(delta: float) -> void:
	active_state._physics_update(delta)

## Changes active state to specified state
func change_state_to(new_state: State, args:={}) -> void:
	active_state._exit()
	active_state = new_state
	active_state._enter(args)
