extends Node

@warning_ignore_start("unused_signal")

## Called to make Game switch the ActiveScene
signal scene_changed(new_scene: SceneAccess.IDX)

signal pause_menu_toggled()

signal game_quit()

signal projectile_spawned(proj: Projectile)

signal effect_spawned(eff: Node2D)
