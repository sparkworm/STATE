## State where the target goes to the last known position of an enemy.  Navigation will not be
## routinely updated
class_name InvestigateState
extends State

## A raycast for testing if there is line of sight with a given character
@export var los_check: LineOfSightCheck
## The navigator for target
@export var nav_agent: NavigationAgent2D
## Calls an update to navigation on every timeout
@export var nav_timer: Timer
## The speed the target will travel at to reach in point of investigation
@export var investigate_speed: float = 50

@export_category("Other States")
@export var pursue_state: State
@export var scanning_state: State

## The global coordinates of the point that must be investigated
var investigate_target: Vector2

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	#if los_check.check_line_of_sight():
	pass

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	target.move_and_slide()
	target.face_towards(investigate_target)

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: PursueState only meant to be used with Character as target")

## Set navigation.
func nav_update() -> void:
	print("updating navigation")
	# NOTE: probably will never happen
	if nav_agent.is_navigation_finished():
		state_changed.emit(scanning_state)
		return

	var direction = (nav_agent.get_next_path_position() - target.global_position).normalized()
	target.velocity = direction * investigate_speed
	#target.face_towards(nav_agent.get_next_path_position() - target.global_position)

## Called when the state is made active
func _enter(args:={}) -> void:
	if args.has("investigate_target") and args["investigate_target"] != null:
		investigate_target = args["investigate_target"]
		nav_agent.target_position = investigate_target
		nav_timer.start()
		nav_timer.timeout.connect(nav_update)
	else:
		push_error("WARNING: investigate_target is either unspecified or null")

## Called before state is made inactive
func _exit() -> void:
	nav_timer.timeout.disconnect(nav_update)
