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

enum Weapons {
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
const WeaponAmmo: Dictionary[Weapons, AmmoTypes] = {
	Weapons.GLOCK17 : AmmoTypes.NINE_MM,
	Weapons.USP : AmmoTypes.ACP_45,
	Weapons.MAGNUM_REVOLVER : AmmoTypes.MAGNUM_44,
	Weapons.FIVE_SEVEN : AmmoTypes.FIVE_SEVEN,
	Weapons.MP5 : AmmoTypes.NINE_MM,
	Weapons.UMP45 : AmmoTypes.ACP_45,
	Weapons.THOMPSON : AmmoTypes.ACP_45,
	Weapons.M4 : AmmoTypes.NATO_556,
	Weapons.M24 : AmmoTypes.NATO_762X51,
	Weapons.MOSSBERG500 : AmmoTypes.TWELVE_GAUGE,
}

var current_scene_idx: SceneAccess.IDX = SceneAccess.IDX.MENU
var debug_pixel: PackedScene = preload("res://scenes/debug/debug_pixel.tscn")
