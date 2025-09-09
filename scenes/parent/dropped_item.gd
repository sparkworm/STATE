## Class for Wieldable items that are on the ground and can be picked up.  Will be overwritten
## in a unique scene for each Wieldable
class_name DroppedItem
extends RigidBody2D

## The scene that this DroppedItem should load into its new wielder's hand when picked up
@export var wieldable: Globals.Wieldables
@export var wieldable_ammo: int

## Returns the wieldable that was stored within
func create_wieldable() -> Wieldable:
	var new_wieldable: Wieldable = Globals.WieldableScene[wieldable].instantiate()
	if new_wieldable is WieldableGun:
		new_wieldable.cpt_ammo.ammo = wieldable_ammo
	return new_wieldable
