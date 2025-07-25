class_name CptAmmo
extends Node
## Used to represent the amount of ammo held in a given weapon

## The amount of ammo currently in the weapon
@export var ammo: int
## The number of rounds that can be put in the weapon if relaoded one round at a time.
## Think of revolvers and guns with tubes.
## [br][br]
## The default value of one represents how most guns could hold a single round if placed
## directly in the chamber.
@export var round_cap: int = 1

func has_ammo() -> bool:
	return ammo > 0

func decrement_ammo() -> void:
	ammo -= 1
	if ammo < 0:
		print("WARNING: ammo is negative: ", ammo)

## Represents replacing the current mag with a new one, with amnt being the amount of rounds in
## the mag
func mag_reload(amnt: int) -> void:
	ammo = amnt

## Represents adding a round, such as with a shotgun or revolver
func round_reload() -> void:
	if ammo < round_cap:
		ammo += 1
	else:
		print("WARNING: attempted to round reload beyond round capacity: ", round_cap)
