extends Node

## Called to make Game switch the ActiveScene
signal scene_changed(new_scene: SceneAccess.IDX)

signal pause_menu_toggled()

signal game_quit()
