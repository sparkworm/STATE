class_name CharacterInventory
extends Node

signal inventory_changed

## Stores all wieldables held by character
@export var wieldables: Array[Wieldable]

## Stores all kinds of ammo
@export var individual_ammo: Dictionary[Globals.AmmoTypes,int]

## NOTE: Array is Array[Magazine], but nested types are apparently not supported
var magazines: Dictionary[Globals.Weapons, Array]

## Returns whether there is ammo that can be reloaded into a given weapon
func has_ammo_for_weapon(weapon: WieldableGun) -> bool:
	if weapon.mag_reloadable:
		for mag: Magazine in magazines[weapon.ID]:
			if mag.gun_type == weapon.ID:
				print("Mag found: ", mag)
				return true
		return false
	if individual_ammo.has(weapon.ID):
		return individual_ammo[weapon.ID] > 0
	return false

## Removes and returns the magazine of the correct type with the most ammo
func get_mag_for_reload(weapon: WieldableGun) -> Magazine:
	var weapon_type = weapon.ID
	var chosen_mag: Magazine = null
	var chosen_mag_idx: int = -1
	#for mag: Magazine in magazines[weapon_type]:
	for idx: int in range(magazines[weapon_type].size()):
		if magazines[weapon_type][idx] == null:
			print("ERROR: supposed Magazine has been cast to null")
		else:
			# if there is no chosen mag, pick this, the first non-null idx
			if chosen_mag_idx == -1:
				chosen_mag_idx = idx
			# if there has already been a non-null mag, only choose this if it has more ammo
			else:
				if magazines[weapon_type][idx].ammo_remaining > \
						magazines[weapon_type][chosen_mag_idx].ammo_remaining:
					chosen_mag_idx = idx
	if chosen_mag_idx == -1:
		print("WARNING: no mag has been found")
	else:
		chosen_mag = magazines[weapon_type][chosen_mag_idx]
		magazines[weapon_type].remove_at(chosen_mag_idx)
	return chosen_mag

## Adds given Magazine to magazines
func add_mag(weapon_type: Globals.Weapons, new_mag: Magazine) -> void:
	# if key for weapon_type already exists, add there
	if magazines.has(weapon_type):
		magazines[weapon_type].append(new_mag)
	# otherwise, create entry
	else:
		magazines[weapon_type] = [new_mag]
	inventory_changed.emit()

## Decreases the value of CharacterInventory.individual_ammo[type] by amnt (default of 1)
func decrement_ammo(type: Globals.AmmoTypes, amnt:= 1) -> void:
	individual_ammo[type] -= amnt
	inventory_changed.emit()

func individual_ammo_count(ammo_type: Globals.AmmoTypes) -> int:
	if individual_ammo.has(ammo_type):
		return individual_ammo[ammo_type]
	print("WARNING: requested count for ammo type not present")
	return 0

func mag_count(weapon_type: Globals.Weapons) -> int:
	if magazines.has(weapon_type):
		return magazines[weapon_type].size()
	print("WARNING: requested count for ammo type not present")
	return 0
