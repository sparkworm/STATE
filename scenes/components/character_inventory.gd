class_name CharacterInventory
extends Node

## Stores all wieldables held by character
@export var wieldables: Array[Wieldable]

## Stores all kinds of ammo
@export var individual_ammo: Dictionary[Globals.AmmoTypes,int]

var magazines: Array[Magazine]

## Returns whether there is ammo that can be reloaded into a given weapon
func has_ammo_for_weapon(weapon: WieldableGun) -> bool:
	if weapon.mag_reloadable:
		for mag in magazines:
			if mag.gun_type == weapon.ID:
				print("Mag found: ", mag)
				return true
		return false
	if individual_ammo.has(weapon.ID):
		return individual_ammo[weapon.ID] > 0
	return false

## Removes and returns first magazine of the correct type
## WARNING: mag reloading is untested
func get_mag_for_reload(weapon: WieldableGun) -> Magazine:
	for idx in range(magazines.size()):
		print(idx)
		var mag: Magazine = magazines[idx]
		if mag.gun_type == weapon.ID:
				magazines.remove_at(idx)
				return mag
	print("No available mag, returning null")
	return null

func add_mag(new_mag: Magazine) -> void:
	magazines.append(new_mag)
