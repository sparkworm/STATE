extends Node

@warning_ignore_start("unused_signal")

#region Game
## Called to make Game switch the ActiveScene
signal scene_changed(new_scene: SceneAccess.IDX)
## Toggles both the paused state of the game and the visibility of the pause menu
signal pause_menu_toggled()
## Called to quit the game.  Should be used over get_tree().quit().
signal game_quit()
#endregion

#region Level
## Called to spawn a projectile in Level
signal projectile_spawned(proj: Projectile)
## Called to spawn an effect in Level
signal effect_spawned(eff: Node2D)
## Called when anything that is displayed on the HUD might be changed
## TODO: fix up (currently there are a bunch of sloppy and redundant calls to this)
signal update_hud
## Called when player's health changes
signal player_health_changed(new_health: float)
## Spawns a dropped item in Level
signal dropped_item_spawned(dropped_item: DroppedItem, pos: Vector2)
## Spawns a decal, such as that of a blood puddle in Level
signal decal_spawned(decal: Node2D)
## Spawns particles in Level which is terminated upon completion
signal temporary_particles_spawned(particles: GPUParticles2D)
#endregion

## Called to place a single white pixel at a given location.  Useful for debugging purposes
signal debug_pixel_spawned(pos: Vector2)
