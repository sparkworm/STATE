class_name PlayerController
extends Node

@export var player: Character
@export var body: Body

func _physics_process(delta: float) -> void:
	body.head_look_towards(body.get_global_mouse_position())
