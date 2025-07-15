extends Control



func _on_b_resume_pressed() -> void:
	MessageBus.pause_menu_toggled.emit()

func _on_b_options_pressed() -> void:
	pass # Replace with function body.

func _on_b_quit_to_menu_pressed() -> void:
	MessageBus.scene_changed.emit(SceneAccess.IDX.MENU)
	MessageBus.pause_menu_toggled.emit()

func _on_b_quit_to_desktop_pressed() -> void:
	MessageBus.game_quit.emit()
