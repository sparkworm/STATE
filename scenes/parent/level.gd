class_name Level
extends GameScene

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		MessageBus.pause_menu_toggled.emit()
