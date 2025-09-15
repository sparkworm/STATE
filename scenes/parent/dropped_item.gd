## Class for Wieldable items that are on the ground and can be picked up.  Will be overwritten
## in a unique scene for each Wieldable
class_name DroppedItem
extends RigidBody2D

## The scene that this DroppedItem should load into its new wielder's hand when picked up
@export var wieldable: Globals.Wieldables
@export var wieldable_ammo: int

## If true, the Wieldable spawned will have full ammo.  This is true by default, but DroppedItem
## objects created in Level (ie by actually dropping items) will have this set to false, 
## resulting in them maintaining their previous amount of ammo
var spawn_with_full_ammo: bool = true

## Returns the wieldable that was stored within
func create_wieldable() -> Wieldable:
	var new_wieldable: Wieldable = Globals.WieldableScene[wieldable].instantiate()
	if new_wieldable is WieldableGun:
		if not spawn_with_full_ammo:
			new_wieldable.spawn_with_full_ammo = false
		new_wieldable.cpt_ammo.ammo = wieldable_ammo
	return new_wieldable
