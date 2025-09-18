## Class to manage state machines
class_name StateMachine
extends Node

## Exported to set first state, but will be set to new state when states change
@export var active_state: State
## The object that the state machine is meant to control
@export var target: Node

func _ready() -> void:
	#call_deferred("initialize_states")
	initialize_states()

func initialize_states() -> void:
	await target.ready
	# initialize every child state
	for state: State in get_children():
		if state == null:
			print("WARNING, non-state cast as State")
		else:
			# connect state's state_changed signal so that it may initiate a state change
			state.state_changed.connect(change_state_to)
			# set state's target so that it may actually perform actions with said target
			state._set_target(target)
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
	#print("Changing state to ", new_state)
	# used to avoid exiting on the first state
	if active_state != new_state:
		active_state._exit()
	active_state = new_state
	active_state._enter(args)
