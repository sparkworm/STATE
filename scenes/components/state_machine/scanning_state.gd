class_name ScanningState
extends State

## An enum for describing where the target it in its scan.
## [br]TO_FIRST indicates that the target is turning its head for the first time, until the first
## maximum is reached
## [br]TO_SECOND indicates that target has reached the first maximum and is now turning 
## towards the second.
## [br]RETURN indicates that target has looked both ways and now returns its head to the center
enum ScanStatus {
	TO_FIRST,
	TO_SECOND,
	RETURN,
}

## If an enemy enters this cone and there is line of sight, switch to a pursuing or attacking
## state
@export var vision_cone: Area2D
## A raycast for testing if there is line of sight with a given character
@export var los_check: LineOfSightCheck
## The amount target will turn in either direction
@export var turn_amount: float = PI/3
## Turning speed in radians per second
@export var turn_speed: float = PI/2

@export_category("Other States")
## State to switch to when spotted enemy is out of attack range
@export var pursue_state: State

@export var guard_state: State

var scan_status: ScanStatus = ScanStatus.TO_FIRST
var angle_progress: float = 0.0
var original_angle: float

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: ScanningState only meant to be used with Character as target")

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	for body: Node2D in vision_cone.get_overlapping_bodies():
		# if the character who entered is not a player, don't bother them.
		# NOTE: this would need to be revised if I ever wanted multiple factions or player allies
		if body.is_in_group("player") and los_check.check_line_of_sight(target, body):
			state_changed.emit(pursue_state, {"pursue_target":body})

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(delta: float) -> void:
	match(scan_status):
		ScanStatus.TO_FIRST:
			angle_progress += delta * turn_speed / (turn_amount)
			target.body.head.rotation = \
					lerp_angle(original_angle, original_angle+turn_amount, angle_progress)
			if angle_progress >= 1.0:
				angle_progress = 0
				scan_status = ScanStatus.TO_SECOND
		ScanStatus.TO_SECOND:
			angle_progress += delta * turn_speed / (2*turn_amount)
			target.body.head.rotation = \
					lerp_angle(original_angle+turn_amount, original_angle-turn_amount, angle_progress)
			if angle_progress >= 1.0:
				angle_progress = 0.0
				scan_status = ScanStatus.RETURN
		ScanStatus.RETURN:
			angle_progress += delta * turn_speed / (turn_amount)
			target.body.head.rotation = \
					lerp_angle(original_angle-turn_amount, original_angle, angle_progress)
			if angle_progress >= 1.0:
				state_changed.emit(guard_state)

## Called when the state is made active
func _enter(args:={}) -> void:
	# tween head's rotation
	original_angle = target.body.torso.rotation
	#var rot1: float = angle_difference()

	#var head_rotate_tween: Tween = get_tree().create_tween()
	#head_rotate_tween.tween_property\
			#(target.body.head, "rotation", current_rotation-turn_amount, 0.5)
	#head_rotate_tween.tween_property\
			#(target.body.head, "rotation", current_rotation+2*turn_amount, 1.0)


## Called before state is made inactive
func _exit() -> void:
	angle_progress = 0.0
	scan_status = ScanStatus.TO_FIRST
