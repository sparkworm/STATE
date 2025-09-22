## TODO: Create a separate state for going to the last known position of a player as opposed to
## pursuing them while they are in line of sight
class_name PursueState
extends State

## A raycast for testing if there is line of sight with a given character
@export var los_check: LineOfSightCheck
## The navigator for target
@export var nav_agent: NavigationAgent2D
## Area for applying avoidance forces
@export var avoidance_area: AvoidanceArea
## Calls an update to navigation on every timeout
@export var nav_timer: Timer
## The maximum distance the enemy can be for the guard to initiate an attack.  Any further and
## the guard will merely pursue
@export var attack_range: float = 200
## The speed at which target moves towards its objective
@export var pursue_speed: float = 50

@export_category("Other States")
## Change to this state when enemy is within attack_range
@export var attack_state: State
## Change to this state when enemy is out of sight
@export var investigate_state: State

## The Character that target pursues
var pursue_target: Character

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: PursueState only meant to be used with Character as target")

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	if not los_check.check_line_of_sight(target, pursue_target):
		state_changed.emit(investigate_state, {
				"investigate_target":pursue_target.global_position,
				"investigate_target_last_dir": pursue_target.velocity.normalized()})
		print("last pursue_target velocity: ", pursue_target.velocity.normalized())
	# if there is line of sight and distance is less than attack distance
	elif pursue_target.global_position.distance_to(target.global_position) < attack_range:
		state_changed.emit(attack_state, {"attack_target":pursue_target})

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	target.face_towards(pursue_target.global_position)
	target.move_and_slide()

## Called on every timeout of nav_timer to update path
func nav_update() -> void:
	nav_agent.target_position = pursue_target.global_position
	# NOTE: probably will never happen
	if nav_agent.is_navigation_finished():
		print("navigation finished (this shouldn't happen)")
		return

	var direction = (nav_agent.get_next_path_position() - target.global_position).normalized()
	target.velocity = direction * pursue_speed
	target.velocity += avoidance_area.calculate_repulsion()

## Called when the state is made active
func _enter(args:={}) -> void:
	if args.has("pursue_target") and args["pursue_target"] != null:
		pursue_target = args["pursue_target"]
		nav_timer.start()
		nav_timer.timeout.connect(nav_update)
	else:
		push_error("WARNING: pursue_target is either unspecified or null")


## Called before state is made inactive
func _exit() -> void:
	nav_timer.stop()
	nav_timer.timeout.disconnect(nav_update)
