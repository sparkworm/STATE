extends Node

enum AmmoTypes {
	# pistol
	NINE_MM, # Glock, MP5,
	ACP_45, # 1911, UMP-45, Thompson M1
	MAGNUM_44, # Magnum revolver
	FIVE_SEVEN, # FN Five Seven, p90
	# rifle
	NATO_556, # AR 15, M4
	NATO_762X51, # Bolt action sniper, SCAR, AR10
	# shotgun
	TWELVE_GAUGE, # Mossberg 500
}

var current_scene_idx: SceneAccess.IDX = SceneAccess.IDX.MENU
var debug_pixel: PackedScene = preload("res://scenes/debug/debug_pixel.tscn")
