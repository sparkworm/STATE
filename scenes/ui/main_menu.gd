extends GameScene

func _on_b_play_pressed() -> void:
	MessageBus.scene_changed.emit(next_scene)

func _on_b_options_pressed() -> void:
	pass # Replace with function body.

func _on_b_quit_pressed() -> void:
	MessageBus.game_quit.emit()
