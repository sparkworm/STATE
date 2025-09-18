## State to make a Character guard, switching to a pursuing or attacking state if an enemy enters
## the vision_cone
class_name GuardState
extends State

## If an enemy enters this cone and there is line of sight, switch to a pursuing or attacking
## state
@export var vision_cone: Area2D
## A raycast for testing if there is line of sight with a given character
@export var los_check: LineOfSightCheck

@export var sound_detector: SoundDetector
## The maximum distance the enemy can be for the guard to initiate an attack.  Any further and
## the guard will merely pursue
@export var attack_distance: float = 200

@export_category("Other States")
## State to switch to when spotted enemy is out of attack range
@export var pursue_state: State
## State to switch to when spotted enemy is within attack range
@export var attack_state: State
## State to switch to when a sound is heard
@export var investigate_state: State

var enemy_is_in_vision_cone: bool = false

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: GuardState only meant to be used with Character as target")

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	for body: Node2D in vision_cone.get_overlapping_bodies():
		# if the character who entered is not a player, don't bother them.
		# NOTE: this would need to be revised if I ever wanted multiple factions or player allies
		if body.is_in_group("player"):
			player_in_vision(body)

## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	pass

func player_in_vision(body: Node2D) -> void:
	# if there is line of sight to the player
	if los_check.check_line_of_sight(target, body):
		if abs((body.global_position - target.global_position).length()) <= attack_distance:
			state_changed.emit(attack_state, {"attack_target":body})
		else:
			# WARNING, passing a greater number of signal parameters than specified
			state_changed.emit(pursue_state, {"pursue_target":body})

func sound_heard(body: Area2D) -> void:
	print("sound heard: ", body)
	if not body is SoundEmission:
		print("Areas must be fucked up, because body is not SoundEmission")
		return
	state_changed.emit(investigate_state, {"investigate_target": body.global_position})

## Called when the state is made active
func _enter(_args:={}) -> void:
	#vision_cone.body_entered.connect(body_entered_vision)
	#target.body.head.rotation = target.body.torso.rotation
	sound_detector.sound_detected.connect(sound_heard)

## Called before state is made inactive
func _exit() -> void:
	#vision_cone.body_entered.disconnect(body_entered_vision)
	sound_detector.sound_detected.disconnect(sound_heard)
