class_name AttackState
extends State

## Used to check line of sight to player.  If player is NOT in LOS, then transition to pursuing
@export var los_check: LineOfSightCheck
## The maximum distance the enemy can be for the guard to initiate an attack.  Any further and
## the guard will merely pursue
@export var attack_distance: float = 200

@export_category("Other States")
## Entered if enemy goes out of range
@export var pursue_state: State
## Entered if enemy goes out of sight
@export var investigate_state: State
## Entered if enemy is killeds
@export var guard_state: State

## The Character that target is attempting to attack.  Should always be provided when AttackState
## is entered
var attack_target: Character = null
## The weapon held by target.
## NOTE: if there are to be other weapon types this should be revised
var weapon_held: WieldableGun

func _set_target(new_value) -> void:
	super._set_target(new_value)
	if not target is Character:
		push_error("WARNING: AttackState only meant to be used with Character as target")

## State equivalent of _process().  Only called when state is active
func _update(_delta: float) -> void:
	if attack_target == null:
		print("Target killed")
		state_changed.emit(guard_state)
		return
	# If the player has gone out of line of sight, switch to purusing.
	if not los_check.check_line_of_sight(target, attack_target):
		# NOTE: passing a greater number of parameters than specified
		state_changed.emit(pursue_state, {"pursue_target":attack_target})
	target.face_towards(attack_target.global_position)
	## TODO: Add functionality for fully-automatic weapons
	if weapon_held.can_use():
		weapon_held._start_use()


## State equivalent of _physics_process().  Only called when state is active
func _physics_update(_delta: float) -> void:
	pass

## Called when the state is made active
func _enter(args:={}) -> void:
	if args.has("attack_target") and args["attack_target"] != null:
		attack_target = args["attack_target"]
		weapon_held = target.get_item_held()
	else:
		push_error("WARNING: attack_target is either unspecified or null")

## Called before state is made inactive
func _exit() -> void:
	pass
