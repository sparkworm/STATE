extends Node

enum AmmoTypes {
	# pistol
	NINE_MM, # Glock, MP5,
	ACP_45, # 1911?, UMP-45, Thompson M1, USP
	MAGNUM_44, # Magnum revolver
	FIVE_SEVEN, # FN Five Seven, p90
	# rifle
	NATO_556, # AR 15, M4
	NATO_762X51, # Bolt action sniper, SCAR, AR10
	# shotgun
	TWELVE_GAUGE, # Mossberg 500
}

enum Wieldables {
	# pistol
	GLOCK17,
	USP,
	MAGNUM_REVOLVER,
	FIVE_SEVEN,
	# SMG
	MP5,
	UMP45,
	THOMPSON,
	# rifle
	M4,
	M24, # bolt action sniper rifle in 7.62x51
	# shotgun
	MOSSBERG500
}

## The cartridge used by a specific weapon
const WeaponAmmo: Dictionary[Wieldables, AmmoTypes] = {
	Wieldables.GLOCK17 : AmmoTypes.NINE_MM,
	Wieldables.USP : AmmoTypes.ACP_45,
	Wieldables.MAGNUM_REVOLVER : AmmoTypes.MAGNUM_44,
	Wieldables.FIVE_SEVEN : AmmoTypes.FIVE_SEVEN,
	Wieldables.MP5 : AmmoTypes.NINE_MM,
	Wieldables.UMP45 : AmmoTypes.ACP_45,
	Wieldables.THOMPSON : AmmoTypes.ACP_45,
	Wieldables.M4 : AmmoTypes.NATO_556,
	Wieldables.M24 : AmmoTypes.NATO_762X51,
	Wieldables.MOSSBERG500 : AmmoTypes.TWELVE_GAUGE,
}

## Contains the Wieldable scene associated with a given ID
const WieldableScene: Dictionary[Wieldables, PackedScene] = {
	Wieldables.GLOCK17 : preload("res://scenes/wieldable/glock_17.tscn")
}

## Contains the DroppedItem scene associated with a given ID
const DroppedItemScene: Dictionary[Wieldables, PackedScene] = {
	Wieldables.GLOCK17 : preload("res://scenes/interactable/dropped_glock_17.tscn")
}

## Declares the ammount of ammo that a mag for a given weapon ought to hold.
## [br][br]
## This is a strange way of doing this (alternatively ammo_cpt could have a capacity attribute,
## or WieldableGun could) but this may allow for some flexibility in the future regarding
## differing mag sizes, though I'm not sure I want to do that.
const MagazineCapacity: Dictionary[Wieldables, int] = {
	Wieldables.GLOCK17 : 17
}

var current_scene_idx: SceneAccess.IDX = SceneAccess.IDX.MENU
var debug_pixel: PackedScene = preload("res://scenes/debug/debug_pixel.tscn")
