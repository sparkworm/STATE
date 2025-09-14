## State to make a Character guard, switching to a pursuing or attacking state if an enemy enters
## the vision_cone
class_name GuardState
extends State

## If an enemy enters this cone and there is line of sight, switch to a pursuing or attacking
## state
@export var vision_cone: Area2D
## A raycast for testing if there is line of sight with a given character
@export var los_check: RayCast2D
## The maximum distance the enemy can be for the guard to initiate an attack.  Any further and
## the guard will merely pursue
@export var attack_distance: float = 200

@export_category("Other States")
## State to switch to when spotted enemy is out of attack range
@export var pursue_state: State
## State to switch to when spotted enemy is within attack range
@export var attack_state: State

var enemy_is_in_vision_cone: bool = false

func _ready() -> void:
	if not target is Character:
		print("WARNING: Guard State only meant to be used with Character as target")

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
	# check line of sight to player
	los_check.global_position = target.global_position
	los_check.target_position = body.global_position - target.global_position
	los_check.force_raycast_update()
	var first_hit: Node2D = los_check.get_collider()
	print(first_hit)
	# if there is line of sight to the player
	if first_hit != null and first_hit.is_in_group("player"):
		if abs((body.global_position - target.global_position).length()) <= attack_distance:
			state_changed.emit(attack_state, {"attack_target":body})
		else:
			# WARNING, passing a greater number of signal parameters than specified
			state_changed.emit(pursue_state, {"pursue_target":body})

## Called when the state is made active
func _enter(args:={}) -> void:
	#vision_cone.body_entered.connect(body_entered_vision)
	pass

## Called before state is made inactive
func _exit() -> void:
	#vision_cone.body_entered.disconnect(body_entered_vision)
	pass
