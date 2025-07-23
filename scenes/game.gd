class_name Game
extends Node

var paused: bool = false

@onready var active_scene_holder: CanvasLayer = $ActiveScene
@onready var ui: CanvasLayer = $UI
@onready var pause_menu: Control = $UI/PauseMenu

func _ready() -> void:
	MessageBus.scene_changed.connect(switch_scene)
	MessageBus.pause_menu_toggled.connect(toggle_pause_menu)
	MessageBus.game_quit.connect(quit_game)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") \
			and Globals.current_scene_idx != SceneAccess.IDX.MENU:
		MessageBus.pause_menu_toggled.emit()

func switch_scene(scene_idx: SceneAccess.IDX) -> void:
	Globals.current_scene_idx = scene_idx
	# end current scene
	active_scene_holder.remove_child(active_scene_holder.get_child(0))
	var new_scene: PackedScene = SceneAccess.dict.get(scene_idx)
	# add new scene
	active_scene_holder.add_child(new_scene.instantiate())

## Toggles both the game's pause state and the visibility of the pause menu
func toggle_pause_menu() -> void:
	paused = not paused
	if paused:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()

## Should be used instead of locally calling get_tree().quit() since save
## functionality may eventually be added
func quit_game() -> void:
	get_tree().quit()
