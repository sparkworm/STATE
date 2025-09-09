class_name Magazine
extends Object
## Represents a magazine that can be loaded into a gun.  These are held in an array of an
## inventory.  Magazine Pickups can also be found, adding their magazine object to said array.
## Currently, magazines are deleted when inserted into a weapon, then created when thrown out,
## with a difference in ammo equal to the amount of ammo used.

## The type of gun that this magazine will fit into
var gun_type: Globals.Wieldables
## Amount of ammo in the mag
var ammo_remaining: int

## initialize
func _init(type: Globals.Wieldables, amnt: int) -> void:
	gun_type = type
	ammo_remaining = amnt

func _to_string() -> String:
	var out_str: String = "Magazine:\n\tgun_type: %s\n\tammo_remaining: %s" % \
			[gun_type, ammo_remaining]
	return out_str

## Returns the specific cartridge used
func get_ammo_type() -> Globals.AmmoTypes:
	return Globals.WeaponAmmo[gun_type]
