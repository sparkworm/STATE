## State where the target goes to the last known position of an enemy.  Navigation will not be
## routinely updated
class_name InvestigateState
extends State

## If an enemy enters this cone and there is line of sight, switch to a pursuing state
@export var vision_cone: Area2D
## A raycast for testing if there is line of sight with a given character
@export var los_check: LineOfSightCheck
## The navigator for target
@export var nav_agent: NavigationAgent2D
## Area for applying avoidance forces
@export var avoidance_area: AvoidanceArea
## Calls an update to navigation on every timeout
@export var nav_timer: Timer
## The speed the target will travel at to reach in point of investigation
@export var investigate_speed: float = 50

@export_category("Other States")
@export var pursue_state: State
@export var scanning_state: State

## The the distance to investigate_target there was when this state was entered
var start_dist_to_inv_target: float
## The global coordinates of the point that must be investigated
var investigate_target: Vector2
## Is true if the player was "spotted" and the target knows which way they were headed
var known_last_dir := false
## Normal vector indicating the last direction the target was known to be moving.
var investigate_target_last_dir: Vector2

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	for body: Node2D in vision_cone.get_overlapping_bodies():
		# if the character who entered is not a player, don't bother them.
		# NOTE: this would need to be revised if I ever wanted multiple factions or player allies
		if body.is_in_group("player") and los_check.check_line_of_sight(target, body):
			state_changed.emit(pursue_state, {"pursue_target":body})

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	target.move_and_slide()
	# Only look towards investigate target if it is a bit away.  Prevents a 180 if
	# investigate_target is overshot
	if dist_to_inv_target() > 10:
		if known_last_dir:
			var dir_to_inv_target = (investigate_target - target.global_position).normalized()
			target.face_in_dir(lerp(dir_to_inv_target, investigate_target_last_dir, 
					1.0-(dist_to_inv_target() / start_dist_to_inv_target)).angle())
			
		else:
			target.face_towards(investigate_target)

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: PursueState only meant to be used with Character as target")

## Set navigation.
func nav_update() -> void:
	# if the investigate target has been reached
	if nav_agent.is_navigation_finished():
		#if known_last_dir:
			#target.face_towards(investigate_target_last_dir)
		state_changed.emit(scanning_state)
		return

	var direction = (nav_agent.get_next_path_position() - target.global_position).normalized()
	target.velocity = direction * investigate_speed
	target.velocity += avoidance_area.calculate_repulsion()

func safe_velocity_calculated(safe_velocity: Vector2) -> void:
	if safe_velocity != Vector2.ZERO:
		pass
		#print("safe velocity: ", safe_velocity)
		#target.velocity = safe_velocity# * investigate_speed


func dist_to_inv_target() -> float:
	return target.global_position.distance_to(investigate_target)

## Called when the state is made active
func _enter(args:={}) -> void:
	#nav_agent.velocity_computed.connect(safe_velocity_calculated)
	if args.has("investigate_target") and args["investigate_target"] != null:
		investigate_target = args["investigate_target"]
		nav_agent.target_position = investigate_target
		start_dist_to_inv_target = dist_to_inv_target()
		nav_timer.start()
		nav_timer.timeout.connect(nav_update)
		nav_update()
	else:
		push_error("WARNING: investigate_target is either unspecified or null")
	if args.has("investigate_target_last_dir"):
		known_last_dir = true
		investigate_target_last_dir = args["investigate_target_last_dir"]
	else:
		known_last_dir = false

## Called before state is made inactive
func _exit() -> void:
	nav_timer.timeout.disconnect(nav_update)
	#nav_agent.velocity_computed.disconnect(safe_velocity_calculated)
